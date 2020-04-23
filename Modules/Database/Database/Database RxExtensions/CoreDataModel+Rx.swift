import Foundation
import RxSwift
import CoreData

extension Reactive where Base: CoreDataModel {

    static func get(
        in context: NSManagedObjectContext,
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil
    ) -> Single<[Base]> {

        return Single.create { single in
            context.perform {
                do {
                    let result = try Base.ManagedObject.fetch(in: context) { request in
                        request.predicate = predicate
                        request.sortDescriptors = sortDescriptors
                    }
                    .map(Base.from)
                    single(.success(result))
                } catch {
                    single(.error(error))
                }
            }

            return Disposables.create { }
        }
    }
    
    static func create(
        models: [Base],
        in context: NSManagedObjectContext
    ) -> Single<Void> {

        return Single.create { single in
            context.perform {
                do {
                    for model in models {
                        let managedObject = Base.ManagedObject.insert(into: context)
                        try model.encode(into: managedObject, context: context)
                    }

                    try context.save()
                    single(.success(()))
                } catch {
                    single(.error(error))
                }
            }

            return Disposables.create { }
        }
    }

    static func update(
        update: @escaping (Base) -> Base,
        predicate: NSPredicate,
        in context: NSManagedObjectContext
    ) -> Single<Void> {

        return Single.create { single in
            context.perform {
                do {
                    let managedObjects = try Base.ManagedObject.fetch(in: context) { request in
                        request.predicate = predicate
                    }
                    let entities = try managedObjects.map { try Base.from(managedObject: $0) }
                    let updatedEntities = entities.map(update)

                    for (managedObject, entity) in zip(managedObjects, updatedEntities) {
                        try entity.encode(into: managedObject, context: context)
                    }

                    try context.save()
                    single(.success(()))
                } catch {
                    single(.error(error))
                }
            }

            return Disposables.create { }
        }
    }

    static func delete(
        in context: NSManagedObjectContext,
        predicate: NSPredicate
    ) -> Single<Void> {

        return Single.create { single in
            context.perform {
                do {
                    let managedObjects = try Base.ManagedObject.fetch(in: context) { request in
                        request.predicate = predicate
                    }
                    for managedObject in managedObjects {
                        context.delete(managedObject)
                    }

                    try context.save()

                    single(.success(()))
                } catch {
                    single(.error(error))
                }
            }

            return Disposables.create { }
        }
    }
}
