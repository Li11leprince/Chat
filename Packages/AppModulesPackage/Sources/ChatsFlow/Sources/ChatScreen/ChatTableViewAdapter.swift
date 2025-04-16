//  

import UIKit
import AppBaseFlow
import AppEntities

extension ChatViewController: CollectionViewAdaptable, UICollectionViewDelegateFlowLayout {
    
    func registerCells(in collectionView: UICollectionView) {
        collectionView.register(TextMessageCell.self)
    }
    
    func setDataSource(in collectionView: UICollectionView) {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, message in
            return self.bindTextCell(collectionView, indexPath, message)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([0])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func addNewMessage(_ text: String, isMe: Bool) {
        let message = Message(id: String(describing: UUID()), timestamp: 423, messageType: .plainText, text: text, thumb: nil, from: nil, isRead: false, redirectedMessages: [], attachments: [], reactions: [], replyTo: nil, isChanged: false)
//        TextMessageCellModel.mock.append(newMessage)
        
        var snapshot = dataSource.snapshot()
        if snapshot.itemIdentifiers.isEmpty {
            snapshot.appendItems([message])
        } else {
            snapshot.insertItems([message], beforeItem: snapshot.itemIdentifiers[0])
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
//    private func bindReplyCell(
//        _ collectionView: UICollectionView,
//        _ indexPath: IndexPath,
//        _ message: Message
//    ) -> TextWithReplyCell {
//        let cell = collectionView.dequeue(TextWithReplyCell.self, indexPath: indexPath)
//        let model = TextWithReplyCellModel(
//            message: .init(isMe: true, id: message.id, time: "15:54", text: message.text, isRead: message.isRead, reactions: message.reactions, isChanged: message.isChanged),
//            repliedName: message.replyTo!.from.displayName,
//            repliedText: message.replyTo!.text
//        )
//        cell.configure(model: model)
//        cell.onReply = { [weak self] text in
//            self?.bottomView.showReplyToView(text: text, person: "Anna")
//        }
//        return cell
//    }
    
    private func bindTextCell(
        _ collectionView: UICollectionView,
        _ indexPath: IndexPath,
        _ message: Message
    ) -> TextMessageCell {
        let cell = collectionView.dequeue(TextMessageCell.self, indexPath: indexPath)
        let model: TextMessageCellModel = .init(isMe: true, id: message.id, time: "15:54", text: message.text, isRead: message.isRead, reactions: message.reactions, isChanged: message.isChanged, replyTo: .init(id: "fsd", name: "Anna", text: "I love you"))
        cell.configure(model: model)
        cell.onReply = { [weak self] text in
            self?.bottomView.showReplyToView(text: text, person: "Anna")
        }
        return cell
    }
    
    typealias Section = Int
    
    typealias Item = Message
    
    typealias ViewModel = ChatViewModel
}
