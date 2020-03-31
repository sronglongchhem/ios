import Foundation
import CoreData

public struct SaveFailedError: Error {
    public init() { }
}

public struct FetchFailedError: Error {
    public init() { }
}

public class Database {
    private let identifier = "com.toggl.aurora.Database"
    private let model = "Database"
    
    lazy public var timeEntries: TimeEntriesDatabase = TimeEntries(database: self)
    lazy public var tags: TagsDatabase = Tags(database: self)
    
    public init() { }

    lazy public var persistentContainer: NSPersistentContainer = {
        guard let bundle = Bundle(identifier: self.identifier) else { fatalError() }
        guard let modelURL = bundle.url(forResource: self.model, withExtension: "momd") else { fatalError() }
        guard let managedObjectModel =  NSManagedObjectModel(contentsOf: modelURL) else { fatalError() }

        let container = NSPersistentContainer(name: self.model, managedObjectModel: managedObjectModel)
        container.loadPersistentStores { _, error in

            if let err = error {
                fatalError("Loading of database failed:\(err)")
            }
        }
        return container
    }()
}
