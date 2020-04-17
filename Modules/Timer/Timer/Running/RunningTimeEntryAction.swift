import Foundation
import Models

public enum RunningTimeEntryAction: Equatable {
    case cardTapped
}

extension RunningTimeEntryAction: CustomDebugStringConvertible {

    public var debugDescription: String {
        switch self {

        case .cardTapped:
            return "CardTapped"

        }
    }
}
