import Foundation
import AppBaseFlow

final class ProfileViewModel: BaseViewModel<ProfileContext.ViewEvent,
                            ProfileContext.ViewState,
                            ProfileContext.OutputEvent> {
    
    var isEditing: Bool = false
    
    override func onViewEvent(_ event: ProfileContext.ViewEvent) {
        switch event {
        case .viewDidLoad:
            break
        case .startEditing:
            viewState = .editing
            isEditing = true
        case .cancelButtonPressed:
            outputEventSubject.send(.finish)
        }
    }
}
