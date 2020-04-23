import Foundation
import CoreData

@objc(ManagedTag)
public final class ManagedTag: NSManagedObject, ManagedEntity {
    @NSManaged var id: Int64
    @NSManaged var name: String

    @NSManaged var workspace: ManagedWorkspace

    public static var prefetchRelationships = ["workspace"]
}
