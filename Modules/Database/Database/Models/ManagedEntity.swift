import Foundation
import CoreData

protocol ManagedEntity {
    associatedtype ID
    static var entityName: String { get }
    var id: ID { get }
}

extension ManagedEntity where Self: NSManagedObject {

    static func fetchRequest() -> NSFetchRequest<Self> {
        return NSFetchRequest<Self>(entityName: entityName)
    }

    static func fetchRequest(predicate: NSPredicate) -> NSFetchRequest<Self> {
        let request: NSFetchRequest<Self> = fetchRequest()
        request.predicate = predicate
        return request
    }
}

extension ManagedEntity where Self: NSManagedObject, ID == Int64 {

    static func fetchRequest(id: Int64) -> NSFetchRequest<Self> {
        let predicate = NSPredicate(format: "id == %@", id)
        return fetchRequest(predicate: predicate)
    }
}

extension ManagedEntity where Self: NSManagedObject {

    static func insert(into context: NSManagedObjectContext) throws -> Self {
        guard let entity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as? Self else { throw SaveFailedError() }
        return entity
    }
}
