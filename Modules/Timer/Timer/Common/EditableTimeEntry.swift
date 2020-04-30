import Foundation
import Models
import Repository

public struct EditableTimeEntry: Equatable {
    public var ids: [Int64]
    public var workspaceId: Int64
    public var description: String
    public var billable: Bool
    public var start: Date?
    public var duration: TimeInterval?
    public var editableProject: EditableProject?
    
    private init(
        ids: [Int64],
        workspaceId: Int64,
        description: String,
        billable: Bool,
        start: Date? = nil,
        duration: TimeInterval? = nil,
        editableProject: EditableProject? = nil
    ) {
        self.ids = ids
        self.workspaceId = workspaceId
        self.description = description
        self.billable = billable
        self.start = start
        self.duration = duration
        self.editableProject = editableProject
    }
    
    public static func empty(workspaceId: Int64) -> EditableTimeEntry {
        return EditableTimeEntry(
            ids: [],
            workspaceId: workspaceId,
            description: "",
            billable: false
        )
    }
    
    public static func fromSingle(_ timeEntry: TimeEntry) -> EditableTimeEntry {
        return EditableTimeEntry(
            ids: [timeEntry.id],
            workspaceId: timeEntry.workspaceId,
            description: timeEntry.description,
            billable: timeEntry.billable,
            start: timeEntry.start,
            duration: timeEntry.duration
        )
    }
    
    public static func fromGroup(ids: [Int64], groupSample: TimeEntry) -> EditableTimeEntry {
        return EditableTimeEntry(
            ids: ids,
            workspaceId: groupSample.workspaceId,
            description: groupSample.description,
            billable: groupSample.billable
        )
    }
}

extension EditableTimeEntry {
    func toStartTimeEntryDto() -> StartTimeEntryDto {
        return StartTimeEntryDto(workspaceId: self.workspaceId, description: self.description)
    }

    var isRunningOrNew: Bool {
        return self.duration == nil
    }

    var isGroup: Bool {
        return self.ids.count > 1
    }
}
