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
        
        private(set) lazy var backgroundView: UIImageView = {
            let im = UIImageView()
            im.contentMode = .scaleAspectFit
            im.image = icons.chatBackground
            return im
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
        
        private(set) lazy var bottomView: BottomView = {
            return BottomView()
        }()
        
        override func setLayout() {
//            backgroundColor = UIColor(patternImage: icons.chatBackground)
            
            keyboardLayoutGuide.followsUndockedKeyboard = true
            setupHierarchy()
            setupConstraints()
        }
        
        private func setupHierarchy() {
            addSubview(backgroundView)
            addSubview(containerView)
            containerView.addSubview(chatCollectionView)
            containerView.addSubview(bottomView)
        }
        
        private func setupConstraints() {
            backgroundView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
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
        }
    }
}


extension ChatContext.ContentView {
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
