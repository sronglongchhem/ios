import Foundation
import Models
import Architecture

public struct LocalLoadingState: Equatable {
    internal var loading: Bool = false
    
    public init() {
    }
}

public struct LoadingState: Equatable {
    public var entities: TimeLogEntities
    public var route: RoutePath
    public var localLoadingState: LocalLoadingState
    
    public init(entities: TimeLogEntities, route: RoutePath, localLoadingState: LocalLoadingState) {
        self.entities = entities
        self.route = route
        self.localLoadingState = localLoadingState
    }
}

extension LoadingState {
    var loading: Bool {
        get {
            return localLoadingState.loading
        }
        set {
            localLoadingState.loading = newValue
        }
    }
}
