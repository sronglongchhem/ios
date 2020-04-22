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

    public static var storyboardName = "Project"
    public static var storyboardBundle = Assets.bundle

    // MARK: Layout and navigation subviews
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentScrollView: UIScrollView!

    // MARK: Add project subviews
    @IBOutlet var projectNameTextField: UITextField!
    @IBOutlet var togglePrivateProjectButton: UIButton!
    @IBOutlet var addClientButton: UIButton!
    @IBOutlet var selectWorkspaceButton: UIButton!
    @IBOutlet var selectColorButton: UIButton!

    private var disposeBag = DisposeBag()

    public var store: ProjectStore!

    public override func viewDidLoad() {
        super.viewDidLoad()

    }
}
