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
            switch message {
            case .plainText(let model):
                return self.bindTextCell(collectionView, indexPath, model)
            }
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([0])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func addNewMessages(_ messages: [MessageCellModel]) {
        var snapshot = dataSource.snapshot()
        if snapshot.itemIdentifiers.isEmpty {
            snapshot.appendItems(messages)
        } else {
            snapshot.insertItems(messages, beforeItem: snapshot.itemIdentifiers[0])
        }
        dataSource.apply(snapshot, animatingDifferences: true)
        bottomView.hideReplyToView()
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
        _ model: TextMessageCellModel
    ) -> TextMessageCell {
        let cell = collectionView.dequeue(TextMessageCell.self, indexPath: indexPath)
        cell.configure(model: model)
        cell.onReply = { [weak self] model in
            guard case .plainText(let model) = model else { return }
            self?.bottomView.showReplyToView(text: model.text, person: model.from.displayName)
            self?.viewModel.onViewEvent(.replyTo(.plainText(model)))
        }
        cell.onReaction = { [weak self] in
            guard let self else { return }
            UIView.animate(withDuration: 0.15) {
                self.collectionView.performBatchUpdates(nil)
            }
        }
        return cell
    }
    
    typealias Section = Int
    
    typealias Item = MessageCellModel
    
    typealias ViewModel = ChatViewModel
}
