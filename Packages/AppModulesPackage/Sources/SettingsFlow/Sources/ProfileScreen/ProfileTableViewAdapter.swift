import UIKit
import AppBaseFlow

extension ProfileViewController: TableViewAdaptable {
    
    typealias Section = Int
    
    typealias Item = UserDataItem
    
    typealias ViewModel = SettingsViewModel
    
    func registerCells(in tableView: UITableView) {
        tableView.register(PhoneCell.self)
        tableView.register(UsernameCell.self)
        tableView.register(BirthdayCell.self)
        tableView.register(BioCell.self)
        tableView.register(FirstNameCell.self)
        tableView.register(LastNameCell.self)
    }
    
    func setDataSource(in tableView: UITableView) {
        dataSource = UITableViewDiffableDataSource<Section, Item>(tableView: tableView) { [weak self] tableView, indexPath, model in
            switch model.type {
            case .firstName:
                let cell = tableView.dequeue(FirstNameCell.self, indexPath: indexPath)
                cell.textChanged = { [weak self] text in
                    self?.updateProfileItem(type: .firstName, newValue: text)
                }
                cell.configure(firstName: model.value)
                return cell
            case .lastName:
                let cell = tableView.dequeue(LastNameCell.self, indexPath: indexPath)
                cell.textChanged = { [weak self] text in
                    self?.updateProfileItem(type: .lastName, newValue: text)
                }
                cell.configure(lastName: model.value)
                return cell
            case .phone:
                let cell = tableView.dequeue(PhoneCell.self, indexPath: indexPath)
                cell.textChanged = { [weak self] text in
                    self?.updateProfileItem(type: .phone, newValue: text)
                }
                cell.configure(phone: model.value)
                return cell
            case .username:
                let cell = tableView.dequeue(UsernameCell.self, indexPath: indexPath)
                cell.textChanged = { [weak self] text in
                    self?.updateProfileItem(type: .username, newValue: text)
                }
                cell.configure(username: model.value)
                return cell
            case .birthday:
                let cell = tableView.dequeue(BirthdayCell.self, indexPath: indexPath)
                cell.textChanged = { [weak self] text in
                    self?.updateProfileItem(type: .birthday, newValue: text)
                }
                cell.configure(birthday: model.value)
                return cell
            case .bio:
                let cell = tableView.dequeue(BioCell.self, indexPath: indexPath)
                cell.textChanged = { [weak self] text in
                    self?.updateProfileItem(type: .bio, newValue: text)
                }
                cell.configure(bio: model.value)
                return cell
            case .avatar:
                return nil
            }
        }
        
        let snapshot = DataSourceSnapshot()
        dataSource?.apply(snapshot)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? UserDataCell,
              viewModel.isEditing == true else {
            return
        }
        tableView.beginUpdates()
        cell.didTapEdit()
        tableView.endUpdates()
    }
    
    func showEditState(model: UserDataModel) {
        guard var snapshot = dataSource?.snapshot() else {
            return
        }
        let items: [UserDataItem] = [
            UserDataItem(type: .firstName, value: model.firstName),
            UserDataItem(type: .lastName, value: model.lastName)
        ]
        snapshot.insertSections([0], beforeSection: 1)
        snapshot.appendItems(items, toSection: 0)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func showSavedState() {
        guard var snapshot = dataSource?.snapshot() else {
            return
        }
        snapshot.deleteSections([0])
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func applyInitialSnaphot(model: UserDataModel) {
        guard var snapshot = dataSource?.snapshot() else {
            return
        }
        let items: [UserDataItem] = [
            UserDataItem(type: .phone, value: model.phoneNumber),
            UserDataItem(type: .username, value: model.userName),
            UserDataItem(type: .birthday, value: model.birthday),
            UserDataItem(type: .bio, value: model.bio)
        ]
        snapshot.appendSections([1])
        snapshot.appendItems(items, toSection: 1)
        dataSource?.apply(snapshot)
    }
    
    private func updateProfileItem(type: InfoType, newValue: String) {
        let item = UserDataItem(type: type, value: newValue)
        viewModel.saveItem(model: item)
        guard var snapshot = dataSource?.snapshot() else {
            return
        }
//        snapshot.applyChanges { snapshot in
//            snapshot.
//        }
    }
}
