import UIKit
import Assets
import Utils
import Architecture
import RxSwift
import RxCocoa
import Models
import Foundation

public typealias RunningTimeEntryStore = Store<RunningTimeEntryState, RunningTimeEntryAction>

public class RunningTimeEntryViewController: UIViewController, Storyboarded {
    public static var storyboardName = "Timer"
    public static var storyboardBundle = Assets.bundle

    @IBOutlet var stopButton: UIButton!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var runningTimeEntryView: UIView!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var startTimeEntryView: UIView!

    public var store: RunningTimeEntryStore!
    private var disposeBag = DisposeBag()
    private var timer: Timer?

    public override func viewDidLoad() {
        super.viewDidLoad()

        store.select(runningTimeEntryViewModelSelector)
            .map { $0?.description }
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)

        store.select(runningTimeEntryViewModelSelector)
            .drive(onNext: updateUI)
            .disposed(by: disposeBag)

        stopButton.rx.tap
            .mapTo(RunningTimeEntryAction.stopButtonTapped)
            .subscribe(onNext: store.dispatch)
            .disposed(by: disposeBag)
            
        startButton.rx.tap
            .mapTo(RunningTimeEntryAction.startButtonTapped)
            .subscribe(onNext: store.dispatch)
            .disposed(by: disposeBag)

        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)

        tapGesture.rx.event
            .mapTo(RunningTimeEntryAction.cardTapped)
            .subscribe(onNext: store.dispatch)
            .disposed(by: disposeBag)
    }

    private func updateUI(runningTimeEntry: TimeEntryViewModel?) {
        guard let runningTimeEntry = runningTimeEntry, runningTimeEntry.isRunning else {
            timer?.invalidate()
            timer = nil
            runningTimeEntryView.isHidden = true
            startTimeEntryView.isHidden = false
            return
        }

        timer = Timer(timeInterval: 1, repeats: true) { [weak self] _ in
            self?.timerLabel.text = Date().timeIntervalSince(runningTimeEntry.start).formattedDuration(ending: Date())
        }
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)

        descriptionLabel.text = runningTimeEntry.description
        runningTimeEntryView.isHidden = false
        startTimeEntryView.isHidden = true
    }
}
