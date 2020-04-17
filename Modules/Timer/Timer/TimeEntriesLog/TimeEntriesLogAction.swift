import Foundation
import Models

public enum SwipeDirection {
    case left
    case right
}

public enum TimeEntriesLogAction: Equatable {
    case continueButtonTapped(Int64)
    case timeEntrySwiped(SwipeDirection, Int64)
    case timeEntryTapped(Int64)

    case timeEntryGroupTapped([Int64])
    case timeEntryGroupSwiped(SwipeDirection, [Int64])
    case toggleTimeEntryGroupTapped(Int)

    case timeEntryStarted(TimeEntry, TimeEntry?)
    case timeEntryDeleted(Int64)

    case commitDeletion(Set<Int64>)
    case undoButtonTapped

    case setError(ErrorType)
}

extension TimeEntriesLogAction: CustomDebugStringConvertible {

    public var debugDescription: String {
        switch self {

        case let .continueButtonTapped(timeEntryId):
            return "ContinueButtonTapped: \(timeEntryId)"

        case let .timeEntrySwiped(direction, timeEntryId):
            return "TimeEntrySwiped \(direction): \(timeEntryId)"

        case let .timeEntryTapped(timeEntryId):
            return "TimeEntryTapped: \(timeEntryId)"

        case let .toggleTimeEntryGroupTapped(groupId):
            return "ToggleTimeEntryGroupTapped: \(groupId)"

        case let .timeEntryGroupSwiped(direction, timeEntryIds):
            return "TimeEntryGroupSwiped \(direction): \(timeEntryIds)"

        case let .timeEntryGroupTapped(timeEntryIds):
            return "TimeEntryGroupTapped: \(timeEntryIds)"

        case let .timeEntryDeleted(timeEntryId):
            return "TimeEntryDeleted: \(timeEntryId)"

        case let .timeEntryStarted(startedTimeEntry, stoppedTimeEntry):
            return "TimeEntryStarted: \(startedTimeEntry.description), stopped: \(String(describing: stoppedTimeEntry?.description))"

        case let .setError(error):
            return "SetError: \(error)"

        case let .commitDeletion(timeEntryIds):
            return "CommitDeletion: \(timeEntryIds)"
            
        case .undoButtonTapped:
            return "UndoButtonTapped"
        }
    }
}
