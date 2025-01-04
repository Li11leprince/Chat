//  
import AppBaseFlow
import Foundation

final class SignUpWithEmailViewModel: BaseViewModel<SignUpWithEmailContext.ViewEvent,
                                      SignUpWithEmailContext.ViewState,
                                      SignUpWithEmailContext.OutputEvent> {
    
    private let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
    private let digitRegex = ".*[0-9].*"
    private let uppercaseRegex = ".*[A-Z].*"
    private let specialCharRegex = ".*[!@#$%^&*(),.?\":{}|<>].*"
    let passwordMinLenght = 5
    
    override init() {
        super.init()
    }
    
    override func onViewEvent(_ event: SignUpWithEmailContext.ViewEvent) {
        switch event {
        case .viewDidLoad:
            break
        }
    }
    
    func isNameValid(_ name: String) -> Bool {
        return name.count >= 3
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
    
    func isFormValid(_ name: String,
                     _ email: String,
                     _ password: String,
                     _ confirmPassword: String
    ) -> Bool {
        return isNameValid(name)
            && isNameValid(email)
            && isPasswordValid(password)
            && isConfirmPasswordValid(password, confirmPassword)
    }
}
