//  

import UIKit
import AppBaseFlow

extension ChatsViewController: TableViewAdaptable, UITableViewDataSource {
    
    typealias Section = Int
    
    typealias Item = Int
    
    typealias ViewModel = ChatsViewModel
    
    
    func registerCells(in tableView: UITableView) {
        print("flsd")
    }
    
    func setDataSource(in tableView: UITableView) {
        print("fsd")
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.onViewEvent(.chatPressed(id: "mock"))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        72
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
    }

}
