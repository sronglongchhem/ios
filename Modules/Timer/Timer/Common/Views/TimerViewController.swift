import UIKit
import Architecture
import Models
import RxCocoa
import RxSwift
import Utils
import Assets

public class TimerViewController: UIViewController {
    public var startEditViewController: StartEditViewController!
    public var timeLogViewController: UIViewController!

    private var bottomSheet: StartEditBottomSheet<StartEditViewController>!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        install(timeLogViewController)
        
        bottomSheet = StartEditBottomSheet(viewController: startEditViewController)
        install(bottomSheet, customConstraints: true)
    }
}
