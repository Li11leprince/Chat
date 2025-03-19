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
            switch model {
            case .firstName(let firstName):
                let cell = tableView.dequeue(FirstNameCell.self, indexPath: indexPath)
                self?.bindToEditButton(tableView, cell)
                cell.configure(firstName: firstName)
                return cell
            case .lastName(let lastName):
                let cell = tableView.dequeue(LastNameCell.self, indexPath: indexPath)
                self?.bindToEditButton(tableView, cell)
                cell.configure(lastName: lastName)
                return cell
            case .phone(let phone):
                let cell = tableView.dequeue(PhoneCell.self, indexPath: indexPath)
                self?.bindToEditButton(tableView, cell)
                cell.configure(phone: phone)
                return cell
            case .username(let username):
                let cell = tableView.dequeue(UsernameCell.self, indexPath: indexPath)
                self?.bindToEditButton(tableView, cell)
                cell.configure(username: username)
                return cell
            case .birthday(let birthday):
                let cell = tableView.dequeue(BirthdayCell.self, indexPath: indexPath)
                self?.bindToEditButton(tableView, cell)
                cell.configure(birthday: birthday)
                return cell
            case .bio(let bio):
                let cell = tableView.dequeue(BioCell.self, indexPath: indexPath)
                self?.bindToEditButton(tableView, cell)
                cell.configure(bio: bio)
                return cell
            }
        }
        
        var snapshot = DataSourceSnapshot()
        snapshot.appendSections([1])
        let user = UserDataModel.mock
        let items: [UserDataItem] = [
            .phone(user.phoneNumber),
            .username(user.userName),
            .birthday(user.birthday),
            .bio(user.bio)
        ]
        snapshot.appendItems(items, toSection: 1)
        dataSource.apply(snapshot)
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
    
    private func bindToEditButton(_ tableView: UITableView, _ cell: UserDataCell) {
        cell.editButton.touchUpInsidePublisher
            .sink {
                tableView.beginUpdates()
                cell.didTapEdit()
                tableView.endUpdates()
            }
            .store(in: &cancelableSet)
    }
    
    func showEditState() {
        var snapshot = dataSource.snapshot()
        snapshot.insertSections([0], beforeSection: 1)
        let user = UserDataModel.mock
        let items: [UserDataItem] = [
            .firstName(user.firstName),
            .lastName(user.lastName)
        ]
        snapshot.appendItems(items, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
