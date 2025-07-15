//  

import UIKit
import AppBaseFlow
import SnapKit
import AppDesignSystem

final class BottomView: BaseView {
    
    private(set) lazy var blurEffect: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        return blurEffectView
    }()
    
    private(set) lazy var messageTextView: UITextView = {
        let tv = UITextView()
        tv.textContainerInset = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        tv.isScrollEnabled = false
        tv.textContainer.lineBreakMode = .byWordWrapping
        tv.font = typography.subheadline
        tv.layer.cornerRadius = Paddings.messageTextViewCornerRadius
        return tv
    }()
    
    private(set) lazy var sendMessageButton: ActionButton = {
        let btn = ActionButton()
        btn.setImage(icons.sendMessageIcon, for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        return btn
    }()
    
    private(set) lazy var videoRecordButton: ActionButton = {
        let btn = ActionButton()
        btn.setImage(UIImage(systemName: "video.circle.fill"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.tintColor = .systemBlue
        return btn
    }()
    
    private(set) lazy var replyToView: ReplyToView = {
        let view = ReplyToView()
        view.clipsToBounds = true
        return view
    }()
    
    func showReplyToView(text: String, person: String) {
        replyToView.snp.updateConstraints { make in
            make.height.equalTo(Paddings.replyToViewHeight)
            make.bottom.equalTo(messageTextView.snp.top).inset(-Paddings.topBottomViewInset)
        }
        replyToView.setup(person: person, text: text)
        messageTextView.becomeFirstResponder()
        UIView.animate(withDuration: 0.2) {
            self.superview?.layoutIfNeeded()
        }
    }
    
    func hideReplyToView() {
        replyToView.snp.updateConstraints { make in
            make.height.equalTo(0)
            make.bottom.equalTo(messageTextView.snp.top).inset(0)
        }
        UIView.animate(withDuration: 0.2) {
            self.superview?.layoutIfNeeded()
        }
    }
    
    func updateConstraintsWhenKeyboardShow() {
        messageTextView.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(Paddings.topBottomViewInset)
        }
        UIView.animate(withDuration: 0.4) {
            self.superview?.layoutIfNeeded()
        }
    }
    
    func updateConstraintsWhenKeyboardHide() {
        messageTextView.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(Paddings.messageTextViewBottomInsentWhenKeyBoardClosed)
        }
        UIView.animate(withDuration: 0.4) {
            self.superview?.layoutIfNeeded()
        }
    }
    
    override func setLayout() {
        backgroundColor = UIColor.systemBackground.withAlphaComponent(0.7)
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupHierarchy() {
        addSubview(blurEffect)
        addSubview(replyToView)
        addSubview(messageTextView)
        addSubview(sendMessageButton)
        addSubview(videoRecordButton)
    }
    
    private func setupConstraints() {
        blurEffect.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        replyToView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Paddings.topBottomViewInset)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0)
            make.bottom.equalTo(messageTextView.snp.top).inset(0)
        }
        
        messageTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.bottom.equalToSuperview().inset(Paddings.messageTextViewBottomInsentWhenKeyBoardClosed)
            make.height.equalTo(Paddings.messageTextViewHeight)
        }
        
        videoRecordButton.snp.makeConstraints { make in
            make.bottom.equalTo(messageTextView.snp.bottom)
            make.trailing.equalTo(messageTextView.snp.leading).inset(-4)
            make.width.height.equalTo(30)
        }
        
        sendMessageButton.snp.makeConstraints { make in
            make.bottom.equalTo(messageTextView.snp.bottom)
            make.leading.equalTo(messageTextView.snp.trailing).inset(-4)
            make.width.height.equalTo(30)
        }
    }
}

extension BottomView {
    enum Paddings {
        static let topBottomViewInset: CGFloat = 8.0
        static let messageTextViewHeight: CGFloat = 28.0
        static let messageTextViewBottomInsentWhenKeyBoardClosed: CGFloat = 38
        static let messageTextViewCornerRadius: CGFloat = messageTextViewHeight / 2
        static let messageTextViewTopBottomPaddingsWhenWriting: CGFloat = 8.0
        static let maxMessageTextViewHeight: CGFloat = 150
        
        static let replyToViewHeight: CGFloat = 32.0
    }
}
