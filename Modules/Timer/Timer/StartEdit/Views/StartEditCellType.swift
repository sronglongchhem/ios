import Foundation
import UIKit

enum StartEditCellType {
    case dummyCell(String)

    var cellIdentifier: String {
        switch self {
        case .dummyCell:
            return DummyLabelCell.identifier
        }
    }

    var height: CGFloat {
        switch self {
        case .dummyCell:
            return 50
        }
    }
}
