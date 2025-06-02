//  
import AppBaseFlow
import Foundation
import AppServices

final class SignUpWithEmailViewModel: BaseViewModel<SignUpWithEmailContext.ViewEvent,
                                      SignUpWithEmailContext.ViewState,
                                      SignUpWithEmailContext.OutputEvent> {
    
    private let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
    private let digitRegex = ".*[0-9].*"
    private let uppercaseRegex = ".*[A-Z].*"
    private let specialCharRegex = ".*[!@#$%^&*(),.?\":{}|<>].*"
    
    @Injected(\.authService) private var authService: AuthService
    
    let passwordMinLenght = 5
    
    override init() {
        super.init()
    }
    
    override func onViewEvent(_ event: SignUpWithEmailContext.ViewEvent) {
        switch event {
        case .viewDidLoad:
            viewDidLoad()
        case .signUp(let email, let password):
            signUp(email: email, password: password)
        }
    }
    
    private func viewDidLoad() {
        viewState = .initial
    }
    
    func isEmailValid(_ email: String) -> Bool {
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func isPasswordValid(_ password: String) -> Bool {
        return passwordMinLenght >= 5 &&
              NSPredicate(format: "SELF MATCHES %@", digitRegex).evaluate(with: password) &&
              NSPredicate(format: "SELF MATCHES %@", uppercaseRegex).evaluate(with: password) &&
              NSPredicate(format: "SELF MATCHES %@", specialCharRegex).evaluate(with: password)
    }
    
    func isConfirmPasswordValid(_ password: String, _ confirmPassword: String) -> Bool {
        return password == confirmPassword
    }
    
    func isFormValid(
        _ email: String,
        _ password: String,
        _ confirmPassword: String
    ) -> Bool {
        return isEmailValid(email)
            && isPasswordValid(password)
            && isConfirmPasswordValid(password, confirmPassword)
    }
    
    private func signUp(email: String, password: String) {
        viewState = .loading
        authService.signUp(email: email, password: password)
            .sink { [weak self] result in
                switch result {
                case .success():
                    self?.outputEventSubject.send(.finish)
                case .failure(let error):
                    print("ERROR \(error.localizedDescription)")
                    self?.viewState = .error(.defaultUIError(from: error) ?? .init(alert: .init(message: error.localizedDescription)))
                }
            }
            .store(in: &cancelableSet)
    }
}
