import Foundation
import Models

public protocol EntityDatabaseProtocol {
    associatedtype EntityType: CoreDataModel, Entity
    var stack: CoreDataStack { get }
}
