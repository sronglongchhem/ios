import Models

let shouldShowEditView: (StartEditState) -> Bool = { state in
    return state.editableTimeEntry != nil
}
