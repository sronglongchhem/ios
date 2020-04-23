import Foundation
import CoreData
@testable import Database

// swiftlint:disable force_try force_cast
extension NSPersistentContainer {
    func items<EntityType: Managed>() -> [EntityType] {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: EntityType.entityName)
        return try! viewContext.fetch(request) as! [EntityType]
    }
}
