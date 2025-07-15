//  

import UIKit
import AppBaseFlow

final class ChatViewController: BaseViewController<ChatViewModel,
                                 ChatContext.ViewEvent,
                                 ChatContext.ViewState,
                                 ChatContext.ContentView> {

    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    var collectionView: UICollectionView { contentView.chatCollectionView }
    var bottomView: BottomView { contentView.bottomView }
    
    private typealias Paddings = ChatContext.ContentView.Paddings
    private var videoPreviewView: CircularVideoPreviewView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeHideKeyboard()
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
        case .newMessages(let messages):
            addNewMessages(messages)
        }
    }
    
    private func initial() {
        collectionView.delegate = self
        bottomView.messageTextView.delegate = self
        
        navigationItem.title = "Анечка❤️"
    }
    
    private func bindActions() {
        bottomView.sendMessageButton.touchUpInsidePublisher
            .sink { [weak self] in
                guard let self,
                      let text = bottomView.messageTextView.text,
                    text != "" else {
                    return
                }
                self.viewModel.onViewEvent(.messageButtonClicked(text))
                self.bottomView.messageTextView.text = ""
                self.textViewDidChange(bottomView.messageTextView)
            }
            .store(in: &cancelableSet)
            
        bottomView.videoRecordButton.touchUpInsidePublisher
            .sink { [weak self] in
                self?.showVideoPreview()
            }
            .store(in: &cancelableSet)
            
        bottomView.replyToView.closeButton.touchUpInsidePublisher
            .sink { [weak self] in
                self?.bottomView.hideReplyToView()
                self?.viewModel.onViewEvent(.replyTo(nil))
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
    
    private func showVideoPreview() {
        let videoPreviewView = CircularVideoPreviewView(videoRecordingManager: viewModel.videoRecordingManager)
        videoPreviewView.frame = view.bounds
        videoPreviewView.onClose = { [weak self] in
            self?.hideVideoPreview()
        }
        view.addSubview(videoPreviewView)
        self.videoPreviewView = videoPreviewView
        
        videoPreviewView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            videoPreviewView.alpha = 1
        }
        
        viewModel.onViewEvent(.startVideoRecording)
        videoPreviewView.startSession()
    }
    
    private func hideVideoPreview() {
        guard let videoPreviewView = videoPreviewView else { return }
        videoPreviewView.stopSession()
        viewModel.onViewEvent(.stopVideoRecording)
        
        UIView.animate(withDuration: 0.3) {
            videoPreviewView.alpha = 0
        } completion: { _ in
            videoPreviewView.removeFromSuperview()
            self.videoPreviewView = nil
        }
    }
    
    private func keyboardWillShow(notification: Notification) {
        let info = notification.userInfo!
        let frame = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        contentView.containerView.frame.origin.y = -frame.height
        bottomView.updateConstraintsWhenKeyboardShow()
        collectionView.contentInset.bottom = frame.height + contentView.safeAreaInsets.top + 8
        collectionView.scrollIndicatorInsets = collectionView.contentInset
    }
    
    private func keyboardWillHide() {
        contentView.containerView.frame.origin.y = 0
        bottomView.updateConstraintsWhenKeyboardHide()
        collectionView.contentInset.bottom = contentView.safeAreaInsets.top + 8
        collectionView.scrollIndicatorInsets = collectionView.contentInset
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
