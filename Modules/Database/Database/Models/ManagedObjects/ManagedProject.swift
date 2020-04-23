import Foundation
import CoreData

@objc(ManagedProject)
public final class ManagedProject: NSManagedObject, ManagedEntity {
    @NSManaged var id: Int64
    @NSManaged var name: String
    @NSManaged var color: String
    @NSManaged var isBillable: Bool
    @NSManaged var isPrivate: Bool
    @NSManaged var isActive: Bool

    @NSManaged var client: ManagedClient?
    @NSManaged var workspace: ManagedWorkspace

    public static var prefetchRelationships = ["client", "workspace"]
}
