import Foundation
import Models
import CoreData

public class Database {

    private var stack: CoreDataStack

    public var timeEntries: EntityDatabase<TimeEntry>
    public var workspaces: EntityDatabase<Workspace>
    public var clients: EntityDatabase<Client>
    public var projects: EntityDatabase<Project>
    public var tasks: EntityDatabase<Task>
    public var tags: EntityDatabase<Tag>

    public init(persistentContainer: NSPersistentContainer? = nil) {
        stack = CoreDataStack(persistentContainer: persistentContainer)
        timeEntries = EntityDatabase<TimeEntry>(stack: stack)
        workspaces = EntityDatabase<Workspace>(stack: stack)
        clients = EntityDatabase<Client>(stack: stack)
        projects = EntityDatabase<Project>(stack: stack)
        tasks = EntityDatabase<Task>(stack: stack)
        tags = EntityDatabase<Tag>(stack: stack)
    }
}
