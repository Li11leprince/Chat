//  

import UIKit
import AppBaseFlow

final class ChatViewController: BaseViewController<ChatViewModel,
                                 ChatContext.ViewEvent,
                                 ChatContext.ViewState,
                                 ChatContext.ContentView> {
    private let maxMessageTextViewHeight: CGFloat = 150
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.messageTextView.delegate = self
    }
    
    override func onViewState(_ viewState: ChatContext.ViewState) {
        switch viewState {
        case .initial:
            contentView.chatsCollectionView.dataSource = self
            contentView.chatsCollectionView.delegate = self
        }
    }
}

extension ChatViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.frame.height > maxMessageTextViewHeight {
            let height = textView.frame.height
            textView.isScrollEnabled = true
            textView.snp.updateConstraints { make in
                make.height.greaterThanOrEqualTo(height)
            }
            return
        }
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
}
