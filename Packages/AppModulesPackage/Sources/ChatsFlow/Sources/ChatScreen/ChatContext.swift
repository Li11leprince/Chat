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
        
        static var stub: ViewState = .initial
    }
}

// MARK: ViewEvent

extension ChatContext {
    enum ViewEvent {
        case viewDidLoad
    }
}

// MARK: OutputEvent

extension ChatContext {
    enum OutputEvent {
        case finish
    }
}


