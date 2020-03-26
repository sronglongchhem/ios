import Foundation
import Models
import Architecture

public struct LoadingState: Equatable {
    public var entities: TimeLogEntities
    public var route: RoutePath
    
    public init(entities: TimeLogEntities, route: RoutePath) {
        self.entities = entities
        self.route = route
    }
}
