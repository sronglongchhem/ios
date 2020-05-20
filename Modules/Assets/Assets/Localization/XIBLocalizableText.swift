import UIKit

protocol XIBLocalizableText {
    var localizedTextKey: String? { get set }
}

extension UILabel: XIBLocalizableText {
    @IBInspectable var localizedTextKey: String? {
        get { return nil }
        set(key) {
            text = key?.localized
        }
    }
}

extension UIButton: XIBLocalizableText {
    @IBInspectable var localizedTextKey: String? {
        get { return nil }
        set(key) {
            setTitle(key?.localized, for: .normal)
        }
    }
}

extension UITextField: XIBLocalizableText {
    @IBInspectable var localizedTextKey: String? {
        get { return nil }
        set(key) {
            text = key?.localized
        }
    }
}
