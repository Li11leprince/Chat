
import Foundation
import AppBaseFlow

struct ProfileContext {
    private init() {}
}

// MARK: ViewState

extension ProfileContext {
    enum ViewState: Stubable {
        case initial(UserDataModel)
        case editing(UserDataModel)
        case saved(UserDataModel)
        static var stub: ViewState = .initial(UserDataModel.mock)
    }
}

// MARK: ViewEvent

extension ProfileContext {
    enum ViewEvent {
        case viewDidLoad
        case startEditing
        case cancelButtonPressed
        case saveButtonPressed
    }
}

// MARK: OutputEvent

extension ProfileContext {
    enum OutputEvent {
        case finish
    }
}
