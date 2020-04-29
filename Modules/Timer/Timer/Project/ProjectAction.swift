import Foundation
import Models

public enum ProjectAction: Equatable {
    case nameEntered(String)
    case privateProjectSwitchTapped
}

extension ProjectAction: CustomDebugStringConvertible {

    public var debugDescription: String {
        switch self {
        case let .nameEntered(name):
            return "NameEntered \(name)"
        case .privateProjectSwitchTapped:
            return "PrivateProjectSwitchTapped"
        }
    }
}
