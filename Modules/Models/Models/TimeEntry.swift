//
//  TimeEntry.swift
//  Models
//
//  Created by Ricardo Sánchez Sotres on 19/02/2020.
//  Copyright © 2020 Ricardo Sánchez Sotres. All rights reserved.
//

import Foundation

public struct TimeEntry: Entity
{
    public var id: Int
    public var description: String
    public var start: Date
    public var duration: Double
    public var billable: Bool

    public var workspaceId: Int
    public var projectId: Int?
    public var taskId: Int?
    public var tagIds: [Int]?
}

extension TimeEntry: Codable
{
    private var createdWith: String { "AppleWatchApp" }
    
    private var encodedDuration: Int64
    {
        guard duration >= 0 else { return Int64(-start.timeIntervalSince1970) }
        return Int64(duration)
    }

    private enum CodingKeys: String, CodingKey
    {
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
    
    private enum EncodeKeys: String, CodingKey
    {
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
    
    public func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: EncodeKeys.self)
        
        try container.encode(description, forKey: .description)
//        try container.encode(start.toServerEncodedDateString(), forKey: .start)
        try container.encode(billable, forKey: .billable)
        try container.encode(encodedDuration, forKey: .duration)
        try container.encode(workspaceId, forKey: .workspaceId)
        try container.encode(projectId, forKey: .projectId)
        try container.encode(taskId, forKey: .taskId)
        try container.encode(tagIds ?? [Int](), forKey: .tagIds)
        try container.encode(createdWith, forKey: .createdWith)
    }
}
