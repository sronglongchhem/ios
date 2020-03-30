import Foundation

public struct Client: Codable, Entity, Equatable {
    
    public var id: Int64
    public var name: String
    
    public var workspaceId: Int64
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    
        case workspaceId = "wid"
    }
}
