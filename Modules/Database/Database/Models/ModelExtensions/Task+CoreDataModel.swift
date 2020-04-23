import Foundation
import CoreData
import Models

extension Task: CoreDataModel {
    public static func from(managedObject: ManagedTask) throws -> Task {
        Task(
            id: managedObject.id,
            name: managedObject.name,
            active: managedObject.active,
            estimatedSeconds: managedObject.estimatedSeconds,
            trackedSeconds: managedObject.trackedSeconds,
            projectId: managedObject.project.id,
            workspaceId: managedObject.workspace.id,
            userId: nil
        )
    }

    public func encode(into managedObject: ManagedTask, context: NSManagedObjectContext) throws {
        managedObject.id = self.id
        managedObject.name = self.name
        managedObject.active = self.active
        managedObject.estimatedSeconds = self.estimatedSeconds
        managedObject.trackedSeconds = self.trackedSeconds
        managedObject.project = try ManagedProject.findOrFetch(in: context, withId: self.projectId)!
        managedObject.workspace = try ManagedWorkspace.findOrFetch(in: context, withId: self.workspaceId)!
    }
}
