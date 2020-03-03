//
//  Tag.swift
//  TogglWatch WatchKit Extension
//
//  Created by Ricardo Sánchez Sotres on 15/10/2019.
//  Copyright © 2019 Toggl. All rights reserved.
//

import Foundation

public struct Tag: Codable, Entity
{
    public var id: Int
    public var name: String
    
    public var workspaceId: Int

    enum CodingKeys: String, CodingKey
    {
        case id
        case name
        
        case workspaceId = "workspace_id"
    }
}
