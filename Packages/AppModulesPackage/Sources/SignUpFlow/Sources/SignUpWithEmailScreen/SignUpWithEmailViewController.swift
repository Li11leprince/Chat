//  

import UIKit
import AppBaseFlow
import Combine

final class SignUpWithEmailViewController: BaseViewController<SignUpWithEmailViewModel,
                                           SignUpWithEmailContext.ViewEvent,
                                           SignUpWithEmailContext.ViewState,
                                           SignUpWithEmailContext.ContentView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
        bindViewActions()
        showGrabber()
        setupTextFieldsDelegates()
    }
    
    override func onViewState(_ viewState: SignUpWithEmailContext.ViewState) {
        switch viewState {
        case .initial:
            break
        case .loading:
            contentView.signUpButton.isLoading = true
        case .error(let error):
            contentView.signUpButton.isLoading = false
            showAlert(
                title: error.alert?.title,
                message: error.alert?.message ?? "Unexpected",
                actions: [.okAction()]
            )
        }
    }
    
    private func bindViewActions() {
        contentView.showPasswordButton.touchUpInsidePublisher
            .sink { [weak self] in
                self?.contentView.passwordTextField.isSecureTextEntry.toggle()
                self?.contentView.confirmPasswordTextField.isSecureTextEntry.toggle()
            }
            .store(in: &cancelableSet)
        contentView.signUpButton.touchUpInsidePublisher
            .sink { [weak self] in
                guard let self,
                      let email = self.contentView.emailTextField.text,
                      let password = self.contentView.passwordTextField.text else {
                    return
                }
                self.viewModel.onViewEvent(
                    .signUp(
                        email: email,
                        password: password
                    )
                )
            }
            .store(in: &cancelableSet)
    }
    
    private func showGrabber() {
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.prefersGrabberVisible = true
        }
    }
    
    private func setupTextFieldsDelegates() {
        contentView.confirmPasswordTextField.delegate = self
        contentView.emailTextField.delegate = self
        contentView.nameTextField.delegate = self
        contentView.passwordTextField.delegate = self
    }
}

//MARK: Observers
extension SignUpWithEmailViewController {
    private func addObservers() {
        observeEmailTextDidEndEditing()
        observePasswordTextDidEndEditing()
        observeConfirmPasswordTextDidEndEditing()
        observeForm()
    }
    
    private func observeEmailTextDidEndEditing() {
        contentView.emailTextField.textDidEndEditingPublisher
            .sink { [weak self] email in
                guard let self else { return }
                self.viewModel.isEmailValid(email)
                    ? self.contentView.emailTextField.hideError()
                    : self.contentView.emailTextField.showError(message: self.contentView.strings.signInInvalidEmail)
            }
            .store(in: &cancelableSet)
    }
    
    private func observePasswordTextDidEndEditing() {
        contentView.passwordTextField.textDidEndEditingPublisher
            .sink { [weak self] password in
                guard let self else { return }
                self.viewModel.isPasswordValid(password)
                    ? self.contentView.passwordTextField.hideError()
                    : self.contentView.passwordTextField.showError(
                        message: self.contentView.strings.signInInvalidPassword(
                            minLength: String(viewModel.passwordMinLenght)
                        )
                    )
            }
            .store(in: &cancelableSet)
    }
    
    private func observeConfirmPasswordTextDidEndEditing() {
        contentView.confirmPasswordTextField.textDidEndEditingPublisher
            .combineLatest(contentView.passwordTextField.textDidEndEditingPublisher)
            .sink { [weak self] passwords in
                guard let self else { return }
                self.viewModel.isConfirmPasswordValid(passwords.1, passwords.0)
                ? self.contentView.confirmPasswordTextField.hideError()
                : self.contentView.confirmPasswordTextField.showError(
                    message: self.contentView.strings.signInInvalidConfirmPassword
                )
            }
            .store(in: &cancelableSet)
    }
    
    private func observeForm() {
        contentView.emailTextField.textDidEndEditingPublisher
            .combineLatest(
                contentView.passwordTextField.textDidEndEditingPublisher,
                contentView.confirmPasswordTextField.textDidEndEditingPublisher
            )
            .sink { [weak self] form in
                guard let self else { return }
                self.contentView.signUpButton.isEnabled = self.viewModel.isFormValid(form.0, form.1, form.2)
            }
            .store(in: &cancelableSet)
    }
}

extension SignUpWithEmailViewController: UITextFieldDelegate{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}
