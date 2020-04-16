import Foundation
import Architecture
import Models
import RxSwift
import Repository
import OtherServices

func createRunningTimeEntryReducer(repository: TimeLogRepository, time: Time) -> Reducer<RunningTimeEntryState, RunningTimeEntryAction> {
    return Reducer { _, _ in
        return []
    }
}
