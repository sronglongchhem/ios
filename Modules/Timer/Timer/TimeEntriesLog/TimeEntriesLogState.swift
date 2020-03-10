import Foundation
import Models
import Utils

struct TimeEntriesLogState
{
    var entities: TimeLogEntities
    var entriesToDelete: Set<Int> = Set<Int>()

    init(entities: TimeLogEntities, entriesToDelete: Set<Int>) {
        self.entities = entities
        self.entriesToDelete = entriesToDelete
    }
}

