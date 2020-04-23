import Foundation
import CoreData
import Models

@objc(ManagedTimeEntry)
public final class ManagedTimeEntry: NSManagedObject, ManagedEntity {
    @NSManaged var id: Int64
    @NSManaged var textDescription: String
    @NSManaged var start: Date
    @NSManaged var duration: NSNumber?
    @NSManaged var billable: Bool

    @NSManaged var workspace: ManagedWorkspace
    @NSManaged var project: ManagedProject?
    @NSManaged var task: ManagedTask?
    @NSManaged var tags: Set<ManagedTag>

    public static var prefetchRelationships = ["workspace", "project", "task", "tags"]
}
