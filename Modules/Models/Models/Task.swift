import Foundation

public struct Task: Codable, Entity, Equatable {
    
    public var id: Int64
    public var name: String
    public var active: Bool
    public var estimatedSeconds: Int
    public var trackedSeconds: Int
    
    public var projectId: Int64
    public var workspaceId: Int64
    public var userId: Int64?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case active
        
        case estimatedSeconds = "estimated_seconds"
        case trackedSeconds = "tracked_seconds"
        case projectId = "project_id"
        case workspaceId = "workspace_id"
        case userId = "user_id"
    }

    public init(
        id: Int64,
        name: String,
        active: Bool,
        estimatedSeconds: Int,
        trackedSeconds: Int,
        projectId: Int64,
        workspaceId: Int64,
        userId: Int64?
    ) {
        self.id = id
        self.name = name
        self.active = active
        self.estimatedSeconds = estimatedSeconds
        self.trackedSeconds = trackedSeconds
        self.projectId = projectId
        self.workspaceId = workspaceId
        self.userId = userId
    }
}
