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

    public init(
        id: Int64,
        name: String,
        workspaceId: Int64
    ) {
        self.id = id
        self.name = name
        self.workspaceId = workspaceId
    }
}
