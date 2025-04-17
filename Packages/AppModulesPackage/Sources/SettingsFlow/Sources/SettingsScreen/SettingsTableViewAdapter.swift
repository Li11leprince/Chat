import UIKit
import AppBaseFlow

extension SettingsViewController: TableViewAdaptable {
    
    typealias Section = SettingsSection
    
    typealias Item = SettingModel
    
    typealias ViewModel = SettingsViewModel
    
    func registerCells(in tableView: UITableView) {
        tableView.register(SettingCell.self)
    }
    
    func setDataSource(in tableView: UITableView) {
        dataSource = UITableViewDiffableDataSource<Section, Item>(tableView: tableView) { tableView, indexPath, model in
            let cell = tableView.dequeue(SettingCell.self, indexPath: indexPath)
            cell.configure(model: model)
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(SettingsSection.allCases)
        for section in SettingsSection.allCases {
            snapshot.appendItems(section.settings, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        SettingsSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SettingsSection.allCases[section].settings.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let setting = SettingsSection.allCases[indexPath.section].settings[indexPath.row]
        viewModel.onViewEvent(.settingPressed(setting))
    }
}
