import UIKit
import PhotosUI
import AppBaseFlow
import TOCropViewController
import Supabase

final class ProfileViewController: BaseViewController<ProfileViewModel,
                                                    ProfileContext.ViewEvent,
                                                    ProfileContext.ViewState,
                                                    ProfileContext.ContentView> {
    
    var dataSource: UITableViewDiffableDataSource<Section, Item>?
    
    private var tableView: UITableView { contentView.tableView }
    private var navBarContainerView: UIView!
    private var pickerViewController: PHPickerViewController?
    private var chosenPhotoId: String?
    let client = SupabaseClient(
        supabaseURL: URL(string: "https://srkadqrsczrgzqluprpw.supabase.co")!,
        supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNya2FkcXJzY3pyZ3pxbHVwcnB3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI5OTYyMDUsImV4cCI6MjA1ODU3MjIwNX0.yaiva2snDursvyOR-QCTTeuHpU_wSd8jnq9A2suVnRA"
    )
    
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
//        Task {
//            if let url = await uploadFileToStorage(image: image) {
//                await downloadFileFromStorage(url: url)
//            }
//        }
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
    
    func uploadFileToStorage(image: UIImage) async -> URL? {
        do {
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                return nil
            }
            
            // Доступ к bucket "avatars" (замените на свой bucket)
            let fileName = "profile-\(UUID().uuidString).jpg"
            let bucket = client.storage.from("media")
            
            // Загрузка файла в bucket
            try await bucket.upload(
                fileName,
                data: imageData
            )
            
            print("File uploaded successfully at path: \(fileName)")
            
            return try bucket.getPublicURL(path: fileName)
        } catch {
            print("Error uploading file: \(error.localizedDescription)")
            return nil
        }
    }
    
    func downloadFileFromStorage(url: URL) async {
        do {
            let imageData = try await URLSession.shared.data(for: .init(url: url, method: .get))
            print("File downloaded: \(imageData.0.count) bytes")
            
            if let image = UIImage(data: imageData.0) {
                // Отобразите изображение в UIImageView или обработайте его
                print("Image downloaded successfully")
            }
        } catch {
            print("Error downloading file: \(error.localizedDescription)")
        }
    }
}
