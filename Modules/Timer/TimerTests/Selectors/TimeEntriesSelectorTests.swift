import XCTest
@testable import Timer
import Models

class TimeEntriesSelectorTests: XCTestCase {

    private static var now: Date = {
        var calendar = Calendar(identifier: .gregorian)
        let components = DateComponents(year: 2019, month: 02, day: 07, hour: 16, minute: 25, second: 38)
        return calendar.date(from: components)!
    }()
    
    private static let workspaceA: Workspace = Workspace(id: 1, name: "", admin: true)
    private static let workspaceB: Workspace = Workspace(id: 2, name: "", admin: true)

    private let singleItemGroup = [
        TimeEntry.with(description: "S", start: now.addingTimeInterval(-110), duration: 1, workspaceId: workspaceA.id)
    ]

    private let groupA = [
        TimeEntry.with(description: "A", start: now, duration: 1, workspaceId: workspaceA.id),
        TimeEntry.with(description: "A", start: now.addingTimeInterval(-50), duration: 2, workspaceId: workspaceA.id),
        TimeEntry.with(description: "A", start: now.addingTimeInterval(-100), duration: 4, workspaceId: workspaceA.id)
    ]

    private let groupB = [
        TimeEntry.with(description: "B", start: now.addingTimeInterval(-200), duration: 1, workspaceId: workspaceB.id),
        TimeEntry.with(description: "B", start: now.addingTimeInterval(-250), duration: 2, workspaceId: workspaceB.id),
        TimeEntry.with(description: "B", start: now.addingTimeInterval(-300), duration: 4, workspaceId: workspaceB.id)
    ]

    private let twoWorkspaces = [
        TimeEntry.with(description: "B", start: now, duration: 1, workspaceId: workspaceA.id),
        TimeEntry.with(description: "B", start: now.addingTimeInterval(50), duration: 2, workspaceId: workspaceB.id)
    ]

    private let differentDescriptions = [
        TimeEntry.with(description: "C1", start: now, duration: 1, workspaceId: workspaceA.id),
        TimeEntry.with(description: "C1", start: now.addingTimeInterval(-50), duration: 2, workspaceId: workspaceA.id),
        TimeEntry.with(description: "C2", start: now.addingTimeInterval(-100), duration: 4, workspaceId: workspaceA.id)
    ]

    private let longDuration = [
        TimeEntry.with(description: "D1", start: now, duration: 1.5 * 3600, workspaceId: workspaceA.id),
        TimeEntry.with(description: "D1", start: now.addingTimeInterval(-50), duration: 2.5 * 3600, workspaceId: workspaceA.id),
        TimeEntry.with(description: "D2", start: now.addingTimeInterval(-100), duration: 3.5 * 3600, workspaceId: workspaceA.id)
    ]

    private var state: TimeEntriesLogState!
    
    override func setUp() {
        state = TimeEntriesLogState(entities: TimeLogEntities(), expandedGroups: [])
        state.entities.workspaces = [
            TimeEntriesSelectorTests.workspaceA.id: TimeEntriesSelectorTests.workspaceA,
            TimeEntriesSelectorTests.workspaceB.id: TimeEntriesSelectorTests.workspaceB
        ]
    }

    // swiftlint:disable function_body_length
    func testTransformsTimeEntriesIntoACorrectTree() {
        
        assertTransformsTimeEntriesIntoACorrectTree(
            expandedGroups: [],
            timeEntries: groupA,
            expected: [
                logOf(collapsed(groupA))
            ]
        )
        
        assertTransformsTimeEntriesIntoACorrectTree(
            expandedGroups: expandedGroups(groupA),
            timeEntries: groupA,
            expected: [
                logOf(expanded(groupA))
            ]
        )
        
        assertTransformsTimeEntriesIntoACorrectTree(
            expandedGroups: expandedGroups(groupA),
            timeEntries: groupA + groupB,
            expected: [
                logOf(expanded(groupA) + collapsed(groupB))
            ]
        )
        
        assertTransformsTimeEntriesIntoACorrectTree(
            expandedGroups: expandedGroups(groupB),
            timeEntries: singleItemGroup,
            expected: [
                logOf(single(singleItemGroup.first!))
            ]
        )
        
        assertTransformsTimeEntriesIntoACorrectTree(
            expandedGroups: expandedGroups(),
            timeEntries: groupA + singleItemGroup + groupB,
            expected: [
                logOf(
                    collapsed(groupA)
                        + single(singleItemGroup.first!)
                        + collapsed(groupB)
                )
            ]
        )
        
        assertTransformsTimeEntriesIntoACorrectTree(
            expandedGroups: expandedGroups(groupA),
            timeEntries: groupA + singleItemGroup + groupB,
            expected: [
                logOf(
                    expanded(groupA)
                        + single(singleItemGroup.first!)
                        + collapsed(groupB)
                )
            ]
        )
        
        assertTransformsTimeEntriesIntoACorrectTree(
            expandedGroups: expandedGroups(groupB),
            timeEntries: groupA + singleItemGroup + groupB,
            expected: [
                logOf(
                    collapsed(groupA)
                        + single(singleItemGroup.first!)
                        + expanded(groupB)
                )
            ]
        )

        assertTransformsTimeEntriesIntoACorrectTree(
            expandedGroups: expandedGroups(groupA, groupB),
            timeEntries: groupA + singleItemGroup + groupB,
            expected: [
                logOf(
                    expanded(groupA)
                        + single(singleItemGroup.first!)
                        + expanded(groupB)
                )
            ]
        )

        assertTransformsTimeEntriesIntoACorrectTree(
            expandedGroups: expandedGroups(),
            timeEntries: twoWorkspaces,
            expected: [
                logOf(
                    single(twoWorkspaces[0])
                        + single(twoWorkspaces[1])
                )
            ]
        )
        
        assertTransformsTimeEntriesIntoACorrectTree(
            expandedGroups: expandedGroups(),
            timeEntries: differentDescriptions,
            expected: [
                logOf(
                    collapsed(Array(differentDescriptions.prefix(2)))
                    + single(differentDescriptions[2])
                )
            ]
        )
        
        assertTransformsTimeEntriesIntoACorrectTree(
            expandedGroups: expandedGroups(),
            timeEntries: longDuration,
            expected: [
                logOf(
                    collapsed(Array(longDuration.prefix(2)))
                    + single(longDuration[2])
                )
            ]
        )
    }

    private func assertTransformsTimeEntriesIntoACorrectTree(
        expandedGroups: Set<Int>,
        timeEntries: [TimeEntry],
        expected: [DayViewModel],
        file: StaticString = #file,
        line: UInt = #line) {
        
        state.entities.timeEntries = timeEntries.reduce([Int64: TimeEntry]()) { acc, timeEntry in
            var copy = acc
            copy[timeEntry.id] = timeEntry
            return copy
        }
        state.expandedGroups = expandedGroups
        
        let expandedGroups = expandedGroupsSelector(state)
        let timeEntryViewModels = timeEntryViewModelsSelector(state)
        let result = toDaysMapper(timeEntryViewModels, expandedGroups)
        
        XCTAssertEqual(result, expected, file: file, line: line)
    }
    
    private func expandedGroups(_ timeEntryGroups: [TimeEntry]...) -> Set<Int> {
        return Set(timeEntryGroups.map {
            return TimeEntryViewModel(timeEntry: $0.first!).groupId
        })
    }
    
    private func logOf(_ logCellViewModels: [TimeLogCellViewModel]) -> DayViewModel {
        return DayViewModel(timeLogCells: logCellViewModels.sorted(by: { $0.start > $1.start }))
    }
    
    private func single(_ timeEntry: TimeEntry) -> [TimeLogCellViewModel] {
        let timeEntryViewModel = TimeEntryViewModel(timeEntry: timeEntry)
        return [TimeLogCellViewModel.singleEntry(timeEntryViewModel, inGroup: false)]
    }
    
    private func collapsed(_ timeEntries: [TimeEntry]) -> [TimeLogCellViewModel] {
        
        let timeEntreViewModels = timeEntries
            .map {
                TimeEntryViewModel(timeEntry: $0)
            }
            .sorted(by: { $0.start > $1.start })
        
        return [TimeLogCellViewModel.groupedEntriesHeader(timeEntreViewModels, open: false)]
    }
    
    private func expanded(_ timeEntries: [TimeEntry]) -> [TimeLogCellViewModel] {
        let timeEntreViewModels = timeEntries
            .map {
                TimeEntryViewModel(timeEntry: $0)
            }
            .sorted(by: { $0.start > $1.start })
        
        return [TimeLogCellViewModel.groupedEntriesHeader(timeEntreViewModels, open: true)]
            + timeEntreViewModels.map {
                TimeLogCellViewModel.singleEntry($0, inGroup: true)
            }
    }
}

extension DayViewModel: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "\(dayString), duration: \(durationString), entries: \(items)"
    }
}

extension TimeLogCellViewModel: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "\(description): \(start)"
    }
}
