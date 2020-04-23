import Foundation
import CoreData

@objc(ManagedClient)
public final class ManagedClient: NSManagedObject, ManagedEntity {
    @NSManaged var id: Int64
    @NSManaged var name: String

    @NSManaged var workspace: ManagedWorkspace

    public static var prefetchRelationships = ["workspace"]
}
