//
//  DatabaseTests.swift
//  DatabaseTests
//
//  Created by Ricardo Sánchez Sotres on 23/04/2020.
//  Copyright © 2020 Toggl OUT. All rights reserved.
//

import XCTest
@testable import Database

class DatabaseTests: XCTestCase {

    override func run() {
        super.run()
        XCTestSuite(forTestCaseClass: ClientDatabaseTests.self).run()
        XCTestSuite(forTestCaseClass: ProjectDatabaseTests.self).run()
        XCTestSuite(forTestCaseClass: TagDatabaseTests.self).run()
        XCTestSuite(forTestCaseClass: TaskDatabaseTests.self).run()
        XCTestSuite(forTestCaseClass: TimeEntryDatabaseTests.self).run()
        XCTestSuite(forTestCaseClass: WorkspaceDatabaseTests.self).run()
    }

    // NOTE: at least one test is needed for the test runner to call `run` in this class
    func testDummy() {
        XCTAssert(true)
    }
}
