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
        case newMessages([MessageCellModel])
        
        static var stub: ViewState = .initial
    }
}

// MARK: ViewEvent

extension ChatContext {
    enum ViewEvent {
        case viewDidLoad
        case messageButtonClicked(String)
        case replyTo(MessageCellModel?)
        case startVideoRecording
        case stopVideoRecording
    }
}

// MARK: OutputEvent

extension ChatContext {
    enum OutputEvent {
        case finish
    }
}


