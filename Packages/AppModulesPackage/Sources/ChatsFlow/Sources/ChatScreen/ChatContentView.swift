//  

import UIKit
import AppBaseFlow
import SnapKit
import AppDesignSystem

extension ChatContext {
    final class ContentView: BaseView {
        private(set) lazy var containerView: UIView = {
            return UIView()
        }()
        
        private(set) lazy var chatCollectionView: UICollectionView = {
            let layout = ChatCollectionViewFlowLayout()
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            layout.minimumLineSpacing = 4
            layout.scrollDirection = .vertical
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.backgroundColor = .clear
            collectionView.alwaysBounceVertical = true
            collectionView.transform = CGAffineTransform(scaleX: 1, y: -1)
            collectionView.clipsToBounds = false
            collectionView.contentInsetAdjustmentBehavior = .never
            collectionView.automaticallyAdjustsScrollIndicatorInsets = false
            return collectionView
        }()
        
        private(set) lazy var bottomView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.7)
            return view
        }()
        
        private(set) lazy var blurEffect: UIVisualEffectView = {
            let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            return blurEffectView
        }()
        
        private(set) lazy var messageTextView: UITextView = {
            let tv = UITextView()
            tv.textContainerInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
            tv.isScrollEnabled = false
            tv.textContainer.lineBreakMode = .byWordWrapping
            tv.font = typography.subheadline
            tv.layer.cornerRadius = Paddings.messageTextViewCornerRadius
            return tv
        }()
        
        private(set) lazy var sendMessageButton: ActionButton = {
            let btn = ActionButton()
            let image = UIImage(
                systemName: "paperplane.circle.fill",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .bold)
            )
            btn.setImage(image, for: .normal)
            btn.imageView?.contentMode = .scaleAspectFill
            return btn
        }()
        
        override func setLayout() {
            backgroundColor = UIColor(patternImage: icons.chatBackground)
            keyboardLayoutGuide.followsUndockedKeyboard = true
            setupHierarchy()
            setupConstraints()
        }
        
        func updateConstraintsWhenKeyboardShow() {
            messageTextView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().inset(Paddings.topBottomViewInset)
            }
            UIView.animate(withDuration: 0.4) {
                self.containerView.layoutIfNeeded()
            }
        }
        
        func updateConstraintsWhenKeyboardHide() {
            messageTextView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().inset(Paddings.messageTextViewBottomInsentWhenKeyBoardClosed)
            }
            UIView.animate(withDuration: 0.4) {
                self.containerView.layoutIfNeeded()
            }
        }
        
        private func setupHierarchy() {
            addSubview(containerView)
            containerView.addSubview(chatCollectionView)
            containerView.addSubview(bottomView)
            bottomView.addSubview(blurEffect)
            bottomView.addSubview(messageTextView)
            bottomView.addSubview(sendMessageButton)
        }
        
        private func setupConstraints() {
            containerView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            chatCollectionView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.left.right.equalToSuperview()
                make.bottom.equalTo(bottomView.snp.top).inset(50)
            }
            
            bottomView.snp.makeConstraints { make in
                make.bottom.equalToSuperview()
                make.leading.trailing.equalToSuperview()
            }
            
            blurEffect.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            messageTextView.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(Paddings.topBottomViewInset)
                make.leading.trailing.equalToSuperview().inset(40)
                make.bottom.equalToSuperview().inset(Paddings.messageTextViewBottomInsentWhenKeyBoardClosed)
                make.height.equalTo(Paddings.messageTextViewHeight)
            }
            
            sendMessageButton.snp.makeConstraints { make in
                make.bottom.equalTo(messageTextView.snp.bottom)
                make.leading.equalTo(messageTextView.snp.trailing).inset(-4)
                make.width.height.equalTo(24)
            }
        }
    }
}


extension ChatContext.ContentView {
    enum Paddings {
        static let topBottomViewInset: CGFloat = 4.0
        static let messageTextViewHeight: CGFloat = 28.0
        static let messageTextViewBottomInsentWhenKeyBoardClosed: CGFloat = 38
        static let messageTextViewCornerRadius: CGFloat = messageTextViewHeight / 2
        static let messageTextViewTopBottomPaddingsWhenWriting: CGFloat = 8.0
        static let maxMessageTextViewHeight: CGFloat = 150
    }
}
