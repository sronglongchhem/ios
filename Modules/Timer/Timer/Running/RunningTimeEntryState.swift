import Foundation
import Models
import Utils

public struct RunningTimeEntryState: Equatable {
    var user: Loadable<User>
    var entities: TimeLogEntities

    var runningTimeEntry: TimeEntry? {
        entities.timeEntries.values.first(where: { timeEntry -> Bool in
            timeEntry.duration == nil
        })
    }
}
