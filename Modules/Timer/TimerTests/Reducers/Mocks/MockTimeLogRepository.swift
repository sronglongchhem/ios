import Foundation
import Repository
import Models
import RxSwift
import OtherServices

class MockTimeLogRepository: TimeLogRepository {
    private let time: Time
    
    var stoppedTimeEntry: TimeEntry?
    var newTimeEntryId: Int64 = 999
    var newProjectId: Int64 = 9999
    
    var workspaces = [Workspace]()
    var clients = [Client]()
    var timeEntries = [TimeEntry]()
    var projects = [Project]()
    var tasks = [Task]()
    var tags = [Tag]()
    
    init(time: Time) {
        self.time = time
    }
    
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
    
    func startTimeEntry(_ timeEntry: StartTimeEntryDto) -> Single<(started: TimeEntry, stopped: TimeEntry?)> {
        let startedTimeEntry = TimeEntry(
            id: newTimeEntryId,
            description: timeEntry.description,
            start: time.now(),
            duration: nil,
            billable: false,
            workspaceId: timeEntry.workspaceId,
            tagIds: [])
        return Single.just((startedTimeEntry, stoppedTimeEntry))
    }

    func updateTimeEntry(_ timeEntry: TimeEntry) -> Single<Void> {
        return Single.just(())
    }

    func deleteTimeEntry(timeEntryId: Int64) -> Single<Void> {
        return Single.just(())
    }

    func createProject(_ dto: CreateProjectDto) -> Single<Project> {
        let project = Project(id: newProjectId,
                              name: dto.name,
                              isPrivate: dto.isPrivate,
                              isActive: dto.isActive,
                              color: dto.color,
                              billable: dto.billable,
                              workspaceId: dto.workspaceId,
                              clientId: dto.clientId)
        return Single.just(project)
    }
}
