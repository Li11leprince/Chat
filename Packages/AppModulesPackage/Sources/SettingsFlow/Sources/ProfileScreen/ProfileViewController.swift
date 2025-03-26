import UIKit
import PhotosUI
import AppBaseFlow
import TOCropViewController

final class ProfileViewController: BaseViewController<ProfileViewModel,
                                                    ProfileContext.ViewEvent,
                                                    ProfileContext.ViewState,
                                                    ProfileContext.ContentView> {
    
    var dataSource: UITableViewDiffableDataSource<Section, Item>?
    
    private var tableView: UITableView { contentView.tableView }
    private var navBarContainerView: UIView!
    private var pickerViewController: PHPickerViewController?
    private var chosenPhotoId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindActions()
        navigationItem.rightBarButtonItem = .init(customView: contentView.editButton)
        tableView.delegate = self
        registerCells(in: tableView)
        setDataSource(in: tableView)
        viewModel.onViewEvent(.viewDidLoad)
    }

    override func onViewState(_ viewState: ProfileContext.ViewState) {
        switch viewState {
        case .initial(let model):
            initial(model: model)
        case .editing(let model):
            editingState(model: model)
        case .saved(let model):
            savedState(model: model)
        }
    }
    
    func initial(model: UserDataModel) {
        contentView.avatarWithName.setName(firstName: model.firstName, lastName: model.lastName)
        contentView.avatarWithName.setImage(model.avatarImage ?? contentView.icons.mockAvatar)
        applyInitialSnaphot(model: model)
    }
    
    func editingState(model: UserDataModel) {
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = .init(customView: contentView.saveButton)
        navigationItem.leftBarButtonItem = .init(customView: contentView.cancelButton)
        UIView.animate(withDuration: 0.2) {
            self.contentView.cancelButton.alpha = 1.0
            self.contentView.saveButton.alpha = 1.0
            self.contentView.changeAvatarButton.alpha = 1.0
        }
        tableView.tableHeaderView?.frame.size.height = 135
        contentView.avatarWithName.hideLabels()
        tableView.isUserInteractionEnabled = true
        showEditState(model: model)
    }
    
    func savedState(model: UserDataModel) {
        navigationItem.hidesBackButton = false
        navigationItem.rightBarButtonItem = .init(customView: contentView.editButton)
        navigationItem.leftBarButtonItem = nil
        UIView.animate(withDuration: 0.2) {
            self.contentView.cancelButton.alpha = 0.0
            self.contentView.saveButton.alpha = 0.0
            self.contentView.changeAvatarButton.alpha = 0.0
        }
        tableView.tableHeaderView?.frame.size.height = 170
        contentView.avatarWithName.showLabels()
        contentView.avatarWithName.setName(firstName: model.firstName, lastName: model.lastName)
        showSavedState()
    }
    
    private func bindActions() {
        contentView.cancelButton.touchUpInsidePublisher
            .sink { [weak self] in
                self?.viewModel.onViewEvent(.cancelButtonPressed)
            }
            .store(in: &cancelableSet)
        contentView.editButton.touchUpInsidePublisher
            .sink { [weak self] in
                self?.viewModel.onViewEvent(.startEditing)
            }
            .store(in: &cancelableSet)
        contentView.saveButton.touchUpInsidePublisher
            .sink { [weak self] in
                self?.viewModel.onViewEvent(.saveButtonPressed)
            }
            .store(in: &cancelableSet)
        contentView.changeAvatarButton.touchUpInsidePublisher
            .sink { [weak self] in
                self?.changeAvatarPressed()
            }
            .store(in: &cancelableSet)
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .sink { [weak self] info in
                self?.keyboardWillShow(info)
            }
            .store(in: &cancelableSet)
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { [weak self] info in
                self?.keyboardWillHide(info)
            }
            .store(in: &cancelableSet)
    }
    
    private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        let sectionRect = tableView.rect(forSection: 1)
        let sectionFrameInWindow = tableView.convert(sectionRect, to: nil)

        let overlap = max(0, (sectionFrameInWindow.maxY) - keyboardFrame.origin.y)
        guard overlap > 0 else {
            return
        }
        contentView.frame.origin.y = -overlap
    }
    
    private func keyboardWillHide(_ notification: Notification) {
        contentView.frame.origin.y = 0
    }
    
    private func changeAvatarPressed() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        let pickerViewController = PHPickerViewController(configuration: configuration)
        pickerViewController.delegate = self
        present(pickerViewController, animated: true)
        self.pickerViewController = pickerViewController
    }
}

extension ProfileViewController: PHPickerViewControllerDelegate, TOCropViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        guard let result = results.first else {
            picker.dismiss(animated: true)
            return
        }
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
            DispatchQueue.main.async {
                if let image = object as? UIImage {
                    self?.chosenPhotoId = result.assetIdentifier
                    self?.showCropController(image: image, picker: picker)
                }
            }
        }
    }
        
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: false)
        pickerViewController?.isModalInPresentation = false
        pickerViewController?.deselectAssets(withIdentifiers: [chosenPhotoId ?? ""])
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropToCircularImage image: UIImage, with cropRect: CGRect, angle: Int) {
        contentView.avatarWithName.setImage(image)
        viewModel.saveItem(model: .init(type: .avatar, value: "", image: image))
        cropViewController.dismiss(animated: false) {
            self.pickerViewController?.dismiss(animated: true)
        }
    }
    
    private func showCropController(image: UIImage, picker: PHPickerViewController) {
        let vc = TOCropViewController(croppingStyle: .circular, image: image)
        vc.toolbarPosition = .bottom
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        picker.present(vc, animated: true)
    }
}
