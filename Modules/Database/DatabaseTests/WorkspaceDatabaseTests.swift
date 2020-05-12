import XCTest
import Models
import Utils
import CoreData
@testable import Database

class WorkspaceDatabaseTests: XCTestCase {

    override func run() {
        super.run()
        let suite = XCTestSuite(forTestCaseClass: WorkspaceDatabaseTestCases.self)
        suite.run()
    }

    func testDummy() {
        XCTAssert(true)
    }
}

class WorkspaceDatabaseTestCases: EntityDatabaseRxExtensionsTests<Workspace> {

    override var initialEntities: [Workspace] {
        [
            Workspace(id: 0, name: "Workspace 0", admin: true),
            Workspace(id: 1, name: "Workspace 1", admin: true),
            Workspace(id: 2, name: "Workspace 2", admin: true)
        ]
    }

    override var insertedEntities: [Workspace] {
        [
            Workspace(id: 3, name: "Workspace 3", admin: true),
            Workspace(id: 4, name: "Workspace 4", admin: true)
        ]
    }

    override var updatedEntities: [Workspace] {
        [
            Workspace(id: 0, name: "Updated name", admin: false),
            Workspace(id: 1, name: "Workspace 1", admin: false),
            Workspace(id: 2, name: "Workspace 2", admin: true)
        ]
    }

    override var entityDatabase: EntityDatabase<Workspace> {
        database.workspaces
    }
}
