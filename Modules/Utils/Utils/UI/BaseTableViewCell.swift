import UIKit

open class BaseTableViewCell<Model>: UITableViewCell {
    public static var identifier: String {
        return String(describing: self)
    }

    open func configure(with model: Model) {
        fatalError("Subclass BaseTableViewCell to configure the cell")
    }
}
