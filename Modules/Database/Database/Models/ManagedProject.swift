import Foundation
import CoreData

public protocol ProjectDAOProtocol {
    var id: Int64 { get set }
    var workspaceId: Int64 { get set }
    var clientId: Int64 { get set }
    var name: String { get set }
    var color: String { get set }
    var isBillable: Bool { get set }
    var isPrivate: Bool { get set }
    var isActive: Bool { get set }
}

@objc(ManagedProject)
final class ManagedProject: NSManagedObject, ProjectDAOProtocol {
    @NSManaged var id: Int64
    @NSManaged var workspaceId: Int64
    @NSManaged var clientId: Int64
    @NSManaged var name: String
    @NSManaged var color: String
    @NSManaged var isBillable: Bool
    @NSManaged var isPrivate: Bool
    @NSManaged var isActive: Bool
}

extension ManagedProject {
    func fromDAO(projectDAO: ProjectDAOProtocol) {
        self.id = projectDAO.id
        self.workspaceId = projectDAO.workspaceId
        self.clientId = projectDAO.clientId
        self.name = projectDAO.name
        self.color = projectDAO.color
        self.isBillable = projectDAO.isBillable
        self.isPrivate = projectDAO.isPrivate
        self.isActive = projectDAO.isActive
    }
}

extension ManagedProject: ManagedEntity {
    static var entityName = String(describing: ManagedProject.self)
}

public protocol ProjectsDatabase {
    func getAll() throws -> [ProjectDAOProtocol]
    func getOne(id: Int64) throws -> ProjectDAOProtocol
    func insertAll(projects: [ProjectDAOProtocol]) throws -> [Int]
    func insert(project: ProjectDAOProtocol) throws -> Int
    func update(project: ProjectDAOProtocol) throws
    func updateAll(projects: [ProjectDAOProtocol]) throws
    func delete(project: ProjectDAOProtocol) throws
    func delete(id: Int64) throws
}

struct Projects: ProjectsDatabase {

    private let database: Database

    public init(database: Database) {
        self.database = database
    }

    // Query("SELECT * FROM Project")
    public func getAll() throws -> [ProjectDAOProtocol] {
        let request = ManagedProject.fetchRequest() as NSFetchRequest<ManagedProject>
        return try executeFetchRequest(request)
    }

    // Query("SELECT * FROM Project WHERE id = :id")
    public func getOne(id: Int64) throws -> ProjectDAOProtocol {
        let request = ManagedProject.fetchRequest(id: id)
        return try executeFetchRequest(request).first!
    }

    // Insert
    public func insertAll(projects: [ProjectDAOProtocol]) throws -> [Int] {
        let context = database.persistentContainer.viewContext
        let managedProjects = try projects.compactMap { project -> ManagedProject in
            let managedProject = try ManagedProject.insert(into: context)
            managedProject.fromDAO(projectDAO: project)
            return managedProject
        }
        try context.save()
        return managedProjects.map { Int($0.id) }
    }

    // Insert
    public func insert(project: ProjectDAOProtocol) throws -> Int {
        let context = database.persistentContainer.viewContext
        let managedProject = try ManagedProject.insert(into: context)
        managedProject.fromDAO(projectDAO: project)
        let lastId = try getAll().last?.id ?? -1
        managedProject.id = Int64(lastId + 1)
        try context.save()
        return Int(managedProject.id)
    }

    // Update
    public func update(project: ProjectDAOProtocol) throws {
        let context = database.persistentContainer.viewContext
        let request = ManagedProject.fetchRequest(id: project.id)
        guard let managedProject = try context.fetch(request).first else { throw FetchFailedError() }
        managedProject.fromDAO(projectDAO: project)
        try context.save()
    }

    // Update
    public func updateAll(projects: [ProjectDAOProtocol]) throws {
        try projects.forEach { try update(project: $0) }
    }

    // Delete
    public func delete(project: ProjectDAOProtocol) throws {
        try delete(id: project.id)
    }

    // Delete by id
    public func delete(id: Int64) throws {
        let context = database.persistentContainer.viewContext
        let request = ManagedProject.fetchRequest(id: id)
        guard let managedProject = try context.fetch(request).first else { throw FetchFailedError() }
        context.delete(managedProject)
    }

    private func executeFetchRequest(_ request: NSFetchRequest<ManagedProject>) throws -> [ProjectDAOProtocol] {
        let context = database.persistentContainer.viewContext
        let projects = try context.fetch(request)
        return projects
    }
}
