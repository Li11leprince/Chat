//  

import UIKit
import AppBaseFlow
import SnapKit

extension ChatsContext {
    final class ContentView: BaseView {
        private(set) var chatsTableView: UITableView = {
            let tb = UITableView()
//            tb.separatorStyle = .none
            return tb
        }()
        
        override func setLayout() {
            setupHierarchy()
            setupConstraints()
        }
        
        private func setupHierarchy() {
            addSubview(chatsTableView)
        }
        
        private func setupConstraints() {
            chatsTableView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
}
