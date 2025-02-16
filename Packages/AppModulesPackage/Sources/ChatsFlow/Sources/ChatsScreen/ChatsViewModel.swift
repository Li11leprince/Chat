//  

import UIKit
import AppBaseFlow

final class ChatsViewModel: BaseViewModel<ChatsContext.ViewEvent,
                            ChatsContext.ViewState,
                            ChatsContext.OutputEvent> {
    
    override func onViewEvent(_ event: ChatsContext.ViewEvent) {
        switch event {
        case .viewDidLoad:
            print("fsd")
        case .chatPressed(id: let id):
            outputEventSubject.send(.chat(id: id))
        }
    }
}
