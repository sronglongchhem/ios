import Foundation
import Models

let timeEntryViewModelsSelector: (TimeLogEntities) -> [TimeEntryViewModel] = { entities in
    
    return entities.timeEntries.values
        .compactMap({ timeEntry in
            guard let workspace = entities.getWorkspace(timeEntry.workspaceId) else {
                //fatalError("Workspace missing")
                return nil
            }
            
            let project = entities.getProject(timeEntry.projectId)
            
            return TimeEntryViewModel(
                timeEntry: timeEntry,
                workspace: workspace,
                project: project,
                client: entities.getClient(project?.clientId),
                task: entities.getTask(timeEntry.taskId),
                tags: timeEntry.tagIds?.compactMap(entities.getTag)
            )
        })
}
