import UIKit
import AppBaseFlow

final class SettingsViewController: BaseViewController<SettingsViewModel,
                                                    SettingsContext.ViewEvent,
                                                    SettingsContext.ViewState,
                                                    SettingsContext.ContentView> {
    
    var dataSource: UITableViewDiffableDataSource<Section, Item>!
    
    private var tableView: UITableView { contentView.tableView }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onViewEvent(.viewDidLoad)
        bindActions()
        registerCells(in: tableView)
        setDataSource(in: tableView)
    }

    override func onViewState(_ viewState: SettingsContext.ViewState) {
        switch viewState {
        case .initial:
            tableView.delegate = self
        }
    }
    
    private func bindActions() {
        
    }
}
