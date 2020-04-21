import Foundation
import Models
import Utils

public struct ProjectState {
    public var editableProject: EditableProject?
    public var projects = [Int64: Project]()
}
