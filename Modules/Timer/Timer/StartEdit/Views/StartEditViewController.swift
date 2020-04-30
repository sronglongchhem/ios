import UIKit
import Assets
import Utils
import Architecture
import RxSwift
import RxCocoa
import RxDataSources
import OtherServices

public typealias StartEditStore = Store<StartEditState, StartEditAction>

public class StartEditViewController: UIViewController, Storyboarded, BottomSheetContent {

    public static var storyboardName = "Timer"
    public static var storyboardBundle = Assets.bundle

    private let billableTooltipDuration: TimeInterval = 2

    var scrollView: UIScrollView?
    var smallStateHeight: CGFloat { headerHeight + cells[0].height }

    @IBOutlet weak var handle: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var durationView: UIView!

    @IBOutlet var startEditInputAccessoryView: StartEditInputAccessoryView!

    public override var inputAccessoryView: UIView? { startEditInputAccessoryView }

    public var store: StartEditStore!
    public var time: Time!

    private var disposeBag = DisposeBag()
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, StartEditCellType>>!
    private var cells = [
        StartEditCellType.dummyCell("PROJECT AND TAGS"),
        StartEditCellType.dummyCell("START"),
        StartEditCellType.dummyCell("END"),
        StartEditCellType.dummyCell("DURATION"),
        StartEditCellType.dummyCell("BILLABLE")
    ]
    private var headerHeight: CGFloat = 107
    private var timer: Timer?

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView = tableView
        handle.layer.cornerRadius = 2

        durationView.layer.cornerRadius = 16
        durationLabel.text = "--:--"

        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: 200, height: headerHeight)
        tableView.separatorStyle = .none

        dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, StartEditCellType>>(
            configureCell: { _, tableView, indexPath, item in

                // swiftlint:disable force_cast
                switch item {
                case let .dummyCell(description):
                    let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! DummyLabelCell
                    cell.configure(with: description)
                    return cell
                }
        })

        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)

        Observable.just(cells)
            .map({ [SectionModel(model: "", items: $0)] })
            .bind(to: tableView.rx.items(dataSource: dataSource!))
            .disposed(by: disposeBag)

        store.select({ $0.editableTimeEntry })
            .drive(onNext: displayTimeEntry)
            .disposed(by: disposeBag)
        
        descriptionTextField.rx.text.compactMap { [weak self] text in
                (text, self?.descriptionCursorPosition()) as? (String, Int)
            }
            .map(StartEditAction.descriptionEntered)
            .subscribe(onNext: store.dispatch)
            .disposed(by: disposeBag)

        closeButton.rx.tap
            .mapTo(StartEditAction.closeButtonTapped)
            .subscribe(onNext: store.dispatch)
            .disposed(by: disposeBag)

        connectAccessoryViewButtons()
    }

    public func loseFocus() {
        descriptionTextField.resignFirstResponder()
        Tooltip.dismiss()
    }

    public func focus() {
        descriptionTextField.becomeFirstResponder()
    }

    public override var canBecomeFirstResponder: Bool { true }
    
    private func connectAccessoryViewButtons() {
        startEditInputAccessoryView.projectButton.rx.tap
            .mapTo(StartEditAction.projectButtonTapped)
            .subscribe(onNext: store.dispatch)
            .disposed(by: disposeBag)
        
        startEditInputAccessoryView.tagButton.rx.tap
            .mapTo(StartEditAction.tagButtonTapped)
            .subscribe(onNext: store.dispatch)
            .disposed(by: disposeBag)
        
        startEditInputAccessoryView.billableButton.rx.tap
            .do(onNext: showBillableTooltip)
            .mapTo(StartEditAction.billableButtonTapped)
            .subscribe(onNext: store.dispatch)
            .disposed(by: disposeBag)
    }

    private func descriptionCursorPosition() -> Int? {
        guard let selectedRange = descriptionTextField.selectedTextRange else { return nil }
        return descriptionTextField.offset(from: descriptionTextField.beginningOfDocument, to: selectedRange.start)
    }

    private func showBillableTooltip() {
        Tooltip.show(from: self.startEditInputAccessoryView.billableButton,
                     text: NSLocalizedString("Billable", comment: ""),
                     duration: self.billableTooltipDuration)
    }

    private func displayTimeEntry(timeEntry: EditableTimeEntry?) {
        guard let timeEntry = timeEntry else {
            descriptionTextField.text = nil
            return
        }

        descriptionTextField.text = timeEntry.description
        setDurationLabel(for: timeEntry)
    }

    private func setDurationLabel(for timeEntry: EditableTimeEntry) {

        timer?.invalidate()
        timer = nil

        guard let start = timeEntry.start else {
            durationLabel.text = "00:00"
            return
        }

        guard let duration = timeEntry.duration else {
            timer = Timer(timeInterval: 1, repeats: true) { [weak self] _ in
                self?.durationLabel.text = self?.time.now().timeIntervalSince(start).formattedDuration()
            }
            RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
            return
        }

        durationLabel.text = duration.formattedDuration()
    }

    deinit {
        timer?.invalidate()
    }
}

extension StartEditViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSource.sectionModels[0].items[indexPath.row].height
    }
}
