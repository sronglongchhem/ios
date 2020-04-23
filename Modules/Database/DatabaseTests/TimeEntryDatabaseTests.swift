import XCTest
import Models
import Utils
import CoreData
@testable import Database

// swiftlint:disable force_try
class TimeEntryDatabaseTests: EntityDatabaseRxExtensionsTests<TimeEntry> {

    let now = Date()

    override var initialEntities: [TimeEntry] {
        [
            TimeEntry(id: 0, description: "TimeEntry 0", start: now, duration: nil, billable: false, workspaceId: 0),
            TimeEntry(id: 1, description: "TimeEntry 1", start: now.addingTimeInterval(-10), duration: 10, billable: false, workspaceId: 0),
            TimeEntry(id: 2, description: "TimeEntry 2", start: now.addingTimeInterval(10), duration: 10, billable: false, workspaceId: 0)
        ]
    }

    override var insertedEntities: [TimeEntry] {
        [
            TimeEntry(id: 3, description: "TimeEntry 3", start: now, duration: 10, billable: false, workspaceId: 0),
            TimeEntry(id: 4, description: "TimeEntry 4", start: now, duration: 10, billable: false, workspaceId: 0)
        ]
    }

    override var updatedEntities: [TimeEntry] {
        [
            TimeEntry(id: 0, description: "Updated name", start: now, duration: 10, billable: false, workspaceId: 0),
            TimeEntry(id: 1, description: "TimeEntry 1", start: now, duration: 100, billable: false, workspaceId: 1),
            TimeEntry(id: 2, description: "TimeEntry 2", start: now, duration: 10, billable: false, workspaceId: 0)
        ]
    }

    override var entityDatabase: EntityDatabase<TimeEntry> {
        database.timeEntries
    }

    override func setUp() {
        insertEntity(entity: Workspace(id: 0, name: "Workspace 0", admin: true))
        insertEntity(entity: Workspace(id: 1, name: "Workspace 1", admin: true))
        super.setUp()
    }

    func testGetAllSorted() {
        let entities = try! entityDatabase.getAllSorted()
        XCTAssertEqual(entities, initialEntities.sorted(by: { $0.start > $1.start }), "getAllSorted must return all entities sorted by start date")
    }

    func testGetAllRunning() {
        let entities = try! entityDatabase.getAllRunning()
        XCTAssertEqual(entities, [initialEntities[0]], "getAllRunning must return only running entries")
    }
}
