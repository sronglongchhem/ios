import Foundation

public struct Event {
    public let name: String
    public let parameters: [String: Any]?
    
    public init(_ name: String, parameters: [String: Any]? = nil) {
        self.name = name
        self.parameters = parameters
    }
}

public protocol EventConvertible {
    func toEvent() -> Event?
}
