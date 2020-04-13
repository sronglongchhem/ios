import UIKit
import Utils
import Assets
import Architecture
import RxCocoa
import RxSwift
import RxDataSources
import Models

public typealias ___VARIABLE_featureName___Store = Store<___VARIABLE_featureName___State, ___VARIABLE_featureName___Action>

public class ___VARIABLE_featureName___ViewController: UIViewController, Storyboarded {

    public static var storyboardName = "___PROJECTNAME___"
    public static var storyboardBundle = Assets.bundle

    private var disposeBag = DisposeBag()

    public var store: ___VARIABLE_featureName___Store!

    public override func viewDidLoad() {
        super.viewDidLoad()

    }
}
