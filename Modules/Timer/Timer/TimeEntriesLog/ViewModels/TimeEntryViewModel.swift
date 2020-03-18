import UIKit
import Models
import Utils

public struct TimeEntryViewModel: Equatable {
    
    public static func == (lhs: TimeEntryViewModel, rhs: TimeEntryViewModel) -> Bool {
        return lhs.description == rhs.description && lhs.projectTaskClient == rhs.projectTaskClient && lhs.billable == rhs.billable
            && lhs.start == rhs.start && lhs.duration == rhs.duration
            && lhs.end == rhs.end && lhs.isRunning == rhs.isRunning //&& lhs.tags == rhs.tags
    }
    
    public var id: Int
    public var description: String
    public var projectTaskClient: String
    public var billable: Bool
    
    public var start: Date
    public var duration: TimeInterval?
    public var durationString: String?
    public var end: Date?
    public var isRunning: Bool
    
    public var descriptionColor: UIColor
    public var projectColor: UIColor
    
    public let workspace: Workspace
    public let tags: [Tag]?
    
    public init(
        timeEntry: TimeEntry,
        workspace: Workspace,
        project: Project? = nil,
        client: Client? = nil,
        task: Task? = nil,
        tags: [Tag]? = nil) {
                
        self.id = timeEntry.id
        self.description = timeEntry.description.isEmpty ? "No description" : timeEntry.description
        self.projectTaskClient = getProjectTaskClient(from: project, task: task, client: client)
        self.billable = timeEntry.billable
                
        self.start = timeEntry.start
        self.duration = timeEntry.duration >= 0 ? timeEntry.duration : nil
        if let duration = duration {
            self.durationString = duration.formatted
            self.end = timeEntry.start.addingTimeInterval(duration)
        }
        isRunning = duration == nil
        
        descriptionColor = timeEntry.description.isEmpty ? .lightGray : .darkGray
        projectColor = project == nil ? .white : UIColor(hex: project!.color)
        
        self.workspace = workspace
        self.tags = tags
    }
}

func getProjectTaskClient(from project: Project?, task: Task?, client: Client?) -> String {
    var value = ""
    if let project = project { value.append(project.name) }
    if let task = task { value.append(": " + task.name) }
    if let client = client { value.append(" · " + client.name) }
    return value
}

extension TimeInterval {
    var formatted: String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        guard let result = formatter.string(from: self) else { return "00:00:00" }
        return result
    }
}
