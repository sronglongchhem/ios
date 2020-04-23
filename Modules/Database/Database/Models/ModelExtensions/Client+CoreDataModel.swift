import Foundation
import CoreData
import Models

extension Client: CoreDataModel {
    public static func from(managedObject: ManagedClient) throws -> Client {
        Client(
            id: managedObject.id,
            name: managedObject.name,
            workspaceId: managedObject.workspace.id
        )
    }

    public func encode(into managedObject: ManagedClient, context: NSManagedObjectContext) throws {
        managedObject.id = self.id
        managedObject.name = self.name
        managedObject.workspace = try ManagedWorkspace.findOrFetch(in: context, withId: self.workspaceId)!
    }
}
