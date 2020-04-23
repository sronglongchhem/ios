import Foundation
import CoreData
import Models

extension Project: CoreDataModel {
    public static func from(managedObject: ManagedProject) throws -> Project {
        Project(
            id: managedObject.id,
            name: managedObject.name,
            isPrivate: managedObject.isPrivate,
            isActive: managedObject.isActive,
            color: managedObject.color,
            billable: managedObject.isBillable,
            workspaceId: managedObject.workspace.id,
            clientId: managedObject.client?.id
        )
    }

    public func encode(into managedObject: ManagedProject, context: NSManagedObjectContext) throws {
        managedObject.id = self.id
        managedObject.name = self.name
        managedObject.isPrivate = self.isPrivate
        managedObject.isActive = self.isActive
        managedObject.color = self.color
        managedObject.isBillable = self.billable ?? false
        managedObject.workspace = try ManagedWorkspace.findOrFetch(in: context, withId: self.workspaceId)!
        managedObject.client = clientId == nil
            ? nil
            : try ManagedClient.findOrFetch(in: context, withId: clientId!)
    }
}
