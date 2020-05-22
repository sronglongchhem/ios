import Foundation
import Models
import Utils

public struct StartEditState: Equatable {
    var entities: TimeLogEntities
    var editableTimeEntry: EditableTimeEntry?
    var autocompleteSuggestions: [AutocompleteSuggestion]
    var dateTimePickMode: DateTimePickMode
    var cursorPosition: Int
}
