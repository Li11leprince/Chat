
import UIKit
import AppBaseFlow
import SnapKit
import AppDesignSystem

extension ProfileContext {
    final class ContentView: BaseView {
        
        private(set) lazy var tableView: UITableView = {
            let tb = UITableView(frame: .zero, style: .insetGrouped)
            return tb
        }()
        
        private(set) lazy var avatarWithName: AvatarWithNameView = {
            components.avatarWithName
        }()
        
        private(set) lazy var saveButton: ActionButton = {
            let btn = components.textButton(textColor: .systemBlue)
            btn.setTitle(strings.commonDone, for: .normal)
            btn.titleFont = typography.action
            btn.alpha = 0
            return btn
        }()
        
        private(set) lazy var cancelButton: ActionButton = {
            let btn = components.textButton(textColor: .systemBlue)
            btn.setTitle(strings.commonCancel, for: .normal)
            btn.titleFont = typography.action
            btn.alpha = 0
            return btn
        }()
        
        private(set) lazy var editButton: ActionButton = {
            let btn = components.textButton(textColor: .systemBlue)
            btn.setTitle(strings.commonEdit, for: .normal)
            btn.titleFont = typography.action
            return btn
        }()
        
        private(set) lazy var changeAvatarButton: ActionButton = {
            let btn = components.textButton(textColor: .systemBlue)
            btn.setTitle(strings.commonChange, for: .normal)
            btn.titleFont = typography.action
            btn.alpha = 0.0
            return btn
        }()
        
        override func setLayout() {
            setupHierarchy()
            setupConstraints()
        }
        
        private func setupHierarchy() {
            addSubview(tableView)
            tableView.tableHeaderView = avatarWithName
            avatarWithName.configure(avatar: icons.mockAvatar, name: "Анечка", subtitle: "В сети")
            addSubview(changeAvatarButton)
        }
        
        private func setupConstraints() {
            tableView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            tableView.tableHeaderView?.frame.size.height = 170
            
            changeAvatarButton.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(avatarWithName.snp.bottom).inset(35)
            }
        }
    }
}
