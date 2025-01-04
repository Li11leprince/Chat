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
    }
    override func onViewState(_ viewState: SignUpWithEmailContext.ViewState) {
        switch viewState {
        case .initial:
            break
        }
    }
    
    private func bindViewActions() {
        contentView.showPasswordButton.touchUpInsidePublisher
            .sink { [weak self] in
                self?.contentView.passwordTextField.isSecureTextEntry.toggle()
                self?.contentView.confirmPasswordTextField.isSecureTextEntry.toggle()
            }
            .store(in: &cancelableSet)
    }
}

//MARK: Observers
extension SignUpWithEmailViewController {
    private func addObservers() {
        observeNameTextDidEndEditing()
        observeEmailTextDidEndEditing()
        observePasswordTextDidEndEditing()
        observeConfirmPasswordTextDidEndEditing()
        observeForm()
    }
    
    private func observeNameTextDidEndEditing() {
        contentView.nameTextField.textDidEndEditingPublisher
            .sink { [weak self] name in
                guard let self else { return }
                self.viewModel.isNameValid(name)
                    ? self.contentView.nameTextField.hideError()
                    : self.contentView.nameTextField.showError(message: self.contentView.strings.signInInvalidName)
            }
            .store(in: &cancelableSet)
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
        contentView.nameTextField.textDidEndEditingPublisher
            .combineLatest(
                contentView.emailTextField.textDidEndEditingPublisher,
                contentView.passwordTextField.textDidEndEditingPublisher,
                contentView.confirmPasswordTextField.textDidEndEditingPublisher
            )
            .sink { [weak self] form in
                guard let self else { return }
                self.contentView.signUpButton.isEnabled = self.viewModel.isFormValid(form.0, form.1, form.2, form.3)
            }
            .store(in: &cancelableSet)
    }
}
