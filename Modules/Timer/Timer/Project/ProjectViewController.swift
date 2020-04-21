import UIKit
import Utils
import Assets
import Architecture
import RxCocoa
import RxSwift
import RxDataSources
import Models

public typealias ProjectStore = Store<ProjectState, ProjectAction>

public class ProjectViewController: UIViewController, Storyboarded {

    public static var storyboardName = "Timer"
    public static var storyboardBundle = Assets.bundle

    private var disposeBag = DisposeBag()

    public var store: ProjectStore!

    public override func viewDidLoad() {
        super.viewDidLoad()

    }
}
