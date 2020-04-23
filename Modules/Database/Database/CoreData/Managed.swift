import Foundation
import CoreData

public protocol Managed: class, NSFetchRequestResult {
    static var entityName: String { get }
    static var prefetchRelationships: [String] { get }
}

extension Managed where Self: NSManagedObject {
    public static var entityName: String { return String(describing: self) }
}

extension Managed {

    static func findOrFetch(
        in context: NSManagedObjectContext,
        matching predicate: NSPredicate
    ) throws -> Self? {
        guard let object = materializedObject(in: context, matching: predicate) else {
            return try fetch(in: context) { request in
                request.predicate = predicate
                request.returnsObjectsAsFaults = false
                request.fetchLimit = 1
            }.first
        }

        return object
    }

    static func fetch(
        in context: NSManagedObjectContext,
        configurationBlock: (NSFetchRequest<Self>) -> Void = { _ in }
    ) throws -> [Self] {
        let request = NSFetchRequest<Self>(entityName: Self.entityName)
        request.relationshipKeyPathsForPrefetching = prefetchRelationships
        configurationBlock(request)
        return try context.fetch(request)
    }

    static func materializedObject(
        in context: NSManagedObjectContext,
        matching predicate: NSPredicate
    ) -> Self? {
        for object in context.registeredObjects where !object.isFault {
            guard let result = object as? Self,
                predicate.evaluate(with: result) else { continue }

            return result
        }

        return nil
    }

    static func insert(
        into context: NSManagedObjectContext
    ) -> Self {
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as? Self
            else { fatalError("Wrong type") }

        return obj
    }
}
