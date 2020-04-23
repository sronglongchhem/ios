import Foundation
import CoreData
import Models

extension Workspace: CoreDataModel {
    public static func from(managedObject: ManagedWorkspace) throws -> Workspace {
        Workspace(
            id: managedObject.id,
            name: managedObject.name,
            admin: managedObject.admin
        )
    }

    public func encode(into managedObject: ManagedWorkspace, context: NSManagedObjectContext) throws {
        managedObject.id = self.id
        managedObject.name = self.name
        managedObject.admin = self.admin
    }
}
