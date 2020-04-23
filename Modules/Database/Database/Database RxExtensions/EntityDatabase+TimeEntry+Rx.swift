import Foundation
import Models
import RxSwift

extension Reactive where Base: EntityDatabaseProtocol, Base.EntityType == TimeEntry {

    public func getAllSortedBackground() -> Single<[TimeEntry]> {
        TimeEntry.rx.get(
            in: base.stack.backgroundContext,
            sortDescriptors: [NSSortDescriptor(key: "start", ascending: false)]
        )
    }

    public func getAllRunningBackground() -> Single<[TimeEntry]> {
        TimeEntry.rx.get(
            in: base.stack.backgroundContext,
            predicate: NSPredicate(format: "duration == nil"),
            sortDescriptors: [NSSortDescriptor(key: "start", ascending: false)]
        )
    }
}
