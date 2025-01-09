//  

import UIKit
import AppBaseFlow

final class SignInViewController: BaseViewController<SignInViewModel,
                                  SignInContext.ViewEvent,
                                  SignInContext.ViewState,
                                  SignInContext.ContentView> {
    override func viewDidLoad() {
        super.viewDidLoad()
        addOnservers()
        setupTextFieldsDelegates()
    }
    
    private func setupTextFieldsDelegates() {
        contentView.emailTextField.delegate = self
        contentView.passwordTextField.delegate = self
    }
    
}

// MARK: Obververs

extension SignInViewController {
    private func addOnservers() {
        observeForm()
    }
    
    private func observeForm() {
        contentView.emailTextField.textDidEndEditingPublisher
            .combineLatest(contentView.passwordTextField.textDidEndEditingPublisher)
            .sink { [weak self] email, password in
                guard let self else { return }
                self.contentView.logInButton.isEnabled = self.viewModel.isFormValid(email, password)
            }
            .store(in: &cancelableSet)
    }
}

extension SignInViewController: UITextFieldDelegate{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}
