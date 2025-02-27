//  

import UIKit
import AppBaseFlow

final class ChatViewModel: BaseViewModel<ChatContext.ViewEvent,
                            ChatContext.ViewState,
                            ChatContext.OutputEvent> {
    override func onViewEvent(_ event: ChatContext.ViewEvent) {
        switch event {
        case .viewDidLoad:
            print("f")
        case .messageButtonClicked(let message):
            sendMessage(message)
        }
    }
    
    private func sendMessage(_ message: String) {
        let trimmedMessage = message.trimmingCharacters(in: .whitespacesAndNewlines)
        viewState = .newMessage(trimmedMessage)
    }
}
