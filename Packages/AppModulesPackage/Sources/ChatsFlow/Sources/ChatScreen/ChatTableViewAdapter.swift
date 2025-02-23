//  

import UIKit
import AppBaseFlow

extension ChatViewController: CollectionViewAdaptable, UICollectionViewDelegateFlowLayout {
    
    func registerCells(in collectionView: UICollectionView) {
        collectionView.register(TextMessageCell.self)
    }
    
    func setDataSource(in collectionView: UICollectionView) {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, message in
            let cell = collectionView.dequeue(TextMessageCell.self, indexPath: indexPath)
            cell.configure(model: message)
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([0])
        snapshot.appendItems(TextMessageCellModel.mock)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func addNewMessage(_ text: String, isMe: Bool) {
        let newMessage = TextMessageCellModel(
            isMe: isMe,
            id: String(describing: UUID()),
            time: "12:54",
            text: text,
            isRead: false,
            reactions: [],
            isChanged: false
        )
        TextMessageCellModel.mock.append(newMessage)
        
        var snapshot = dataSource.snapshot()
        snapshot.appendItems([newMessage])
        snapshot.insertItems([newMessage], beforeItem: snapshot.itemIdentifiers[0])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    typealias Section = Int
    
    typealias Item = TextMessageCellModel
    
    typealias ViewModel = ChatViewModel
}
