import UIKit
import PhotosUI
import Combine
import AppBaseFlow
import AppDesignSystem

final class SignUpAdditionalInfoViewController: BaseViewController<SignUpAdditionalInfoViewModel,
                                                               SignUpAdditionalInfoContext.ViewEvent,
                                                               SignUpAdditionalInfoContext.ViewState,
                                                               SignUpAdditionalInfoContext.ContentView>,
                                              ImagePickerCoordinatorDelegate {
    
    private let imagePickerCoordinator = ImagePickerCoordinator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImagePicker()
        bindViewActions()
        viewModel.onViewEvent(.viewDidLoad)
    }
    
    private func setupImagePicker() {
        imagePickerCoordinator.presentingViewController = self
        imagePickerCoordinator.delegate = self
    }
    
    override func onViewState(_ viewState: SignUpAdditionalInfoContext.ViewState) {
        switch viewState {
        case .initial:
            contentView.doneButton.isLoading = false
        case .loading:
            contentView.doneButton.isLoading = true
        case .error(let error):
            contentView.doneButton.isLoading = false
            showAlert(
                title: error?.alert?.title,
                message: error?.alert?.message ?? "Unexpected",
                actions: [.okAction()]
            )
        }
    }
    
    private func bindViewActions() {
        contentView.firstNameTextField.textDidEndEditingPublisher
            .sink { [weak self] text in
                self?.viewModel.firstName = text
                self?.updateFirstNameValidation(text)
            }
            .store(in: &cancelableSet)
            
        contentView.lastNameTextField.textDidEndEditingPublisher
            .sink { [weak self] text in
                self?.viewModel.lastName = text
            }
            .store(in: &cancelableSet)
            
        contentView.phoneTextField.textPublisher
            .sink { [weak self] text in
                guard let self = self else { return }
                let formattedPhone = self.contentView.formatter.formatPhoneNumber(text)
                self.contentView.phoneTextField.text = formattedPhone
                self.viewModel.phone = formattedPhone
            }
            .store(in: &cancelableSet)
        
        contentView.phoneTextField.textDidEndEditingPublisher
            .sink { [weak self] text in
                self?.updatePhoneValidation(text)
            }
            .store(in: &cancelableSet)
            
        contentView.bioTextField.textDidEndEditingPublisher
            .sink { [weak self] text in
                self?.viewModel.bio = text
            }
            .store(in: &cancelableSet)
            
        contentView.changeAvatarButton.touchUpInsidePublisher
            .sink { [weak self] in
                self?.imagePickerCoordinator.presentImagePicker()
            }
            .store(in: &cancelableSet)
            
        contentView.doneButton.touchUpInsidePublisher
            .sink { [weak self] in
                guard let self = self else { return }
                self.viewModel.onViewEvent(.updateProfile)
            }
            .store(in: &cancelableSet)
            
        // Enable done button only if all required fields are valid
        Publishers.CombineLatest(viewModel.$firstName, viewModel.$phone)
            .map { [weak self] firstName, phone in
                self?.viewModel.validateFirstName(name: firstName) ?? false && self?.viewModel.validatePhone(phone: phone ?? "") ?? false
            }
            .assign(to: \.isEnabled, on: contentView.doneButton)
            .store(in: &cancelableSet)
    }
    
    private func updateFirstNameValidation(_ name: String) {
        let isValid = viewModel.validateFirstName(name: name)
        if isValid == false {
            contentView.firstNameTextField.showError(message: self.contentView.strings.signInInvalidName)
        }
    }
    
    private func updatePhoneValidation(_ phone: String) {
        let isValid = viewModel.validatePhone(phone: phone)
        isValid == false
        ? contentView.phoneTextField.showError(message: contentView.strings.signInInvalidPhone)
        : contentView.phoneTextField.hideError()
    }
    
    // MARK: - ImagePickerCoordinatorDelegate
    func imagePickerCoordinator(_ coordinator: ImagePickerCoordinator, didSelectImage image: UIImage) {
        contentView.changeAvatarButton.setImage(image, for: .normal)
        viewModel.avatar = image
    }
} 
