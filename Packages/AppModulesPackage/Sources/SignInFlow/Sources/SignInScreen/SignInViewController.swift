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
        bindActions()
    }
    
    override func onViewState(_ viewState: SignInContext.ViewState) {
        switch viewState {
        case .initial:
            break
        case .loading:
            contentView.logInButton.isLoading = true
        case .loaded:
            contentView.logInButton.isLoading = false
        case .error(let error):
            contentView.components.showErrorSnackBar(in: view, message: contentView.strings.commonAuthErrorTitle, location: .top)
        }
    }
    
    private func setupTextFieldsDelegates() {
        contentView.emailTextField.delegate = self
        contentView.passwordTextField.delegate = self
    }
    
    private func bindActions() {
        contentView.logInButton.touchUpInsidePublisher
            .sink { [weak self] in
                guard let self,
                      let email = self.contentView.emailTextField.text,
                      let password = self.contentView.passwordTextField.text else {
                    return
                }
                self.viewModel.onViewEvent(.signInTapped(email: email, password: password))
            }
            .store(in: &cancelableSet)

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
        
        contentView.logInButton.touchUpInsidePublisher
            .sink { [weak self] in
                guard let self,
                      let email = self.contentView.emailTextField.text,
                      let password = self.contentView.passwordTextField.text else {
                    return
                }
                self.viewModel.onViewEvent(.signInTapped(email: email, password: password))
            }
    }
}

extension SignInViewController: UITextFieldDelegate{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}
