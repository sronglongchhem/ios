import XCTest
import Models
import Utils
import CoreData
@testable import Database

class ClientDatabaseTests: EntityDatabaseRxExtensionsTests<Client> {

    override var initialEntities: [Client] {
        [
            Client(id: 0, name: "Client 0", workspaceId: 0),
            Client(id: 1, name: "Client 1", workspaceId: 0),
            Client(id: 2, name: "Client 2", workspaceId: 0)
        ]
    }

    override var insertedEntities: [Client] {
        [
            Client(id: 3, name: "Client 3", workspaceId: 0),
            Client(id: 4, name: "Client 4", workspaceId: 0)
        ]
    }

    override var updatedEntities: [Client] {
        [
            Client(id: 0, name: "Updated name", workspaceId: 0),
            Client(id: 1, name: "Client 1", workspaceId: 1),
            Client(id: 2, name: "Client 2", workspaceId: 0)
        ]
    }

    override var entityDatabase: EntityDatabase<Client> {
        database.clients
    }

    override func setUp() {
        insertEntity(entity: Workspace(id: 0, name: "Workspace 0", admin: true))
        insertEntity(entity: Workspace(id: 1, name: "Workspace 1", admin: true))
        super.setUp()
    }
}
