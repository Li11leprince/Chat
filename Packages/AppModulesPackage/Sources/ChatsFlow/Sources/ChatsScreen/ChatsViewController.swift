//  

import UIKit
import AppBaseFlow

final class ChatsViewController: BaseViewController<ChatsViewModel,
                                 ChatsContext.ViewEvent,
                                 ChatsContext.ViewState,
                                 ChatsContext.ContentView> {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func onViewState(_ viewState: ChatsContext.ViewState) {
        switch viewState {
        case .initial:
            contentView.chatsTableView.dataSource = self
            contentView.chatsTableView.delegate = self
        }
    }
}
