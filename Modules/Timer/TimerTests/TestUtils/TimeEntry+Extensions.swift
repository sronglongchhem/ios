import Foundation
import Models

extension TimeEntry {
    static func with(id: Int? = nil, description: String = "", start: Date? = nil, duration: TimeInterval? = nil, workspaceId: Int = 0) -> TimeEntry {
        let timeEntryId = id ?? UUID().hashValue
        return TimeEntry(
            id: timeEntryId,
            description: description,
            start: start ?? Date(),
            duration: duration ?? 0,
            billable: false,
            workspaceId: workspaceId)
    }
}
