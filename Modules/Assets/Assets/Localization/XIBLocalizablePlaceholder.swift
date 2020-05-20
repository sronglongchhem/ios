import UIKit

protocol XIBLocalizablePlaceholder {
    var localizedPlaceholderKey: String? { get set }
}

extension UITextField: XIBLocalizablePlaceholder {
    @IBInspectable var localizedPlaceholderKey: String? {
        get { return nil }
        set(key) {
            placeholder = key?.localized
        }
    }
}
