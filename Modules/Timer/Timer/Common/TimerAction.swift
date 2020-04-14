import Foundation
import Models

public enum TimerAction: Equatable {
    case timeLog(TimeEntriesLogAction)
    case startEdit(StartEditAction)
    case runningTimeEntry(RunningTimeEntryAction)
}

extension TimerAction {
    var timeLog: TimeEntriesLogAction? {
        get {
            guard case let .timeLog(value) = self else { return nil }
            return value
        }
        set {
            guard case .timeLog = self, let newValue = newValue else { return }
            self = .timeLog(newValue)
        }
    }
    
    var startEdit: StartEditAction? {
        get {
            guard case let .startEdit(value) = self else { return nil }
            return value
        }
        set {
            guard case .startEdit = self, let newValue = newValue else { return }
            self = .startEdit(newValue)
        }
    }

    var runningTimeEntry: RunningTimeEntryAction? {
        get {
            guard case let .runningTimeEntry(value) = self else { return nil }
            return value
        }
        set {
            guard case .runningTimeEntry = self, let newValue = newValue else { return }
            self = .runningTimeEntry(newValue)
        }
    }
}

extension TimerAction: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        
        switch self {
        case let .timeLog(action):
            return action.debugDescription
            
        case let .startEdit(action):
            return action.debugDescription

        case let .runningTimeEntry(action):
            return action.debugDescription
        }
    }
}
