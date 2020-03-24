import Foundation
import Models

extension TimeEntry {
    static func with(id: Int, start: Date? = nil, duration: TimeInterval? = nil) -> TimeEntry {
        return TimeEntry(
            id: id,
            description: "",
            start: start ?? Date(),
            duration: duration ?? 0,
            billable: false,
            workspaceId: 0)
    }
}
