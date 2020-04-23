import Foundation
import CoreData
import Models

extension Tag: CoreDataModel {
    public static func from(managedObject: ManagedTag) throws -> Tag {
        Tag(
            id: managedObject.id,
            name: managedObject.name,
            workspaceId: managedObject.workspace.id
        )
    }

    public func encode(into managedObject: ManagedTag, context: NSManagedObjectContext) throws {
        managedObject.id = self.id
        managedObject.name = self.name
        managedObject.workspace = try ManagedWorkspace.findOrFetch(in: context, withId: self.workspaceId)!
    }
}
