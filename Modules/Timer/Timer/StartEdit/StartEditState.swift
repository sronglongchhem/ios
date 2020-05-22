import Foundation
import Models
import Utils

public struct StartEditState: Equatable {
    var user: Loadable<User>
    var entities: TimeLogEntities
    var editableTimeEntry: EditableTimeEntry?
    var autocompleteSuggestions: [AutocompleteSuggestion]
    var dateTimePickMode: DateTimePickMode
    var cursorPosition: Int
}
