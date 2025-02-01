//  

import Foundation
import AppBaseFlow

struct ChatsContext {
    private init() {}
}

// MARK: ViewState

extension ChatsContext {
    enum ViewState: Stubable {
        case initial
        
        static var stub: ViewState = .initial
    }
}

// MARK: ViewEvent

extension ChatsContext {
    enum ViewEvent {
        case viewDidLoad
    }
}

// MARK: OutputEvent

extension ChatsContext {
    enum OutputEvent {
        case finish
    }
}


