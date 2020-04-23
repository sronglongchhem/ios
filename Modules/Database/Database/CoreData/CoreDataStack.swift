import Foundation
import CoreData
import Assets

public class CoreDataStack {
    private let identifier = "com.toggl.aurora.Database"
    private let model = "Database"

    private let injectedContainer: NSPersistentContainer?

    lazy var persistentContainer: NSPersistentContainer = {
        guard injectedContainer == nil else { return injectedContainer! }
        let bundle = Assets.bundle
        guard let modelURL = bundle.url(forResource: self.model, withExtension: "momd") else { fatalError() }
        guard let managedObjectModel =  NSManagedObjectModel(contentsOf: modelURL) else { fatalError() }

        let container = NSPersistentContainer(name: self.model, managedObjectModel: managedObjectModel)
        container.loadPersistentStores { _, error in

            if let err = error {
                fatalError("Loading of database failed:\(err)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

    lazy var viewContext: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()

    lazy var backgroundContext: NSManagedObjectContext = {
        persistentContainer.newBackgroundContext()
    }()

    func saveContext() throws {
        if persistentContainer.viewContext.hasChanges {
            try persistentContainer.viewContext.save()
        }
    }

    init(persistentContainer: NSPersistentContainer? = nil) {
        self.injectedContainer = persistentContainer
    }
}
