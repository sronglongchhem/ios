import Foundation
import Models
import Utils

public struct TimeEntriesLogState: Equatable {
    var entities: TimeLogEntities
    var expandedGroups: Set<Int>
    var editableTimeEntry: EditableTimeEntry?
    var entriesPendingDeletion = Set<Int64>()
}
