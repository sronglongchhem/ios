import Foundation
import Architecture
import Models
import RxSwift
import Repository
import OtherServices

// swiftlint:disable cyclomatic_complexity
func createRunningTimeEntryReducer(repository: TimeLogRepository, time: Time) -> Reducer<RunningTimeEntryState, RunningTimeEntryAction> {
    return Reducer { state, action in
        switch action {
        case .stopButtonTapped:
            guard var runningTimeEntry = state.runningTimeEntry else { return [] }
            runningTimeEntry.duration = time.now().timeIntervalSince(runningTimeEntry.start)
            state.entities.timeEntries[runningTimeEntry.id] = runningTimeEntry
            return stopTimeEntryEffect(state.entities.timeEntries[runningTimeEntry.id]!, repository: repository)

        case .startButtonTapped:
            guard state.runningTimeEntry == nil, let workspaceId = state.user.value?.defaultWorkspace else { return [] }
            let timeEntryDto = StartTimeEntryDto.empty(workspaceId: workspaceId)
            return [startTimeEntryEffect(timeEntryDto, repository: repository)]

        case .timeEntryStarted(started: let started, stopped: let stopped):
            state.entities.timeEntries[started.id] = started
            if let stoppedTimeEntry = stopped {
                state.entities.timeEntries[stoppedTimeEntry.id] = stoppedTimeEntry
            }
            return []

        case let .setError(error):
            fatalError(error.description)

        case .cardTapped:
            return []
        }
    }
}

func stopTimeEntryEffect(_ timeEntry: TimeEntry, repository: TimeLogRepository) -> [Effect<RunningTimeEntryAction>] {
    return []
}

func startTimeEntryEffect(_ timeEntry: StartTimeEntryDto, repository: TimeLogRepository) -> Effect<RunningTimeEntryAction> {
    return repository
        .startTimeEntry(timeEntry)
        .toEffect(map: RunningTimeEntryAction.timeEntryStarted,
                  catch: { error in RunningTimeEntryAction.setError(error.toErrorType()) })
}
