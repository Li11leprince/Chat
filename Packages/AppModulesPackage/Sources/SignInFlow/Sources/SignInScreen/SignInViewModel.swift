//  

import AppBaseFlow
import AppServices

final class SignInViewModel: BaseViewModel<SignInContext.ViewEvent,
                             SignInContext.ViewState,
                             SignInContext.OutputEvent> {
    
    @Injected(\.authService) private var authService: AuthService
    
    override func onViewEvent(_ event: SignInContext.ViewEvent) {
        switch event {
        case .viewDidLoad:
            break
        case .signInTapped(email: let email, password: let password):
            signInTapped(email: email, password: password)
        }
    }
    
    func isFormValid(_ email: String, _ password: String) -> Bool {
        email.isEmpty == false && password.isEmpty == false
    }
    
    private func signInTapped(email: String, password: String) {
        viewState = .loading
        authService.signIn(email: email, password: password)
            .sink { [weak self] result in
                switch result {
                case .success():
                    self?.outputEventSubject.send(.didSignIn)
                case .failure(let error):
                    break
                }
            }
            .store(in: &cancelableSet)
    }
}
