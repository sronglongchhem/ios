import Models

let runningTimeEntryViewModelSelector: (RunningTimeEntryState) -> TimeEntryViewModel? = { state in

    guard let timeEntry = state.entities.timeEntries.values.first(where: { timeEntry -> Bool in
            timeEntry.duration == nil
        })
    else { return nil }

    let project = state.entities.getProject(timeEntry.projectId)

    return TimeEntryViewModel(
        timeEntry: timeEntry,
        project: project,
        client: state.entities.getClient(project?.clientId),
        task: state.entities.getTask(timeEntry.taskId),
        tags: timeEntry.tagIds.compactMap(state.entities.getTag)
    )
}
