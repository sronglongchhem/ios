import Foundation
import RxSwift
import Architecture
import Repository
import Models

func createLoadingReducer(repository: Repository) -> Reducer<LoadingState, LoadingAction> {
    return Reducer { state, action in
        switch action {
            
        case .startLoading:
            return loadEntities(repository)
            
        case .loadingFinished:
            state.route = AppRoute.main.path
            return []
            
        case let .workspacesLoaded(workspaces):
            state.entities.workspaces = arrayToDict(entities: workspaces)
            return []
            
        case let .clientsLoaded(clients):
            state.entities.clients = arrayToDict(entities: clients)
            return []
            
        case let .projectsLoaded(projects):
            state.entities.projects = arrayToDict(entities: projects)
            return []
            
        case let .tasksLoaded(tasks):
            state.entities.tasks = arrayToDict(entities: tasks)
            return []
            
        case let .timeEntriesLoaded(timeEntries):
            state.entities.timeEntries = arrayToDict(entities: timeEntries)
            return []
            
        case let .tagsLoaded(tags):
            state.entities.tags = arrayToDict(entities: tags)
            return []

        }
    }
}

private func loadEntities(_ repository: Repository) -> [Effect<LoadingAction>] {
    return [
        repository.getWorkspaces().map(LoadingAction.workspacesLoaded),
        repository.getClients().map(LoadingAction.clientsLoaded),
        repository.getTimeEntries().map(LoadingAction.timeEntriesLoaded),
        repository.getProjects().map(LoadingAction.projectsLoaded),
        repository.getTasks().map(LoadingAction.tasksLoaded),
        repository.getTags().map(LoadingAction.tagsLoaded),
        Single.just(LoadingAction.loadingFinished)
    ]
        .map { $0.toEffect() }
}

private func arrayToDict<EntityType: Entity>(entities: [EntityType]) -> [Int: EntityType] {
    return entities.reduce([:], { acc, entity in
        var acc = acc
        acc[entity.id] = entity
        return acc
    })
}
