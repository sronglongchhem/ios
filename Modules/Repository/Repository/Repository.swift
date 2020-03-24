import Foundation
import RxSwift
import Models
import API

public protocol TimeLogRepository {
    func getWorkspaces() -> Single<[Workspace]>
    func getClients() -> Single<[Client]>
    func getTimeEntries() -> Single<[TimeEntry]>
    func getProjects() -> Single<[Project]>
    func getTasks() -> Single<[Task]>
    func getTags() -> Single<[Tag]>
    func startTimeEntry(timeEntry: TimeEntry) -> Single<(started: TimeEntry, stopped: TimeEntry?)>
    func deleteTimeEntry(timeEntryId: Int) -> Single<Void>
}

public class Repository {
    // These mock the DB
    private var workspaces = [Workspace]()
    private var clients = [Client]()
    private var timeEntries = [TimeEntry]()
    private var projects = [Project]()
    private var tasks = [Task]()
    private var tags = [Tag]()
    // ------------------------
    
    private let api: TimelineAPI
    
    public init(api: TimelineAPI) {
        self.api = api
    }
}

extension Repository: TimeLogRepository {
        
    public func getWorkspaces() -> Single<[Workspace]> {
        if workspaces.isEmpty {
            return api.loadWorkspaces()
                .do(onSuccess: { self.workspaces = $0 })
        }
        
        return Single.just(workspaces)
    }

    public func getClients() -> Single<[Client]> {
        if clients.isEmpty {
            return api.loadClients()
                .do(onSuccess: { self.clients = $0 })
        }
        
        return Single.just(clients)
    }
    
    public func getTimeEntries() -> Single<[TimeEntry]> {
        if timeEntries.isEmpty {
            return api.loadEntries()
                .do(onSuccess: { self.timeEntries = $0 })
        }
        
        return Single.just(timeEntries)
    }
    
    public func getProjects() -> Single<[Project]> {
        if projects.isEmpty {
            return api.loadProjects()
                .do(onSuccess: { self.projects = $0 })
        }
        
        return Single.just(projects)
    }
    
    public func getTasks() -> Single<[Task]> {
        if tasks.isEmpty {
            return api.loadTasks()
                .do(onSuccess: { self.tasks = $0 })
        }
        
        return Single.just(tasks)
    }
    
    public func getTags() -> Single<[Tag]> {
        if tags.isEmpty {
            return api.loadTags()
                .do(onSuccess: { self.tags = $0 })
        }
        
        return Single.just(tags)
    }
    
    public func startTimeEntry(timeEntry: TimeEntry) -> Single<(started: TimeEntry, stopped: TimeEntry?)> {
        
        var stoppedTimeEntry: TimeEntry?
        if let runningEntryIndex = timeEntries.firstIndex(where: { $0.duration == 0}) {
            stoppedTimeEntry = timeEntries[runningEntryIndex]
            stoppedTimeEntry!.duration = timeEntry.start.timeIntervalSince(stoppedTimeEntry!.start)
            timeEntries[runningEntryIndex] = stoppedTimeEntry!
        }
        
        var newTimeEntry = timeEntry
        newTimeEntry.id = (timeEntries.map({ $0.id }).max() ?? 0) + 1
        timeEntries.append(timeEntry)
        
        return Single.just((started: newTimeEntry, stopped: stoppedTimeEntry))
    }
    
    public func deleteTimeEntry(timeEntryId: Int) -> Single<Void> {
        timeEntries = timeEntries.filter { $0.id != timeEntryId }
        return Single.just(())
    }
}
