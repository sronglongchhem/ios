import Foundation

public struct Event {
    public let name: String
    public let parameters: [String: Any]?
    
    private init(_ name: String, parameters: [String: Any]? = nil) {
        self.name = name
        self.parameters = parameters
    }
    
    public static func editViewClosed(_ reason: EditViewCloseReason) -> Event {
        return Event("EditViewClosed", parameters: ["Reason": reason.rawValue.capitalized])
    }
    
    public static func editViewOpened(_ reason: EditViewOpenReason) -> Event {
        //The parameter is named "Origin" and not "Reason" for legacy reasons
        return Event("EditViewOpened", parameters: ["Origin": reason.rawValue.capitalized])
    }
    
    public static func timeEntryStopped(_ origin: TimeEntryStopOrigin) -> Event {
        return Event("TimeEntryStopped", parameters: ["Origin": origin.rawValue.capitalized])
    }
    
    public static func timeEntryDeleted(_ origin: TimeEntryDeleteOrigin) -> Event {
        //The parameter is named "Source" and not "Origin" for legacy reasons
        return Event("DeleteTimeEntry", parameters: ["Source": origin.rawValue.capitalized])
    }
    
    public static func undoTapped() -> Event {
        return Event("TimeEntryDeletionUndone", parameters: [:])
    }
}
