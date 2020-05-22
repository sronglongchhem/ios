import Models

let runningTimeEntry: (TimeLogEntities) -> TimeEntryViewModel? = { state in

    guard let timeEntry = state.timeEntries.values.first(where: { timeEntry -> Bool in
            timeEntry.duration == nil
        })
    else { return nil }

    let project = state.getProject(timeEntry.projectId)

    return TimeEntryViewModel(
        timeEntry: timeEntry,
        project: project,
        client: state.getClient(project?.clientId),
        task: state.getTask(timeEntry.taskId),
        tags: timeEntry.tagIds.compactMap(state.getTag)
    )
}

let runningTimeEntryViewModelSelector: (RunningTimeEntryState) -> TimeEntryViewModel? = { state in runningTimeEntry(state.entities) }
