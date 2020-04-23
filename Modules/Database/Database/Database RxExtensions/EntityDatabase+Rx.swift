import Foundation
import RxSwift

extension EntityDatabase: ReactiveCompatible { }

extension Reactive where Base: EntityDatabaseProtocol, Base.EntityType: ReactiveCompatible {

    public func getAll() -> Single<[Base.EntityType]> {
        Base.EntityType.rx.get(
            in: base.stack.backgroundContext
        )
    }

    public func getOne(id: Int64) -> Single<Base.EntityType?> {
        Base.EntityType.rx.get(
            in: base.stack.backgroundContext,
            predicate: NSPredicate(format: "id = %i", id)
        )
        .map { $0.first }
    }

    public func insert(entities: [Base.EntityType]) -> Single<Void> {
        Base.EntityType.rx.create(models: entities, in: base.stack.backgroundContext)
    }

    public func insert(entity: Base.EntityType) -> Single<Void> {
        Base.EntityType.rx.create(models: [entity], in: base.stack.backgroundContext)
    }

    public func update(entities: [Base.EntityType]) -> Single<Void> {
        Base.EntityType.rx.update(
            update: { entity in entities.first(where: { $0.id == entity.id })! },
            predicate: NSPredicate(format: "id IN %@", entities.map({ $0.id })),
            in: base.stack.backgroundContext
        )
    }

    public func update(entity: Base.EntityType) -> Single<Void> {
        update(entities: [entity])
    }

    public func delete(id: Int64) -> Single<Void> {
        Base.EntityType.rx.delete(
            in: base.stack.backgroundContext,
            predicate: NSPredicate(format: "id == %i", id)
        )
    }

    public func delete(entity: Base.EntityType) -> Single<Void> {
        delete(id: entity.id)
    }
}
