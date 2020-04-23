import Foundation
import CoreData

protocol ManagedEntity: Managed {
    var id: Int64 { get }
}

extension ManagedEntity {
    static func findOrFetch(
        in context: NSManagedObjectContext,
        withId id: Int64
    ) throws -> Self? {
        return try findOrFetch(
            in: context,
            matching: NSPredicate(format: "id == %i", id)
        )
    }
}
