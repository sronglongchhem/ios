import XCTest
import Models
import Utils
import CoreData
@testable import Database

class TagDatabaseTests: XCTestCase {

    override func run() {
        super.run()
        let suite = XCTestSuite(forTestCaseClass: TagDatabaseTestCases.self)
        suite.run()
    }

    func testDummy() {
        XCTAssert(true)
    }
}

class TagDatabaseTestCases: EntityDatabaseRxExtensionsTests<Tag> {

    override var initialEntities: [Tag] {
        [
            Tag(id: 0, name: "Tag 0", workspaceId: 0),
            Tag(id: 1, name: "Tag 1", workspaceId: 0),
            Tag(id: 2, name: "Tag 2", workspaceId: 0)
        ]
    }

    override var insertedEntities: [Tag] {
        [
            Tag(id: 3, name: "Tag 3", workspaceId: 0),
            Tag(id: 4, name: "Tag 4", workspaceId: 0)
        ]
    }

    override var updatedEntities: [Tag] {
        [
            Tag(id: 0, name: "Updated name", workspaceId: 0),
            Tag(id: 1, name: "Tag 1", workspaceId: 1),
            Tag(id: 2, name: "Tag 2", workspaceId: 0)
        ]
    }

    override var entityDatabase: EntityDatabase<Tag> {
        database.tags
    }

    override func setUp() {
        insertEntity(entity: Workspace(id: 0, name: "Workspace 0", admin: true))
        insertEntity(entity: Workspace(id: 1, name: "Workspace 1", admin: true))
        super.setUp()
    }
}
