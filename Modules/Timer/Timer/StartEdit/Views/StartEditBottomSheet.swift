import UIKit
import Utils
import Assets
import RxCocoa
import RxSwift

protocol BottomSheetContent: class {
    var scrollView: UIScrollView? { get }
    var smallStateHeight: CGFloat { get }
    func loseFocus()
    func focus()
}

enum BottomSheetState {
    case hidden
    case partial
    case full
}

class StartEditBottomSheet<ContainedView: UIViewController>: UIViewController, UIGestureRecognizerDelegate where ContainedView: BottomSheetContent {

    var store: StartEditStore!
    
    private var topConstraint: NSLayoutConstraint!
    private var fullViewHeight: CGFloat = 0
    private var fullScreenConstant: CGFloat = 0
    private var partialViewConstant: CGFloat = 0
    private var hiddenViewConstant: CGFloat = 0

    private let containedViewController: ContainedView
    private let overlay = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

    private var disposeBag = DisposeBag()

    var state: BottomSheetState = .hidden {
        didSet {
            layout()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewController: ContainedView) {
        containedViewController = viewController
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .clear
        view.isOpaque = false

        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture))
        gesture.delegate = self
        containedViewController.view.addGestureRecognizer(gesture)

        Observable.merge(
                NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification),
                NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            )
            .map(keyboardIntersectionHeight(notification:))
            .subscribe(onNext: keyboardWillChange(intersectionHeight:))
            .disposed(by: disposeBag)

        let navigationController = UINavigationController(rootViewController: containedViewController)
        navigationController.navigationBar.isHidden = true

        install(navigationController, customConstraints: true)

        navigationController.view.translatesAutoresizingMaskIntoConstraints = false
        navigationController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navigationController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        let bottomConstraint = navigationController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomConstraint.priority = .defaultHigh
        bottomConstraint.isActive = true
        topConstraint = navigationController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        topConstraint.isActive = true

        containedViewController.view.layer.cornerRadius = 10
        containedViewController.view.clipsToBounds = true
        navigationController.view.layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
        navigationController.view.layer.shadowOffset = CGSize(width: 0, height: -6)
        navigationController.view.layer.shadowRadius = 10.0
        navigationController.view.layer.shadowOpacity = 0.2
        navigationController.view.clipsToBounds = false

        overlay.backgroundColor = UIColor(white: 0, alpha: 0.3)
        overlay.alpha = 0
        view.insertSubview(overlay, at: 0)
        overlay.constraintToParent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        topConstraint.constant = view.bounds.height
        view.layoutIfNeeded()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fullViewHeight = view.bounds.height
        fullScreenConstant = 0
        partialViewConstant = fullViewHeight - view.safeAreaInsets.top - view.safeAreaInsets.bottom - containedViewController.smallStateHeight
        hiddenViewConstant = view.bounds.height
        layout()
    }

    func hide() {
        state = .hidden
        containedViewController.loseFocus()
        containedViewController.resignFirstResponder()
    }

    func show() {
        state = .partial
        containedViewController.focus()
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    private func layout() {
        guard view.superview != nil else { return }
        
        switch state {
        case .hidden:
            view.isUserInteractionEnabled = false
            topConstraint.constant = hiddenViewConstant
        case .partial:
            view.isUserInteractionEnabled = true
            topConstraint.constant = partialViewConstant
        case .full:
            view.isUserInteractionEnabled = true
            topConstraint.constant = fullScreenConstant
        }

        containedViewController.scrollView?.isScrollEnabled = true
        containedViewController.scrollView?.setContentOffset(.zero, animated: false)

        UIView.animate(withDuration: 0.3) {
            self.overlay.alpha = self.state == .hidden ? 0 : 1
        }
        
        UIView.animate(
            withDuration: 0.35,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 1,
            options: [],
            animations: {
                self.view.superview?.layoutIfNeeded()
        },
            completion: nil)

    }
    
    override func didMove(toParent parent: UIViewController?) {
        
        guard let parent = parent else { return }

        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: parent.view.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: parent.view.trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: parent.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        view.topAnchor.constraint(equalTo: parent.view.topAnchor).isActive = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc
    func panGesture(recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: view).y
        let velocity = recognizer.velocity(in: view).y
        
        switch recognizer.state {
        case .changed:
            topConstraint.constant += translation
            if translation > 0 {
                self.containedViewController.loseFocus()
            }

        case .ended, .cancelled:
            let finalPosition = self.topConstraint.constant + translation + velocity * 0.1
            if finalPosition < fullScreenConstant + partialViewConstant / 2 {
                state = .full
            } else if finalPosition < hiddenViewConstant {
                state = .partial
            } else {
                store.dispatch(.dialogDismissed)
            }

            layout()

        default:
            break
        }
        
        recognizer.setTranslation(CGPoint.zero, in: view)
    }

    private func keyboardIntersectionHeight(notification: Notification) -> CGFloat {
        guard let userInfo = notification.userInfo else { return 0 }
        let keyboardFrame =  (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)!.cgRectValue

        let keyboardFrameInView = parent!.view.convert(keyboardFrame, from: nil)
        let safeAreaFrame = parent!.view.safeAreaLayoutGuide.layoutFrame
        let intersection = safeAreaFrame.intersection(keyboardFrameInView)

        return intersection.height
    }

    private func keyboardWillChange(intersectionHeight: CGFloat) {
        if state == .partial {
            topConstraint.constant = partialViewConstant - intersectionHeight
        }

        UIView.animate(withDuration: 0.3) {
            self.parent?.view.layoutIfNeeded()
        }
    }

    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        guard let scrollView = containedViewController.scrollView,
            let gesture = gestureRecognizer as? UIPanGestureRecognizer
            else {
                return false
        }
        let direction = gesture.velocity(in: view).y

        let yposition = topConstraint.constant
        if (yposition == fullScreenConstant && scrollView.contentOffset.y == 0 && direction > 0) || (yposition == partialViewConstant) {
            scrollView.isScrollEnabled = false
        } else {
            scrollView.isScrollEnabled = true
        }

        return false
    }
}
