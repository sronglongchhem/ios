import Foundation

public struct TimeEntry: Entity, Equatable {
    
    public var id: Int64
    public var description: String
    public var start: Date
    public var duration: Double?
    public var billable: Bool

    public var workspaceId: Int64
    public var projectId: Int64?
    public var taskId: Int64?
    public var tagIds: [Int64]?
    
    public init (
        id: Int64,
        description: String,
        start: Date,
        duration: Double?,
        billable: Bool,
        workspaceId: Int64
    ) {
        self.id = id
        self.description = description
        self.start = start
        self.duration = duration
        self.billable = billable
        self.workspaceId = workspaceId
    }
}

extension TimeEntry: Codable {
    
    private var createdWith: String { "AppleWatchApp" }
    
    private var encodedDuration: Int64 {
        guard let duration = duration, duration >= 0 else { return Int64(-start.timeIntervalSince1970) }
        return Int64(duration)
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case description
        case start
        case duration
        case billable
        
        case workspaceId = "workspace_id"
        case projectId = "project_id"
        case taskId = "task_id"
        case tagIds = "tag_ids"
    }
    
    private enum EncodeKeys: String, CodingKey {
        case description
        case start
        case billable
        case duration
        
        case workspaceId = "workspace_id"
        case projectId = "project_id"
        case taskId = "task_id"
        case tagIds = "tag_ids"
        case createdWith = "created_with"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EncodeKeys.self)
        
        try container.encode(description, forKey: .description)
//        try container.encode(start.toServerEncodedDateString(), forKey: .start)
        try container.encode(billable, forKey: .billable)
        try container.encode(encodedDuration, forKey: .duration)
        try container.encode(workspaceId, forKey: .workspaceId)
        try container.encode(projectId, forKey: .projectId)
        try container.encode(taskId, forKey: .taskId)
        try container.encode(tagIds ?? [Int64](), forKey: .tagIds)
        try container.encode(createdWith, forKey: .createdWith)
    }
}

public extension TimeEntry {
    func with(description: String? = nil, billable: Bool? = nil) -> TimeEntry {
        return TimeEntry(
            id: self.id,
            description: description ?? self.description,
            start: self.start,
            duration: self.duration,
            billable: billable ?? self.billable,
            workspaceId: self.workspaceId)
    }
}
