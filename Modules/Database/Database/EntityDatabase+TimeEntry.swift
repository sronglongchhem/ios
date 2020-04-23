import Foundation
import Models

extension EntityDatabase where EntityType == TimeEntry {
    public func getAllSorted() throws -> [TimeEntry] {
        try TimeEntry.get(
            in: stack.viewContext,
            sortDescriptors: [NSSortDescriptor(key: "start", ascending: false)]
        )
    }

    public func getAllRunning() throws -> [TimeEntry] {
        try TimeEntry.get(
            in: stack.viewContext,
            predicate: NSPredicate(format: "duration == nil"),
            sortDescriptors: [NSSortDescriptor(key: "start", ascending: false)]
        )
    }
}
