
import UIKit
import AppBaseFlow
import SnapKit

extension SettingsContext {
    final class ContentView: BaseView {
        
        private(set) lazy var tableView: UITableView = {
            let tb = UITableView(frame: .zero, style: .insetGrouped)
            return tb
        }()
        
        override func setLayout() {
            setupHierarchy()
            setupConstraints()
        }
        
        private func setupHierarchy() {
            addSubview(tableView)
        }
        
        private func setupConstraints() {
            tableView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
}
