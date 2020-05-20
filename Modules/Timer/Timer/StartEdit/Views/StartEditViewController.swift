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
    private let datePickerHeight: CGFloat = 197
    private let editDurationWithoutDatePickerHeight: CGFloat = 442
    private let editDurationWithDatePickerHeight: CGFloat = 637

    var scrollView: UIScrollView?
    var smallStateHeight: CGFloat { headerHeight + cells[0].height }

    @IBOutlet weak var handle: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var durationView: UIView!
    @IBOutlet weak var startDateButton: UIButton!
    @IBOutlet weak var endDateButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var wheelForegroundView: WheelForegroundView!
    @IBOutlet weak var wheelDurationView: UIView!
    @IBOutlet weak var wheelDurationLabelTextField: DurationTextField!
    @IBOutlet weak var editDurationView: UIView!

    @IBOutlet var startEditInputAccessoryView: StartEditInputAccessoryView!

    public override var inputAccessoryView: UIView? { startEditInputAccessoryView }

    public var store: StartEditStore!
    public var time: Time!

    private var disposeBag = DisposeBag()
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, StartEditCellType>>!
    private var cells = [
        StartEditCellType.dummyCell("PROJECT"),
        StartEditCellType.dummyCell("TAGS"),
        StartEditCellType.dummyCell("START"),
        StartEditCellType.dummyCell("END"),
        StartEditCellType.dummyCell("DURATION"),
        StartEditCellType.dummyCell("BILLABLE")
    ]
    private var headerHeight: CGFloat = 107
    private var timer: Timer?

    // swiftlint:disable function_body_length
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView = tableView
        handle.layer.cornerRadius = 2

        durationView.layer.cornerRadius = 16
        durationLabel.text = "--:--"

        wheelDurationView.layer.cornerRadius = 16

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

        tableView.rx.itemSelected
            .filter({ $0.item == 0 })
            .mapTo(StartEditAction.addProjectChipTapped)
            .subscribe(onNext: store.dispatch)
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .filter({ $0.item == 1 })
            .mapTo(StartEditAction.addTagChipTapped)
            .subscribe(onNext: store.dispatch)
            .disposed(by: disposeBag)

        startDateButton.rx.tap
            .mapTo(StartEditAction.pickerTapped(.start))
            .subscribe(onNext: store.dispatch)
            .disposed(by: disposeBag)

        endDateButton.rx.tap
            .mapTo(StartEditAction.pickerTapped(.end))
            .subscribe(onNext: store.dispatch)
            .disposed(by: disposeBag)

        store.select({ $0.dateTimePickMode })
            .drive(onNext: setDatePickerHeight(mode:))
            .disposed(by: disposeBag)

        datePicker.rx.date
            .mapTo({ StartEditAction.dateTimePicked($0) })
            .subscribe(onNext: store.dispatch)
            .disposed(by: disposeBag)

        connectAccessoryViewButtons()
    }
    // swiftlint:enable function_body_length

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

        startEditInputAccessoryView.acceptButton.rx.tap
            .subscribe(onNext: { UIImpactFeedbackGenerator(style: .light).impactOccurred() })
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
        setDuration(for: timeEntry)
    }

    private func setDuration(for timeEntry: EditableTimeEntry) {

        timer?.invalidate()
        timer = nil

        guard let start = timeEntry.start else {
            durationLabel.text = "00:00"
            wheelDurationLabelTextField.setFormattedDuration("00:00")
            return
        }

        guard let duration = timeEntry.duration else {
            timer = Timer(timeInterval: 1, repeats: true) { [weak self] _ in
                let formattedDuration = self?.time.now().timeIntervalSince(start).formattedDuration()
                self?.durationLabel.text = formattedDuration
                self?.wheelDurationLabelTextField.setFormattedDuration(formattedDuration ?? "00:00")
            }
            RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
            return
        }

        let formattedDuration = duration.formattedDuration()
        durationLabel.text = formattedDuration
        wheelDurationLabelTextField.setFormattedDuration(formattedDuration)
    }

    private func setDatePickerHeight(mode: DateTimePickMode) {
        let animator = UIViewPropertyAnimator(duration: 0.225, curve: .easeInOut) {
            self.datePickerContainerHeight.constant = mode == .none ? 0 : self.datePickerHeight
            self.editDurationView.frame.size.height = mode == .none ? self.editDurationWithoutDatePickerHeight : self.editDurationWithDatePickerHeight
        }
        animator.startAnimation()
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
