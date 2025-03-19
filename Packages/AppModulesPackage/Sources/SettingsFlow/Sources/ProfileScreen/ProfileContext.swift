
import Foundation
import AppBaseFlow

struct ProfileContext {
    private init() {}
}

// MARK: ViewState

extension ProfileContext {
    enum ViewState: Stubable {
        case initial
        case editing
        static var stub: ViewState = .initial
    }
}

// MARK: ViewEvent

extension ProfileContext {
    enum ViewEvent {
        case viewDidLoad
        case startEditing
        case cancelButtonPressed
    }
}

// MARK: OutputEvent

extension ProfileContext {
    enum OutputEvent {
        case finish
    }
}
