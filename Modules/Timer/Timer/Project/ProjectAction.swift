import Foundation
import Models

public enum ProjectAction: Equatable {
    case nameEntered(String)
}

extension ProjectAction: CustomDebugStringConvertible {

    public var debugDescription: String {
        switch self {
        case let .nameEntered(name):
            return "NameEntered \(name)"
        }
    }
}
