import Foundation
import RxSwift

public class SchedulerProvider {
    public let mainScheduler: SchedulerType
    public let backgroundScheduler: SchedulerType

    public init(
        mainScheduler: SchedulerType = MainScheduler.instance,
        backgroundScheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)
    ) {
        self.mainScheduler = mainScheduler
        self.backgroundScheduler = backgroundScheduler
    }
}
