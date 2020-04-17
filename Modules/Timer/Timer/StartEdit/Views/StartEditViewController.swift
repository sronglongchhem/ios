import UIKit
import Assets
import Utils
import Architecture
import RxSwift
import RxCocoa
import RxDataSources

public typealias StartEditStore = Store<StartEditState, StartEditAction>

public class StartEditViewController: UIViewController, Storyboarded, BottomSheetContent {

    public static var storyboardName = "Timer"
    public static var storyboardBundle = Assets.bundle

    var scrollView: UIScrollView?
    var smallStateHeight: CGFloat { headerHeight + cells[0].height }

    @IBOutlet weak var handle: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var descriptionTextField: UITextField!

    @IBOutlet var startEditInputAccessoryView: StartEditInputAccessoryView!

    public override var inputAccessoryView: UIView? { startEditInputAccessoryView }

    public var store: StartEditStore!

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

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView = tableView
        handle.layer.cornerRadius = 2

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

        closeButton.rx.tap
            .mapTo(StartEditAction.closeButtonTapped)
            .subscribe(onNext: store.dispatch)
            .disposed(by: disposeBag)
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    public func loseFocus() {
        descriptionTextField.resignFirstResponder()
    }

    public func focus() {
        descriptionTextField.becomeFirstResponder()
    }

    public override var canBecomeFirstResponder: Bool { true }

    private func displayTimeEntry(timeEntry: EditableTimeEntry?) {
        guard let timeEntry = timeEntry else {
            descriptionTextField.text = nil
            return
        }

        descriptionTextField.text = timeEntry.description
    }
}

extension StartEditViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSource.sectionModels[0].items[indexPath.row].height
    }
}
