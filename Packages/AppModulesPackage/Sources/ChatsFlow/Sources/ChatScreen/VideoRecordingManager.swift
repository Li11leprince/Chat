import UIKit
import AVFoundation
import Combine

final class VideoRecordingManager: NSObject {
    var capturePreview: UIView?
    
    private let captureSession = AVCaptureSession()
    private var videoOutput: AVCaptureMovieFileOutput = {
        let output = AVCaptureMovieFileOutput()
        output.maxRecordedDuration = CMTime(seconds: 60, preferredTimescale: 60)
        return output
    }()
    private var activeInput: AVCaptureDeviceInput!
    private var microphone: AVCaptureDevice!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var outputURL: URL!
    
    private var videoRecordedSubject = PassthroughSubject<URL, Never>()
    var videoRecordedPublisher: AnyPublisher<URL, Never> {
        videoRecordedSubject.eraseToAnyPublisher()
    }
    
    private var permissionGrantedSubject = PassthroughSubject<Bool, Never>()
    var permissionGrantedPublisher: AnyPublisher<Bool, Never> {
        permissionGrantedSubject.eraseToAnyPublisher()
    }
    
    override init() {
        super.init()
        checkPermissions()
    }
    
    private func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCameraAndMic()
            permissionGrantedSubject.send(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    self?.setupCameraAndMic()
                }
                self?.permissionGrantedSubject.send(granted)
            }
        case .denied, .restricted:
            permissionGrantedSubject.send(false)
        @unknown default:
            permissionGrantedSubject.send(false)
        }
    }
    
    private func setupCameraAndMic() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera], mediaType: .video, position: .front)
        if let device = deviceDiscoverySession.devices.first {
            if let deviceInput = try? AVCaptureDeviceInput(device: device) {
                if captureSession.canAddInput(deviceInput) {
                    captureSession.addInput(deviceInput)
                    activeInput = deviceInput
                }
            }
        }
        microphone = AVCaptureDevice.default(for: AVMediaType.audio)!
        do {
            let micInput = try AVCaptureDeviceInput(device: microphone)
            if captureSession.canAddInput(micInput) {
                captureSession.addInput(micInput)
            }
        } catch {
            print("Error setting device audio input: \(error)")
        }
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }
    }
    
    func setupPreview(capturePreview: UIView) {
        //Configure previewLayer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = .init(x: 0, y: 0, width: 300, height: 300)
        
        // to set aspect ratio
//        let aspectRatio = CGSize(width: 1920, height: 1080)
//        previewLayer.frame = AVMakeRect(aspectRatio: aspectRatio, insideRect: capturePreview.bounds)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        capturePreview.layer.addSublayer(previewLayer)
    }
    
    func startOrStopRecording() {
        if videoOutput.isRecording == false {
            let connection = videoOutput.connection(with: AVMediaType.video)
            if (connection?.isVideoOrientationSupported) ?? false {
                connection?.videoOrientation = .portrait
            }
            if (connection?.isVideoStabilizationSupported) ?? false {
                connection?.preferredVideoStabilizationMode = AVCaptureVideoStabilizationMode.auto
            }
            let device = activeInput.device
            if (device.isSmoothAutoFocusSupported) {
                do {
                    
                    try device.lockForConfiguration()
                    for range in device.activeFormat.videoSupportedFrameRateRanges {
                        if range.maxFrameRate <= 60 && range.minFrameRate >= 30 {
                            device.activeVideoMaxFrameDuration = CMTime(value: 1, timescale: 60)
                            device.activeVideoMinFrameDuration = CMTime(value: 1, timescale: 60)
                        }
                        
                    }
                    //device.activeFormat = activeFormat.videoSupportedFrameRateRanges
                    device.isSmoothAutoFocusEnabled = false
                    device.unlockForConfiguration()
                } catch {
                    print("Error setting configuration: \(error)")
                }
            }
            outputURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + UUID().uuidString + ".mp4")
            videoOutput.startRecording(to: outputURL, recordingDelegate: self)
        } else {
            stopRecording()
        }
    }
    
    private func stopRecording() {
        videoOutput.stopRecording()
    }
    
    func startSession() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    func stopSession() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.stopRunning()
        }
    }
}

extension VideoRecordingManager: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if error == nil {
            videoRecordedSubject.send(outputFileURL)
        }
    }
} 
