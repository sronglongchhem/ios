import Foundation
import Repository
import Models
import RxSwift

class MockTimeLogRepository: TimeLogRepository {
    
    var stoppedTimeEntry: TimeEntry?
    var newTimeEntryId: Int = 999
    
    var workspaces = [Workspace]()
    var clients = [Client]()
    var timeEntries = [TimeEntry]()
    var projects = [Project]()
    var tasks = [Task]()
    var tags = [Tag]()
    
    init() {}
    
    func getWorkspaces() -> Single<[Workspace]> {
        return Single.just(workspaces)
    }
    
    func getClients() -> Single<[Client]> {
        return Single.just(clients)
    }
    
    func getTimeEntries() -> Single<[TimeEntry]> {
        return Single.just(timeEntries)
    }
    
    func getProjects() -> Single<[Project]> {
        return Single.just(projects)
    }
    
    func getTasks() -> Single<[Task]> {
        return Single.just(tasks)
    }
    
    func getTags() -> Single<[Tag]> {
        return Single.just(tags)
    }
    
    func startTimeEntry(timeEntry: TimeEntry) -> Single<(started: TimeEntry, stopped: TimeEntry?)> {
        var newTimeEntry = timeEntry
        newTimeEntry.id = newTimeEntryId
        return Single.just((newTimeEntry, stoppedTimeEntry))
    }
    
    func deleteTimeEntry(timeEntryId: Int) -> Single<Void> {
        return Single.just(())
    }
}
