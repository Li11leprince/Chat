import UIKit
import AVFoundation
import SnapKit
import AppBaseFlow
import AppEntities
import Combine

class CircleVideoCell: TextMessageCell {
    private var playerLayer: AVPlayerLayer?
    private var isPlaying = false
    private var isAudioEnabled = false
    private var timeObserver: Any?
    private var cancellables = Set<AnyCancellable>()
    private var queuePlayer: AVQueuePlayer!
    private var playerLooper: AVPlayerLooper!
    private var timeObserverToken: Any?
    
    private lazy var videoContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 150
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var playPauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(playPauseTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var timeSlider: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = .systemBlue
        slider.maximumTrackTintColor = .systemGray4
        slider.setThumbImage(UIImage(systemName: "circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .allTouchEvents)
        return slider
    }()
    
    private lazy var currentTimeLabel: UILabel = {
        let label = UILabel()
        label.font = typography.caption2
        label.textColor = colors.labelPrimaryVariant
        return label
    }()
    
    private lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.font = typography.caption2
        label.textColor = colors.labelPrimaryVariant
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupLayout() {
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(videoContainer)
        bubbleView.backgroundColor = .clear
        videoContainer.addSubview(playPauseButton)
        bubbleView.addSubview(timeSlider)
        bubbleView.addSubview(currentTimeLabel)
        bubbleView.addSubview(durationLabel)
        
        bubbleView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        videoContainer.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.width.lessThanOrEqualTo(maxBubbleWidth)
            make.bottom.equalTo(timeSlider.snp.top).inset(-8)
            make.width.height.equalTo(300)
        }
        
        playPauseButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(44)
        }
        
        timeSlider.snp.makeConstraints { make in
            make.centerX.equalTo(videoContainer.snp.centerX)
            make.bottom.equalTo(currentTimeLabel.snp.top).inset(-4)
            make.width.equalTo(videoContainer.snp.width).offset(-64)
        }
        
        currentTimeLabel.snp.makeConstraints { make in
            make.leading.equalTo(timeSlider.snp.leading)
            make.bottom.equalToSuperview()
        }
        
        durationLabel.snp.makeConstraints { make in
            make.trailing.equalTo(timeSlider.snp.trailing)
            make.lastBaseline.equalTo(currentTimeLabel.snp.lastBaseline)
        }
    }
    
    override func configure(model: MessageCellModel) {
        if case .circleVideo(let videoModel) = model.messageType {
            currentTimeLabel.text = model.time
            
            videoContainer.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                make.width.lessThanOrEqualTo(maxBubbleWidth)
                make.bottom.equalTo(timeSlider.snp.top).inset(-8)
                make.width.height.equalTo(300)
                
                if model.isMe {
                    make.trailing.equalToSuperview().inset(10)
                } else {
                    make.leading.equalToSuperview().inset(10)
                }
            }
            
            setupVideo(url: videoModel.videoURL)
        }
    }
    
    private func setupVideo(url: URL) {
        let playerItem = AVPlayerItem(url: url)
        
        // Observe duration
        playerItem.publisher(for: \.duration)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] duration in
                print("Duration: \(CMTimeGetSeconds(playerItem.duration))")
                self?.updateDuration(duration)
            }
            .store(in: &cancellables)
        
        queuePlayer = AVQueuePlayer()
        queuePlayer.isMuted = true
        playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.queuePlayer.currentItem!.publisher(for: \.duration)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] duration in
                    self?.updateDuration(duration)
                }
                .store(in: &self.cancellables)
        }

        let playerLayer = AVPlayerLayer(player: queuePlayer)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = .init(x: 0, y: 0, width: 300, height: 300)
        videoContainer.layer.insertSublayer(playerLayer, at: 0)
        
        // Start playing when visible
//        queuePlayer.play()
//        isPlaying = true
        updatePlayPauseButton()
    }
    
    private func startObservingPlayerTime() {
        let interval = CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)) // обновление 10 раз в секунду

        timeObserverToken = queuePlayer.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            let seconds = CMTimeGetSeconds(time)
            self?.timeSlider.value = Float(seconds)
        }
    }
    
    private func updateDuration(_ duration: CMTime) {
        guard duration.seconds > 0 else { return }
        let totalSeconds = CMTimeGetSeconds(duration)
        let minutes = Int(totalSeconds) / 60
        let seconds = Int(totalSeconds) % 60
        durationLabel.text = String(format: "%d:%02d", minutes, seconds)
        timeSlider.maximumValue = Float(totalSeconds)
    }
    
    private func updateCurrentTime(_ time: CMTime) {
        let seconds = CMTimeGetSeconds(time)
        let minutes = Int(seconds) / 60
        let remainingSeconds = Int(seconds) % 60
        timeSlider.value = Float(seconds)
    }
    
    @objc private func playPauseTapped() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    private func play() {
        if !isAudioEnabled {
            queuePlayer?.isMuted = false
            isAudioEnabled = true
        }
//            queuePlayer?.seek(to: .zero)
        queuePlayer?.play()
        startObservingPlayerTime()
        isPlaying = true
        playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
    }
    
    private func pause() {
        queuePlayer?.pause()
        timeObserverToken = nil
        isPlaying = false
        playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
    }
    
    private func updatePlayPauseButton() {
        let imageName = isPlaying ? "pause.fill" : "play.fill"
        playPauseButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @objc private func sliderValueChanged(_ slider: UISlider) {
//        let time = CMTime(seconds: Double(slider.value), preferredTimescale: 600)
//        updateCurrentTime(time)
        pause()
        let time = CMTime(seconds: Double(slider.value), preferredTimescale: 600)
        queuePlayer?.seek(to: time)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        queuePlayer?.pause()
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        timeObserver = nil
        cancellables.removeAll()
        queuePlayer = nil
        playerLooper = nil
    }
} 
