import Foundation
import CoreData

@objc(ManagedWorkspace)
public final class ManagedWorkspace: NSManagedObject, ManagedEntity {
    @NSManaged var id: Int64
    @NSManaged var name: String
    @NSManaged var admin: Bool

    public static var prefetchRelationships = [String]()
}
