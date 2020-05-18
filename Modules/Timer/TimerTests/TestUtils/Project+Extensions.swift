import Foundation
import Models

extension Project {
    static func with(
        id: Int64? = nil,
        name: String = "",
        isPrivate: Bool = false,
        isActive: Bool = true,
        color: String = "#000000",
        billable: Bool? = nil,
        workspaceId: Int64 = 0,
        clientId: Int64? = nil) -> Project {
        let projectId = id ?? Int64(UUID().hashValue)
        return Project(id: projectId,
                       name: name,
                       isPrivate: isPrivate,
                       isActive: isActive,
                       color: color,
                       billable: billable,
                       workspaceId: workspaceId,
                       clientId: clientId)
    }
}
