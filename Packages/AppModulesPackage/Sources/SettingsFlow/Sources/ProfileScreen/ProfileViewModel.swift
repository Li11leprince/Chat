import Foundation
import AppBaseFlow

final class ProfileViewModel: BaseViewModel<ProfileContext.ViewEvent,
                            ProfileContext.ViewState,
                            ProfileContext.OutputEvent> {
    
    var isEditing: Bool = false
    
    private lazy var userDataModel: UserDataModel = {
        UserDataModel.mock
    }()
    
    override func onViewEvent(_ event: ProfileContext.ViewEvent) {
        switch event {
        case .viewDidLoad:
            viewDidLoad()
        case .startEditing:
            startEditing()
        case .cancelButtonPressed:
            outputEventSubject.send(.finish)
        case .saveButtonPressed:
            saveButtonPressed()
        }
    }
    
    func saveItem(model: UserDataItem) {
        switch model.type {
        case .firstName:
            userDataModel.firstName = model.value
        case .lastName:
            userDataModel.lastName = model.value
        case .phone:
            userDataModel.phoneNumber = model.value
        case .username:
            userDataModel.userName = model.value
        case .avatar:
            userDataModel.avatarImage = model.image
        case .birthday:
            userDataModel.birthday = model.value
        case .bio:
            userDataModel.bio = model.value
        }
    }
    
    private func viewDidLoad() {
        viewState = .initial(userDataModel)
    }
    
    private func startEditing() {
        viewState = .editing(userDataModel)
        isEditing = true
    }
    
    private func saveButtonPressed() {
        viewState = .saved(userDataModel)
    }
}
