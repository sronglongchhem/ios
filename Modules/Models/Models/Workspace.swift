//
//  Workspace.swift
//  TogglWatch WatchKit Extension
//
//  Created by Ricardo Sánchez Sotres on 15/10/2019.
//  Copyright © 2019 Toggl. All rights reserved.
//

import Foundation

public struct Workspace: Codable, Entity
{
    public var id: Int
    public var name: String
    public var admin: Bool
    
     enum CodingKeys: String, CodingKey
     {
         case id
         case name
         case admin
     }
}
