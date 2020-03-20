import Foundation
import RxSwift
import Architecture
import Repository
import Models

func createLoadingReducer(repository: Repository) -> Reducer<LoadingState, LoadingAction> {
    return Reducer { state, action in
        switch action {
            
        case .startLoading:
            state.loading = true
            return loadEntities(repository)
            
        case .loadingFinished:
            state.loading = false
            state.route = AppRoute.main.path
            return []
            
        case let .setWorkspaces(workspaces):
            state.entities.workspaces = arrayToDict(entities: workspaces)
            return []
            
        case let .setClients(clients):
            state.entities.clients = arrayToDict(entities: clients)
            return []
            
        case let .setProjects(projects):
            state.entities.projects = arrayToDict(entities: projects)
            return []
            
        case let .setTasks(tasks):
            state.entities.tasks = arrayToDict(entities: tasks)
            return []
            
        case let .setTimeEntries(timeEntries):
            state.entities.timeEntries = arrayToDict(entities: timeEntries)
            return []
            
        case let .setTags(tags):
            state.entities.tags = arrayToDict(entities: tags)
            return []

        }
    }
}

private func loadEntities(_ repository: Repository) -> [Effect<LoadingAction>] {
    return [
        repository.getWorkspaces().map(LoadingAction.setWorkspaces),
        repository.getClients().map(LoadingAction.setClients),
        repository.getTimeEntries().map(LoadingAction.setTimeEntries),
        repository.getProjects().map(LoadingAction.setProjects),
        repository.getTasks().map(LoadingAction.setTasks),
        repository.getTags().map(LoadingAction.setTags),
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
