import Foundation
import CoreData

public protocol TimeEntryDAOProtocol {
    var id: Int64 { get set }
    var textDescription: String { get set }
    var start: Date { get set }
    var duration: NSNumber? { get set }
    var billable: Bool { get set }
    var workspaceId: Int64 { get set }
}

@objc(ManagedTimeEntry)
final class ManagedTimeEntry: NSManagedObject, TimeEntryDAOProtocol {
    @NSManaged var id: Int64
    @NSManaged var textDescription: String
    @NSManaged var start: Date
    @NSManaged var duration: NSNumber?
    @NSManaged var billable: Bool
    @NSManaged var workspaceId: Int64
}

extension ManagedTimeEntry {
    func fromDAO(timeEntryDAO: TimeEntryDAOProtocol) {
        self.id = timeEntryDAO.id
        self.textDescription = timeEntryDAO.textDescription
        self.start = timeEntryDAO.start
        self.duration = timeEntryDAO.duration
        self.billable = timeEntryDAO.billable
        self.workspaceId = timeEntryDAO.workspaceId
    }
}

public protocol TimeEntriesDatabase {
    func getAll() throws -> [TimeEntryDAOProtocol]
    func getAllRunning() throws -> [TimeEntryDAOProtocol]
    func getOne(id: Int64) throws -> TimeEntryDAOProtocol
    func insertAll(timeEntries: [TimeEntryDAOProtocol]) throws -> [Int]
    func insert(timeEntry: TimeEntryDAOProtocol) throws -> Int
    func update(timeEntry: TimeEntryDAOProtocol) throws
    func updateAll(timeEntries: [TimeEntryDAOProtocol]) throws
    func delete(timeEntry: TimeEntryDAOProtocol) throws
    func delete(id: Int64) throws
}

struct TimeEntries: TimeEntriesDatabase {

    private let database: Database

    public init(database: Database) {
        self.database = database
    }

    // Query("SELECT * FROM TimeEntry WHERE NOT isDeleted")
    public func getAll() throws -> [TimeEntryDAOProtocol] {
        let request = NSFetchRequest<ManagedTimeEntry>(entityName: String(describing: ManagedTimeEntry.self))
        return try executeFetchRequest(request)
    }

    // Query("SELECT * FROM TimeEntry WHERE NOT isDeleted AND duration is null")
    public func getAllRunning() throws -> [TimeEntryDAOProtocol] {
        let request = NSFetchRequest<ManagedTimeEntry>(entityName: String(describing: ManagedTimeEntry.self))
        request.predicate = NSPredicate(format: "duration == nil")
        return try executeFetchRequest(request)
    }

    // Query("SELECT * FROM TimeEntry WHERE NOT isDeleted AND id = :id")
    public func getOne(id: Int64) throws -> TimeEntryDAOProtocol {
        let request = generateFetchByIdRequest(id)
        return try executeFetchRequest(request).first!
    }

    // Insert
    public func insertAll(timeEntries: [TimeEntryDAOProtocol]) throws -> [Int] {
        let context = database.persistentContainer.viewContext
        let managedTimeEntries = try timeEntries.compactMap { timeEntry -> ManagedTimeEntry in
            guard let managedTimeEntry = NSEntityDescription.insertNewObject(
                forEntityName: String(describing: ManagedTimeEntry.self),
                into: context)
                as? ManagedTimeEntry else { throw SaveFailedError() }
            managedTimeEntry.fromDAO(timeEntryDAO: timeEntry)
            return managedTimeEntry
        }
        try context.save()
        return managedTimeEntries.map { Int($0.id) }
    }

    // Insert
    public func insert(timeEntry: TimeEntryDAOProtocol) throws -> Int {
        let context = database.persistentContainer.viewContext
        guard let managedTimeEntry = NSEntityDescription.insertNewObject(
            forEntityName: String(describing: ManagedTimeEntry.self),
            into: context)
            as? ManagedTimeEntry else { throw SaveFailedError() }
        managedTimeEntry.fromDAO(timeEntryDAO: timeEntry)
        let lastId = try getAll().last?.id ?? -1
        managedTimeEntry.id = Int64(lastId + 1)
        try context.save()
        return Int(managedTimeEntry.id)
    }

    // Update
    public func update(timeEntry: TimeEntryDAOProtocol) throws {
        let context = database.persistentContainer.viewContext
        let request = generateFetchByIdRequest(Int64(timeEntry.id))
        guard let managedTimeEntry = try context.fetch(request).first else { throw FetchFailedError() }
        managedTimeEntry.fromDAO(timeEntryDAO: timeEntry)
        try context.save()
    }

    // Update
    public func updateAll(timeEntries: [TimeEntryDAOProtocol]) throws {
        try timeEntries.forEach { try update(timeEntry: $0) }
    }

    // Delete
    public func delete(timeEntry: TimeEntryDAOProtocol) throws {
        try delete(id: timeEntry.id)
    }

    // Delete by id
    public func delete(id: Int64) throws {
        let context = database.persistentContainer.viewContext
        let request = generateFetchByIdRequest(id)
        guard let managedTimeEntry = try context.fetch(request).first else { throw FetchFailedError() }
        context.delete(managedTimeEntry)
    }

    private func generateFetchByIdRequest(_ id: Int64) -> NSFetchRequest<ManagedTimeEntry> {
        let request = NSFetchRequest<ManagedTimeEntry>(entityName: String(describing: ManagedTimeEntry.self))
        request.predicate = NSPredicate(format: "id == %@", id)
        return request
    }

    private func executeFetchRequest(_ request: NSFetchRequest<ManagedTimeEntry>) throws -> [TimeEntryDAOProtocol] {
        let context = database.persistentContainer.viewContext
        let timeEntries = try context.fetch(request)
        return timeEntries
    }
}
