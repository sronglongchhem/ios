import Foundation
import Database
import Models

struct TimeEntryDAO: TimeEntryDAOProtocol {
    var id: Int64
    var textDescription: String
    var start: Date
    var duration: NSNumber?
    var billable: Bool
    var workspaceId: Int
}

extension TimeEntryDAOProtocol {
    func toTimeEntry() -> TimeEntry {
        return TimeEntry(
            id: Int(self.id),
            description: self.textDescription,
            start: self.start,
            duration: self.duration?.doubleValue,
            billable: self.billable,
            workspaceId: self.workspaceId)
    }
}

extension TimeEntry {
    func toDAO() -> TimeEntryDAOProtocol {
        return TimeEntryDAO(
            id: Int64(self.id),
            textDescription: self.description,
            start: self.start,
            duration: NSNumber.fromDouble(self.duration),
            billable: self.billable,
            workspaceId: self.workspaceId)
    }
}

extension NSNumber {
    public static func fromDouble(_ double: Double?) -> NSNumber? {
        guard let double = double else { return nil }
        return NSNumber(value: double)
    }
}
