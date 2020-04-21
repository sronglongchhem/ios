import Foundation

public struct EditableProject: Equatable {
    public var name: String
    public var isPrivate: Bool
    public var isActive: Bool
    public var color: String
    public var billable: Bool?
    
    public var workspaceId: Int64
    public var clientId: Int64?
    
    private init(
        name: String,
        isPrivate: Bool,
        isActive: Bool,
        color: String,
        billable: Bool?,
        workspaceId: Int64,
        clientId: Int64?
    ) {
        self.name = name
        self.isActive = isActive
        self.isPrivate = isPrivate
        self.color = color
        self.billable = billable
        self.workspaceId = workspaceId
        self.clientId = clientId
    }
    
    public static func empty(workspaceId: Int64) -> EditableProject {
        return EditableProject(
            name: "",
            isPrivate: true,
            isActive: true,
            color: "",
            billable: nil,
            workspaceId: workspaceId,
            clientId: nil
        )
    }
}
