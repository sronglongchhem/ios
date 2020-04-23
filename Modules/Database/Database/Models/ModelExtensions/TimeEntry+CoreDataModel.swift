import Foundation
import CoreData
import Models

extension TimeEntry: CoreDataModel {
    public static func from(managedObject: ManagedTimeEntry) throws -> TimeEntry {
        TimeEntry(
            id: managedObject.id,
            description: managedObject.textDescription,
            start: managedObject.start,
            duration: managedObject.duration?.doubleValue,
            billable: managedObject.billable,
            workspaceId: managedObject.workspace.id
        )
    }

    public func encode(into managedObject: ManagedTimeEntry, context: NSManagedObjectContext) throws {
        managedObject.id = self.id
        managedObject.textDescription = self.description
        managedObject.start = self.start
        managedObject.duration = self.duration != nil ? NSNumber(value: self.duration!) : nil
        managedObject.billable = self.billable
        managedObject.workspace = try ManagedWorkspace.findOrFetch(in: context, withId: workspaceId)!
    }
}
