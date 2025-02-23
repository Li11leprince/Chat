//

import Foundation
import AppBaseFlow

struct ChatContext {
    private init() {}
}

// MARK: ViewState

extension ChatContext {
    enum ViewState: Stubable {
        case initial
        case newMessage(String)
        
        static var stub: ViewState = .initial
    }
}

// MARK: ViewEvent

extension ChatContext {
    enum ViewEvent {
        case viewDidLoad
        case messageButtonClicked(String)
    }
}

// MARK: OutputEvent

extension ChatContext {
    enum OutputEvent {
        case finish
    }
}


