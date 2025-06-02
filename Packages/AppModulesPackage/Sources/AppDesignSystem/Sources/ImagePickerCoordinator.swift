import UIKit
import PhotosUI
import TOCropViewController

public protocol ImagePickerCoordinatorDelegate: AnyObject {
    func imagePickerCoordinator(_ coordinator: ImagePickerCoordinator, didSelectImage image: UIImage)
}

public final class ImagePickerCoordinator: NSObject {
    public weak var delegate: ImagePickerCoordinatorDelegate?
    public weak var presentingViewController: UIViewController?
    
    private var pickerViewController: PHPickerViewController?
    
    public func presentImagePicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        pickerViewController = picker
        presentingViewController?.present(picker, animated: true)
    }
}

// MARK: - PHPickerViewControllerDelegate
extension ImagePickerCoordinator: PHPickerViewControllerDelegate {
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        guard let result = results.first else {
            picker.dismiss(animated: true)
            return
        }
        
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
            guard let self = self, let image = object as? UIImage else { return }
            DispatchQueue.main.async {
                self.presentCropViewController(for: image, picker: picker)
            }
        }
    }
}

// MARK: - TOCropViewControllerDelegate
extension ImagePickerCoordinator: TOCropViewControllerDelegate {
    private func presentCropViewController(for image: UIImage, picker: PHPickerViewController) {
        let cropViewController = TOCropViewController(croppingStyle: .circular, image: image)
        cropViewController.toolbarPosition = .bottom
        cropViewController.delegate = self
        cropViewController.modalTransitionStyle = .crossDissolve
        picker.present(cropViewController, animated: true)
    }
    
    public func cropViewController(_ cropViewController: TOCropViewController, didCropToCircularImage image: UIImage, with cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: false) {
            self.pickerViewController?.dismiss(animated: true)
        }
        delegate?.imagePickerCoordinator(self, didSelectImage: image)
    }
    
    public func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: false)
        pickerViewController?.isModalInPresentation = false
    }
}
