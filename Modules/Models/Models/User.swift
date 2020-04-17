import Foundation

public struct User: Codable, Equatable {
    
    public var id: Int64
    public var apiToken: String
    public var defaultWorkspace: Int64

    public init(id: Int64, apiToken: String, defaultWorkspace: Int64) {
        self.id = id
        self.apiToken = apiToken
        self.defaultWorkspace = defaultWorkspace
    }

    enum CodingKeys: String, CodingKey {
        case id    
        case apiToken = "api_token"
        case defaultWorkspace = "default_workspace_id"
    }
}

extension User: CustomStringConvertible {
    public var description: String {
        return "\(id)"
    }
}
