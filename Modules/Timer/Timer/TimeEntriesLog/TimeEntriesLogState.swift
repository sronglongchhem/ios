import Foundation
import Models
import Utils

public struct TimeEntriesLogState: Equatable {
    var entities: TimeLogEntities

    internal var expandedGroups: Set<Int> = Set<Int>()
    internal var entriesPendingDeletion = Set<Int64>()

//    var editableTimeEntry: EditableTimeEntry?

    public init(entities: TimeLogEntities) {
        self.entities = entities
    }
}
