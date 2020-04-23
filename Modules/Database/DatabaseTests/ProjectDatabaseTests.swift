import XCTest
import Models
import Utils
import CoreData
@testable import Database

class ProjectDatabaseTests: EntityDatabaseRxExtensionsTests<Project> {

    override var initialEntities: [Project] {
        [
            Project(id: 0, name: "Project 0", isPrivate: true, isActive: true, color: "", billable: false, workspaceId: 0, clientId: 0),
            Project(id: 1, name: "Project 1", isPrivate: true, isActive: true, color: "", billable: false, workspaceId: 0, clientId: 0),
            Project(id: 2, name: "Project 2", isPrivate: true, isActive: true, color: "", billable: false, workspaceId: 0, clientId: 0)
        ]
    }

    override var insertedEntities: [Project] {
        [
            Project(id: 3, name: "Project 3", isPrivate: true, isActive: true, color: "", billable: false, workspaceId: 0, clientId: 0),
            Project(id: 4, name: "Project 4", isPrivate: true, isActive: true, color: "", billable: false, workspaceId: 0, clientId: 0)
        ]
    }

    override var updatedEntities: [Project] {
        [
            Project(id: 0, name: "Updated name", isPrivate: true, isActive: true, color: "", billable: false, workspaceId: 0, clientId: 0),
            Project(id: 1, name: "Project 1", isPrivate: false, isActive: true, color: "", billable: false, workspaceId: 0, clientId: 0),
            Project(id: 2, name: "Project 2", isPrivate: true, isActive: true, color: "", billable: false, workspaceId: 1, clientId: 0)
        ]
    }

    override var entityDatabase: EntityDatabase<Project> {
        database.projects
    }

    override func setUp() {
        insertEntity(entity: Workspace(id: 0, name: "Workspace 0", admin: true))
        insertEntity(entity: Workspace(id: 1, name: "Workspace 1", admin: true))
        insertEntity(entity: Client(id: 0, name: "Client 0", workspaceId: 0))
        super.setUp()
    }
}
