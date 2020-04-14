import UIKit
import Architecture
import Models
import RxCocoa
import RxSwift
import Utils
import Assets

public typealias TimerStore = Store<TimerState, TimerAction>

public class TimerViewController: UIViewController {
    public var runningTimeEntryViewController: RunningTimeEntryViewController!
    public var startEditViewController: StartEditViewController!
    public var timeLogViewController: UIViewController!

    private var startEditBottomSheet: StartEditBottomSheet<StartEditViewController>!
    private var runningTimeEntryBottomSheet: SimpleBottomSheet!

    private var disposeBag = DisposeBag()

    public override func viewDidLoad() {
        super.viewDidLoad()

        install(timeLogViewController)

        runningTimeEntryBottomSheet = SimpleBottomSheet(viewController: runningTimeEntryViewController)
        install(runningTimeEntryBottomSheet, customConstraints: true)

        startEditBottomSheet = StartEditBottomSheet(viewController: startEditViewController)
        install(startEditBottomSheet, customConstraints: true)
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        timeLogViewController.additionalSafeAreaInsets.bottom = runningTimeEntryBottomSheet.view.frame.height
    }
}
