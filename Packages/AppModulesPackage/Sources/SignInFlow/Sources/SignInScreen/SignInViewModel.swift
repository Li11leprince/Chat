//  

import AppBaseFlow

final class SignInViewModel: BaseViewModel<SignInContext.ViewEvent,
                             SignInContext.ViewState,
                             SignInContext.OutputEvent> {
    
    func isFormValid(_ email: String, _ password: String) -> Bool {
        email.isEmpty == false && password.isEmpty == false
    }
}
