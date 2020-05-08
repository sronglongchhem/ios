import Foundation
import UIKit

@IBDesignable
public class Label: UILabel {
    
    var textStyle: TextStyle = TextStyles.bodyLarge
    var textStyleDescription: TextStyleDescription = .bodyLarge
    
    @IBInspectable var textStyleName: String {
        get {
            return self.textStyleDescription.rawValue
        }
        set(name) {
            self.textStyleDescription = TextStyleDescription(rawValue: name) ?? .bodyLarge
            self.textStyle = TextStyles.style(for: self.textStyleDescription)
            self.setUpFont()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpFont()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpFont()
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setUpFont()
    }
    
    private func setUpFont() {
        guard let labelText = self.text else { return }
        numberOfLines = 0
        let attributedLabelText = NSAttributedString(string: labelText, attributes: textStyle.stringAttributes())
        attributedText = attributedLabelText
    }
}
