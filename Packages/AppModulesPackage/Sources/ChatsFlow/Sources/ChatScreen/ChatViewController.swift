//  

import UIKit
import AppBaseFlow

final class ChatViewController: BaseViewController<ChatViewModel,
                                 ChatContext.ViewEvent,
                                 ChatContext.ViewState,
                                 ChatContext.ContentView> {
    private let maxMessageTextViewHeight: CGFloat = 80
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
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
}
