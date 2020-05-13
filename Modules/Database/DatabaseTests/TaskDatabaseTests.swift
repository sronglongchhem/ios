import XCTest
import Models
import Utils
import CoreData
@testable import Database

class TaskDatabaseTests: EntityDatabaseRxExtensionsTests<Task> {

    override var initialEntities: [Task] {
        [
            Task(id: 0, name: "Task 0", active: true, estimatedSeconds: 0, trackedSeconds: 0, projectId: 0, workspaceId: 0, userId: nil),
            Task(id: 1, name: "Task 1", active: true, estimatedSeconds: 0, trackedSeconds: 0, projectId: 0, workspaceId: 0, userId: nil),
            Task(id: 2, name: "Task 2", active: true, estimatedSeconds: 0, trackedSeconds: 0, projectId: 0, workspaceId: 0, userId: nil)
        ]
    }

    override var insertedEntities: [Task] {
        [
            Task(id: 3, name: "Task 3", active: true, estimatedSeconds: 0, trackedSeconds: 0, projectId: 0, workspaceId: 0, userId: nil),
            Task(id: 4, name: "Task 4", active: true, estimatedSeconds: 0, trackedSeconds: 0, projectId: 0, workspaceId: 1, userId: nil)
        ]
    }

    override var updatedEntities: [Task] {
        [
            Task(id: 0, name: "Updated name", active: true, estimatedSeconds: 0, trackedSeconds: 0, projectId: 0, workspaceId: 0, userId: nil),
            Task(id: 1, name: "Task 0", active: false, estimatedSeconds: 0, trackedSeconds: 0, projectId: 0, workspaceId: 0, userId: nil),
            Task(id: 2, name: "Task 0", active: true, estimatedSeconds: 10, trackedSeconds: 0, projectId: 1, workspaceId: 0, userId: nil)
        ]
    }

    override var entityDatabase: EntityDatabase<Task> {
        database.tasks
    }

    override func setUp() {
        insertEntity(entity: Workspace(id: 0, name: "Workspace 0", admin: true))
        insertEntity(entity: Workspace(id: 1, name: "Workspace 1", admin: true))
        insertEntity(entity: Client(id: 1, name: "Client 1", workspaceId: 0))
        insertEntity(entity:
            Project(id: 0, name: "Project 0", isPrivate: true, isActive: true, color: "", billable: nil, workspaceId: 0, clientId: 0)
        )
        insertEntity(entity:
            Project(id: 1, name: "Project 1", isPrivate: true, isActive: true, color: "", billable: nil, workspaceId: 0, clientId: 0)
        )
        super.setUp()
    }
}
