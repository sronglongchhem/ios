import Foundation
import CoreData

public protocol TagDAOProtocol {
    var id: Int64 { get set }
    var workspaceId: Int { get set }
    var name: String { get set }
}

@objc(ManagedTag)
final class ManagedTag: NSManagedObject, TagDAOProtocol {
    @NSManaged var id: Int64
    @NSManaged var workspaceId: Int
    @NSManaged var name: String
}

extension ManagedTag {
    func fromDAO(tagDAO: TagDAOProtocol) {
        self.id = tagDAO.id
        self.workspaceId = tagDAO.workspaceId
        self.name = tagDAO.name
    }
}

extension ManagedTag: ManagedEntity {
    static var entityName = String(describing: ManagedTag.self)
}

public protocol TagsDatabase {
    func getAll() throws -> [TagDAOProtocol]
    func getOne(id: Int64) throws -> TagDAOProtocol
    func insertAll(tags: [TagDAOProtocol]) throws -> [Int]
    func insert(tag: TagDAOProtocol) throws -> Int
    func update(tag: TagDAOProtocol) throws
    func updateAll(tags: [TagDAOProtocol]) throws
    func delete(tag: TagDAOProtocol) throws
    func delete(id: Int64) throws
}

struct Tags: TagsDatabase {

    private let database: Database

    public init(database: Database) {
        self.database = database
    }

    // Query("SELECT * FROM Tag")
    public func getAll() throws -> [TagDAOProtocol] {
        let request = ManagedTag.fetchRequest() as NSFetchRequest<ManagedTag>
        return try executeFetchRequest(request)
    }

    // Query("SELECT * FROM Tag WHERE id = :id")
    public func getOne(id: Int64) throws -> TagDAOProtocol {
        let request = ManagedTag.fetchRequest(id: id)
        return try executeFetchRequest(request).first!
    }

    // Insert
    public func insertAll(tags: [TagDAOProtocol]) throws -> [Int] {
        let context = database.persistentContainer.viewContext
        let managedTags = try tags.compactMap { tag -> ManagedTag in
            let managedTag = try ManagedTag.insert(into: context)
            managedTag.fromDAO(tagDAO: tag)
            return managedTag
        }
        try context.save()
        return managedTags.map { Int($0.id) }
    }

    // Insert
    public func insert(tag: TagDAOProtocol) throws -> Int {
        let context = database.persistentContainer.viewContext
        let managedTag = try ManagedTag.insert(into: context)
        managedTag.fromDAO(tagDAO: tag)
        let lastId = try getAll().last?.id ?? -1
        managedTag.id = Int64(lastId + 1)
        try context.save()
        return Int(managedTag.id)
    }

    // Update
    public func update(tag: TagDAOProtocol) throws {
        let context = database.persistentContainer.viewContext
        let request = ManagedTag.fetchRequest(id: tag.id)
        guard let managedTag = try context.fetch(request).first else { throw FetchFailedError() }
        managedTag.fromDAO(tagDAO: tag)
        try context.save()
    }

    // Update
    public func updateAll(tags: [TagDAOProtocol]) throws {
        try tags.forEach { try update(tag: $0) }
    }

    // Delete
    public func delete(tag: TagDAOProtocol) throws {
        try delete(id: tag.id)
    }

    // Delete by id
    public func delete(id: Int64) throws {
        let context = database.persistentContainer.viewContext
        let request = ManagedTag.fetchRequest(id: id)
        guard let managedTag = try context.fetch(request).first else { throw FetchFailedError() }
        context.delete(managedTag)
    }

    private func executeFetchRequest(_ request: NSFetchRequest<ManagedTag>) throws -> [TagDAOProtocol] {
        let context = database.persistentContainer.viewContext
        let tags = try context.fetch(request)
        return tags
    }
}
