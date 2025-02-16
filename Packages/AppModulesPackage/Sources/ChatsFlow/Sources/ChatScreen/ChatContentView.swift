//  

import UIKit
import AppBaseFlow
import SnapKit

extension ChatContext {
    final class ContentView: BaseView {
        private(set) lazy var chatsCollectionView: UICollectionView = {
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
            return collectionView
        }()
        
        private(set) lazy var bottomView: UIView = {
            let view = UIView()
            view.backgroundColor = colors.labelTertiary
            return view
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
        
        override func setLayout() {
            backgroundColor = colors.backgroundPrimary
            setupHierarchy()
            setupConstraints()
        }
        
        private func setupHierarchy() {
//            addSubview(chatsCollectionView)
            addSubview(bottomView)
            bottomView.addSubview(messageTextView)
        }
        
        private func setupConstraints() {
//            chatsCollectionView.snp.makeConstraints { make in
//                make.edges.equalToSuperview()
//            }
            
            bottomView.snp.makeConstraints { make in
                make.bottom.equalToSuperview()
                make.leading.trailing.equalToSuperview()
            }
            
            messageTextView.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(Paddings.topBottomViewInset)
                make.leading.trailing.equalToSuperview().inset(40)
                make.bottom.equalToSuperview().inset(38)
            }
        }
    }
}


private extension ChatContext.ContentView {
    enum Paddings {
        static let topBottomViewInset: CGFloat = 8.0
        static let messageTextViewHeight: CGFloat = 24.0
        static let messageTextViewCornerRadius: CGFloat = messageTextViewHeight / 2
    }
}
