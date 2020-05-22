import Foundation
import Models
import Utils

public struct StartEditState: Equatable {
    var entities: TimeLogEntities
    var editableTimeEntry: EditableTimeEntry

    internal var autocompleteSuggestions: [AutocompleteSuggestion] = []
    internal var dateTimePickMode: DateTimePickMode = .none
    internal var cursorPosition: Int = 0}
