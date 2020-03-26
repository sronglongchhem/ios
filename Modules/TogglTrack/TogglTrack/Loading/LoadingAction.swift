import Foundation
import Models

public enum LoadingAction: Equatable {
    case startLoading
    case loadingFinished
    case workspacesLoaded([Workspace])
    case clientsLoaded([Client])
    case projectsLoaded([Project])
    case tasksLoaded([Task])
    case timeEntriesLoaded([TimeEntry])
    case tagsLoaded([Tag])
}

extension LoadingAction: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {

        case .startLoading:
            return "StartLoading"
        case .loadingFinished:
            return "LoadingFinished"
        case let .workspacesLoaded(workspaces):
            return "WorkspacesLoaded: \(workspaces.count)"
        case let .clientsLoaded(clients):
            return "ClientsLoaded: \(clients.count)"
        case let .projectsLoaded(projects):
            return "ProjectsLoaded: \(projects.count)"
        case let .tasksLoaded(tasks):
            return "TasksLoaded: \(tasks.count)"
        case let .timeEntriesLoaded(timeEntries):
            return "TimeEntriesLoaded: \(timeEntries.count)"
        case let .tagsLoaded(tags):
            return "TagsLoaded: \(tags.count)"
        }
    }
}
