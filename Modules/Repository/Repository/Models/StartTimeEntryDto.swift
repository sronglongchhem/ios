import Foundation
import Models

public struct StartTimeEntryDto {
    public let workspaceId: Int64
    public let description: String
    
    public init(workspaceId: Int64, description: String) {
        self.description = description
        self.workspaceId = workspaceId
    }
}

extension TimeEntry {
    public func toStartTimeEntryDto() -> StartTimeEntryDto {
        return StartTimeEntryDto(workspaceId: self.workspaceId, description: self.description)
    }
}
