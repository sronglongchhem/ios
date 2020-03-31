import Foundation
import CoreData

public protocol ClientDAOProtocol {
    var id: Int64 { get set }
    var workspaceId: Int { get set }
    var name: String { get set }
}

@objc(ManagedClient)
final class ManagedClient: NSManagedObject, ClientDAOProtocol {
    @NSManaged var id: Int64
    @NSManaged var workspaceId: Int
    @NSManaged var name: String
}

extension ManagedClient {
    func fromDAO(clientDAO: ClientDAOProtocol) {
        self.id = clientDAO.id
        self.workspaceId = clientDAO.workspaceId
        self.name = clientDAO.name
    }
}

extension ManagedClient: ManagedEntity {
    static var entityName = String(describing: ManagedClient.self)
}

public protocol ClientsDatabase {
    func getAll() throws -> [ClientDAOProtocol]
    func getOne(id: Int64) throws -> ClientDAOProtocol
    func insertAll(clients: [ClientDAOProtocol]) throws -> [Int]
    func insert(client: ClientDAOProtocol) throws -> Int
    func update(client: ClientDAOProtocol) throws
    func updateAll(clients: [ClientDAOProtocol]) throws
    func delete(client: ClientDAOProtocol) throws
    func delete(id: Int64) throws
}

struct Clients: ClientsDatabase {

    private let database: Database

    public init(database: Database) {
        self.database = database
    }

    // Query("SELECT * FROM Client")
    public func getAll() throws -> [ClientDAOProtocol] {
        let request = ManagedClient.fetchRequest() as NSFetchRequest<ManagedClient>
        return try executeFetchRequest(request)
    }

    // Query("SELECT * FROM Client WHERE id = :id")
    public func getOne(id: Int64) throws -> ClientDAOProtocol {
        let request = ManagedClient.fetchRequest(id: id)
        return try executeFetchRequest(request).first!
    }

    // Insert
    public func insertAll(clients: [ClientDAOProtocol]) throws -> [Int] {
        let context = database.persistentContainer.viewContext
        let managedClients = try clients.compactMap { client -> ManagedClient in
            let managedClient = try ManagedClient.insert(into: context)
            managedClient.fromDAO(clientDAO: client)
            return managedClient
        }
        try context.save()
        return managedClients.map { Int($0.id) }
    }

    // Insert
    public func insert(client: ClientDAOProtocol) throws -> Int {
        let context = database.persistentContainer.viewContext
        let managedClient = try ManagedClient.insert(into: context)
        managedClient.fromDAO(clientDAO: client)
        let lastId = try getAll().last?.id ?? -1
        managedClient.id = Int64(lastId + 1)
        try context.save()
        return Int(managedClient.id)
    }

    // Update
    public func update(client: ClientDAOProtocol) throws {
        let context = database.persistentContainer.viewContext
        let request = ManagedClient.fetchRequest(id: client.id)
        guard let managedClient = try context.fetch(request).first else { throw FetchFailedError() }
        managedClient.fromDAO(clientDAO: client)
        try context.save()
    }

    // Update
    public func updateAll(clients: [ClientDAOProtocol]) throws {
        try clients.forEach { try update(client: $0) }
    }

    // Delete
    public func delete(client: ClientDAOProtocol) throws {
        try delete(id: client.id)
    }

    // Delete by id
    public func delete(id: Int64) throws {
        let context = database.persistentContainer.viewContext
        let request = ManagedClient.fetchRequest(id: id)
        guard let managedClient = try context.fetch(request).first else { throw FetchFailedError() }
        context.delete(managedClient)
    }

    private func executeFetchRequest(_ request: NSFetchRequest<ManagedClient>) throws -> [ClientDAOProtocol] {
        let context = database.persistentContainer.viewContext
        let clients = try context.fetch(request)
        return clients
    }
}
