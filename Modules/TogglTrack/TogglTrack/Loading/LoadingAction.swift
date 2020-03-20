import Foundation
import Models

public enum LoadingAction: Equatable {
    case startLoading
    case loadingFinished
    case setWorkspaces([Workspace])
    case setClients([Client])
    case setProjects([Project])
    case setTasks([Task])
    case setTimeEntries([TimeEntry])
    case setTags([Tag])
}

extension LoadingAction: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {

        case .startLoading:
            return "StartLoading"
        case .loadingFinished:
            return "LoadingFinished"
        case let .setWorkspaces(workspaces):
            return "SetWorkspaces: \(workspaces.count)"
        case let .setClients(clients):
            return "SetClients: \(clients.count)"
        case let .setProjects(projects):
            return "SetProjects: \(projects.count)"
        case let .setTasks(tasks):
            return "SetTasks: \(tasks.count)"
        case let .setTimeEntries(timeEntries):
            return "SetTimeEntries: \(timeEntries.count)"
        case let .setTags(tags):
            return "SetTags: \(tags.count)"
        }
    }
}
