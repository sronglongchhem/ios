import Foundation
import RxSwift
import Models
import API
import OtherServices
import Database

public protocol TimeLogRepository {
    func getWorkspaces() -> Single<[Workspace]>
    func getClients() -> Single<[Client]>
    func getTimeEntries() -> Single<[TimeEntry]>
    func getProjects() -> Single<[Project]>
    func getTasks() -> Single<[Task]>
    func getTags() -> Single<[Tag]>
    func startTimeEntry(_ timeEntry: StartTimeEntryDto) -> Single<(started: TimeEntry, stopped: TimeEntry?)>
    func deleteTimeEntry(timeEntryId: Int64) -> Single<Void>
}

public class Repository {
    // These mock the DB
    private var workspaces = [Workspace]()
    private var clients = [Client]()
    private var projects = [Project]()
    private var tasks = [Task]()
    private var tags = [Tag]()
    // ------------------------
    
    private let time: Time
    private let api: TimelineAPI
    private let database: Database
  
    public init(api: TimelineAPI, database: Database, time: Time) {
        self.api = api
        self.time = time
        self.database = database
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
        do {
            let timeEntries = try database.timeEntries.getAll()
            return Single.just(timeEntries.map({ $0.toTimeEntry() }))
        } catch let error {
            return Single.error(error)
        }
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

    public func startTimeEntry(_ timeEntry: StartTimeEntryDto) -> Single<(started: TimeEntry, stopped: TimeEntry?)> {
        do {
            let timeEntries = try database.timeEntries.getAllRunning()
            
            var stoppedTimeEntry: TimeEntry?
            if var runningEntryDAO = timeEntries.first {
                runningEntryDAO.duration = NSNumber.fromDouble(time.now().timeIntervalSince(runningEntryDAO.start))
                try database.timeEntries.update(timeEntry: runningEntryDAO)
                stoppedTimeEntry = runningEntryDAO.toTimeEntry()
            }
            
            let newTimeEntry = TimeEntry(
                id: (timeEntries.map({ $0.id }).max() ?? 0) + 1,
                description: timeEntry.description,
                start: time.now(),
                duration: nil,
                billable: false,
                workspaceId: timeEntry.workspaceId)
            _ = try database.timeEntries.insert(timeEntry: newTimeEntry.toDAO())
            return Single.just((started: newTimeEntry, stopped: stoppedTimeEntry))
        } catch let error {
            return Single.error(error)
        }
    }
    
    public func deleteTimeEntry(timeEntryId: Int64) -> Single<Void> {
        do {
            try database.timeEntries.delete(id: Int64(timeEntryId))
            return Single.just(())
        } catch let error {
            return Single.error(error)
        }
    }
}
