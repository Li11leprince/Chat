import UIKit
import AVFoundation
import Combine

final class CircularVideoPreviewView: UIView {
    private let videoRecordingManager: VideoRecordingManager
    private var isRecording = false
    private var cancellables = Set<AnyCancellable>()
    
    var onClose: (() -> Void)?
    
    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        return view
    }()
    
    private(set) lazy var previewContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 150
        view.backgroundColor = .black
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var recordButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 35
        button.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var permissionLabel: UILabel = {
        let label = UILabel()
        label.text = "Camera access is required to record video"
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    init(videoRecordingManager: VideoRecordingManager) {
        self.videoRecordingManager = videoRecordingManager
        super.init(frame: .zero)
        videoRecordingManager.setupPreview(capturePreview: previewContainer)
        setupUI()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Add blur effect to window level to cover everything
        guard let window = UIApplication.shared.windows.first else { return }
        
        window.addSubview(blurEffectView)
        window.addSubview(previewContainer)
        window.addSubview(recordButton)
        window.addSubview(permissionLabel)
        window.addSubview(closeButton)
        
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        previewContainer.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(300)
        }
        
        recordButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(80)
            make.width.height.equalTo(70)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(44)
        }
        
        permissionLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40)
        }
    }
    
    private func setupBindings() {
        videoRecordingManager.permissionGrantedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] granted in
                self?.handlePermissionState(granted)
            }
            .store(in: &cancellables)
            
        videoRecordingManager.videoRecordedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.onClose?()
            }
            .store(in: &cancellables)
    }
    
    private func handlePermissionState(_ granted: Bool) {
        if granted {
            permissionLabel.isHidden = true
            recordButton.isEnabled = true
        } else {
            permissionLabel.isHidden = false
            recordButton.isEnabled = false
        }
    }
    
    @objc private func recordButtonTapped() {
        if isRecording {
            videoRecordingManager.startOrStopRecording()
            recordButton.backgroundColor = .systemRed
        } else {
            videoRecordingManager.startOrStopRecording()
            recordButton.backgroundColor = .systemGray
        }
        isRecording.toggle()
    }
    
    @objc private func closeButtonTapped() {
        if isRecording {
            videoRecordingManager.startOrStopRecording()
        }
        onClose?()
    }
    
    func startSession() {
        videoRecordingManager.startSession()
    }
    
    func stopSession() {
        videoRecordingManager.stopSession()
    }
} 
