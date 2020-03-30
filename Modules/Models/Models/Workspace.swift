import Foundation

public struct Workspace: Codable, Entity, Equatable {
    
    public var id: Int64
    public var name: String
    public var admin: Bool
    
     enum CodingKeys: String, CodingKey {
         case id
         case name
         case admin
     }
    
    public init(id: Int64, name: String, admin: Bool) {
        self.id = id
        self.name = name
        self.admin = admin
    }
}
