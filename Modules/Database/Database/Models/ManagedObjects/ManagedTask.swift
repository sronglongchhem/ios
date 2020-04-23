import Foundation
import CoreData

@objc(ManagedTask)
public final class ManagedTask: NSManagedObject, ManagedEntity {
    @NSManaged var id: Int64
    @NSManaged var name: String
    @NSManaged var active: Bool
    @NSManaged var estimatedSeconds: Int
    @NSManaged var trackedSeconds: Int

    @NSManaged var project: ManagedProject
    @NSManaged var workspace: ManagedWorkspace

    public static var prefetchRelationships = ["project", "workspace"]
}
