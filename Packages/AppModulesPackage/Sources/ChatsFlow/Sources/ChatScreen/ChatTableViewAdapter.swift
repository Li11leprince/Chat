//  

import UIKit
import AppBaseFlow

extension ChatViewController: CollectionViewAdaptable, UICollectionViewDataSource {
    func registerCells(in collectionView: UICollectionView) {
        print("")
    }
    
    func setDataSource(in collectionView: UICollectionView) {
        print("f")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ChatCell(frame: .zero)
        cell.configure()
        cell.update(data: ChatModel.mock)
        return cell
    }
    
    typealias Section = Int
    
    typealias Item = Int
    
    typealias ViewModel = ChatViewModel
    
    var dataSource: DataSource? {
        get {
            nil
        }
        set(newValue) {
            print("fds")
        }
    }
    
    func registerCells(in tableView: UITableView) {
        print("flsd")
    }
    
    func setDataSource(in tableView: UITableView) {
        print("fsd")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        72
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
    }

}
