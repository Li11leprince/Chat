//  

import UIKit
import AppBaseFlow

final class ChatViewController: BaseViewController<ChatViewModel,
                                 ChatContext.ViewEvent,
                                 ChatContext.ViewState,
                                 ChatContext.ContentView> {

    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    var collectionView: UICollectionView { contentView.chatCollectionView }
    
    private typealias Paddings = ChatContext.ContentView.Paddings
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindActions()
        registerCells(in: contentView.chatCollectionView)
        setDataSource(in: contentView.chatCollectionView)
        
        collectionView.contentInset = UIEdgeInsets(top: 58, left: 0, bottom: contentView.safeAreaInsets.top + 8, right: 0)
        collectionView.scrollIndicatorInsets = collectionView.contentInset
    }
    
    override func onViewState(_ viewState: ChatContext.ViewState) {
        switch viewState {
        case .initial:
            initial()
        case .newMessage(let message):
            addNewMessage(message, isMe: true)
        }
    }
    
    private func initial() {
        collectionView.delegate = self
        contentView.messageTextView.delegate = self
        
        navigationItem.title = "Анечка❤️"
    }
    
    private func bindActions() {
        initializeHideKeyboard()
        contentView.sendMessageButton.touchUpInsidePublisher
            .sink { [weak self] in
                guard let self,
                      let text = contentView.messageTextView.text,
                    text != "" else {
                    return
                }
                self.viewModel.onViewEvent(.messageButtonClicked(text))
                self.contentView.messageTextView.text = ""
                self.textViewDidChange(contentView.messageTextView)
            }
            .store(in: &cancelableSet)
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .sink { [weak self] info in
                self?.keyboardWillShow(notification: info)
            }
            .store(in: &cancelableSet)
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { [weak self] info in
                self?.keyboardWillHide()
            }
            .store(in: &cancelableSet)
    }
    
    private func getCollectionViewContentInsets(
        bounds: CGRect,
        forScrollIndicator: Bool
    ) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: bounds.height + (forScrollIndicator ? 0 : 8),
            left: 0,
            bottom: self.contentView.safeAreaInsets.top + bounds.height + (forScrollIndicator ? 0 : 8),
            right: 0
        )
    }
    
    private func keyboardWillShow(notification: Notification) {
        let info = notification.userInfo!
        let frame = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        contentView.containerView.frame.origin.y = -frame.height
        contentView.updateConstraintsWhenKeyboardShow()
        collectionView.contentInset.bottom = frame.height + contentView.safeAreaInsets.top + 8
        collectionView.scrollIndicatorInsets = collectionView.contentInset
    }
    
    private func keyboardWillHide() {
        contentView.containerView.frame.origin.y = 0
        contentView.updateConstraintsWhenKeyboardHide()
        collectionView.contentInset.bottom = contentView.safeAreaInsets.top + 8
        collectionView.scrollIndicatorInsets = collectionView.contentInset
    }
    
    private func initializeHideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension ChatViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)

        if estimatedSize.height >= Paddings.maxMessageTextViewHeight {
            textView.isScrollEnabled = true
            textView.snp.updateConstraints { make in
                make.height.equalTo(Paddings.maxMessageTextViewHeight)
            }
        } else {
            textView.isScrollEnabled = false
            textView.snp.updateConstraints { make in
                make.height.equalTo(estimatedSize.height)
            }
        }
        
        UIView.animate(withDuration: 0.15) {
            self.view.layoutIfNeeded()
        }
    }
}
