import Foundation

public typealias RoutePath = String

public protocol Route {
    var path: RoutePath { get }
    var root: Route? { get }
}

public extension Route where Self: RawRepresentable, Self.RawValue == String {
    var path: String {
        return "\(root?.path ?? "root")/\(self.rawValue)"
    }
}
