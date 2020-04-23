import Foundation
import Models

public class EntityDatabase<EntityType: CoreDataModel>: EntityDatabaseProtocol where EntityType: Entity {

    public let stack: CoreDataStack

    init(stack: CoreDataStack) {
        self.stack = stack
    }

    public func getAll() throws -> [EntityType] {
        try EntityType.get(
            in: stack.viewContext
        )
    }

    public func getOne(id: Int64) throws -> EntityType? {
        try EntityType.get(
            in: stack.viewContext,
            predicate: NSPredicate(format: "id = %i", id)
        )
        .first
    }

    public func insert(entities: [EntityType]) throws {
        try EntityType.create(models: entities, in: stack.viewContext)
    }

    public func insert(entity: EntityType) throws {
        try EntityType.create(models: [entity], in: stack.viewContext)
    }

    public func update(entities: [EntityType]) throws {
        try EntityType.update(
            update: { entity in entities.first(where: { $0.id == entity.id })! },
            predicate: NSPredicate(format: "id IN %@", entities.map({ $0.id })),
            in: stack.viewContext
        )
    }

    public func update(entity: EntityType) throws {
        try update(entities: [entity])
    }

    public func delete(id: Int64) throws {
        try EntityType.delete(
            in: stack.viewContext,
            predicate: NSPredicate(format: "id == %i", id)
        )
    }

    public func delete(entity: EntityType) throws {
        try delete(id: entity.id)
    }
}
