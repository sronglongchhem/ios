import Foundation
import Models

public enum RunningTimeEntryAction: Equatable {
    case cardTapped
    case stopButtonTapped
    case startButtonTapped
    case timeEntryStarted(started: TimeEntry, stopped: TimeEntry?)
    case setError(ErrorType)
}

extension RunningTimeEntryAction: CustomDebugStringConvertible {

    public var debugDescription: String {
        switch self {
        case .cardTapped:
            return "CardTapped"
            
        case .stopButtonTapped:
            return "StopButtonTapped"

        case .startButtonTapped:
            return "StartButtonTapped"

        case .timeEntryStarted(started: let startedTE, stopped: let stoppedTE):
            if let stoppedTE = stoppedTE {
                return "TimeEntryStarted \(startedTE) \(stoppedTE)"
            }
            return "TimeEntryStarted \(startedTE)"

        case let .setError(error):
            return "SetError: \(error)"
        }
    }
}
