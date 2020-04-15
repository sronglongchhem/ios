import UIKit
import Utils
import UIUtils
import Assets
import Architecture
import RxCocoa
import RxSwift
import RxDataSources
import Models

public typealias TimeEntriesLogStore = Store<TimeEntriesLogState, TimeEntriesLogAction>

// swiftlint:disable function_body_length
public class TimeEntriesLogViewController: UIViewController, Storyboarded {
    
    public static var storyboardName = "Timer"
    public static var storyboardBundle = Assets.bundle

    @IBOutlet weak var tableView: UITableView!
    
    private var disposeBag = DisposeBag()
    private var dataSource: RxTableViewSectionedAnimatedDataSource<DayViewModel>!
    private var snackbar: Snackbar?

    public var store: TimeEntriesLogStore!

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Time Log"
        tableView.rowHeight = 72
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                
        if dataSource == nil {
            // We should do this in ViewDidLoad, but there's a bug that causes an ugly warning. That's why we are doing it here for now
            dataSource = RxTableViewSectionedAnimatedDataSource<DayViewModel>(
                configureCell: { [weak self] _, tableView, indexPath, item in
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "TimeEntryCell", for: indexPath) as? TimeEntryCell else {
                        fatalError("Wrong cell type")                        
                    }
                    cell.descriptionLabel.text = item.description
                    cell.descriptionLabel.textColor = item.descriptionColor
                    cell.projectClientTaskLabel.textColor = item.projectColor
                    cell.projectClientTaskLabel.attributedText = item.projectTaskClient
                    cell.durationLabel.text = item.durationString
                    cell.continueButton.rx.tap
                        .mapTo(TimeEntriesLogAction.continueButtonTapped(item.mainEntryId))
                        .subscribe(onNext: self?.store.dispatch)
                        .disposed(by: cell.disposeBag)
                    cell.hasTagsImageView.isHidden = item.tags?.isEmpty ?? true
                    cell.isBillableImage.isHidden = item.billable
                    return cell
            })
            
            dataSource.canEditRowAtIndexPath = { _, _ in true }
            
            dataSource.titleForHeaderInSection = { dataSource, index in
              return dataSource.sectionModels[index].dayString
            }
            
            Driver.combineLatest(
                store.select(timeEntryViewModelsSelector),
                store.select(expandedGroupsSelector),
                store.select(entriesPendingDeletionSelector),
                resultSelector: toDaysMapper
            )
                .drive(tableView.rx.items(dataSource: dataSource!))
                .disposed(by: disposeBag)
            
            tableView.rx.modelSelected(TimeEntryViewModel.self)
                .map({ timeEntry in TimeEntriesLogAction.timeEntryTapped(timeEntry.id) })
                .subscribe(onNext: store.dispatch)
                .disposed(by: disposeBag)
            
            tableView.rx.setDelegate(self)
                .disposed(by: disposeBag)

            store.select(entriesPendingDeletionSelector)
                .map { [weak self] setOfIds -> Snackbar? in
                    self?.snackbar?.dismiss()
                    if setOfIds.count > 0 {
                        self?.snackbar = self?.createSnackbar(for: setOfIds)
                    }
                    return self?.snackbar
                }
                .drive(onNext: { $0?.show(in: self) })
                .disposed(by: disposeBag)
        }
    }

    private func createSnackbar(for setOfIds: Set<Int64>) -> Snackbar {
        return Snackbar.with(
            text: setOfIds.count > 1
                ? String(format: NSLocalizedString("%d time entries deleted", comment: ""), setOfIds.count)
                : NSLocalizedString("Time entry was deleted", comment: ""),
            buttonTitle: NSLocalizedString("UNDO", comment: ""),
            store: store,
            action: .undoButtonTapped)
    }
}

extension TimeEntriesLogViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Continue") { _, _, _ in
            let timeLogCellViewModel = self.dataSource.sectionModels[indexPath.section].items[indexPath.item]
            self.store.dispatch(TimeEntriesLogAction.timeEntrySwiped(.right, timeLogCellViewModel.mainEntryId))
        }
        action.backgroundColor = .green
        return UISwipeActionsConfiguration(actions: [action])
    }

    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            let timeLogCellViewModel = self.dataSource.sectionModels[indexPath.section].items[indexPath.item]
            self.store.dispatch(TimeEntriesLogAction.timeEntrySwiped(.left, timeLogCellViewModel.mainEntryId))
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}

// ANIMATED DATASOURCE EXTENSIONS

extension TimeLogCellViewModel: IdentifiableType {
    public var identity: String { id }
}

extension DayViewModel: AnimatableSectionModelType {
    
    public init(original: DayViewModel, items: [TimeLogCellViewModel]) {
        self = original
        self.timeLogCells = items
    }
    
    public var identity: Date { day }
    public var items: [TimeLogCellViewModel] { timeLogCells }
}
