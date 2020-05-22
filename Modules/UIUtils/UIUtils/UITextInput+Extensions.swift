import Foundation
import UIKit

extension UITextInput {
    public var cursorPosition: Int? {
        get {
            guard let selectionStart = self.selectedTextRange?.start else {
                return nil
            }
            return self.offset(from: self.beginningOfDocument, to: selectionStart)
        }
        set {
            guard let newValue = newValue,
                let newPosition = self.position(from: self.beginningOfDocument, offset: newValue)
                else {
                return
            }
            self.selectedTextRange = self.textRange(from: newPosition, to: newPosition)
        }
    }
}
