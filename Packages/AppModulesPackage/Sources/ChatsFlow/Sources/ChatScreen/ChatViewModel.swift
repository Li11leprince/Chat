//  

import UIKit
import AppBaseFlow
import AppEntities
import AppServices

final class ChatViewModel: BaseViewModel<ChatContext.ViewEvent,
                            ChatContext.ViewState,
                            ChatContext.OutputEvent> {
    @Injected(\.dateFormatter) var dateFormatter
    
    private var replyTo: RepliedMessage?
    
    override func onViewEvent(_ event: ChatContext.ViewEvent) {
        switch event {
        case .viewDidLoad:
            print("f")
        case .messageButtonClicked(let message):
            sendMessage(message)
        case .replyTo(let repliedMessage):
            replyTo = mapToRepliedMessage(repliedMessage)
        }
    }
    
    private func sendMessage(_ message: String) {
        let trimmedMessage = message.trimmingCharacters(in: .whitespacesAndNewlines)
        let message = Message(id: String(describing: UUID()), timestamp: Date().timeIntervalSince1970, messageType: .plainText, text: trimmedMessage, thumb: nil, from: .init(id: "fsd", role: "fsd", phoneNumber: "fsd", firstName: "Anna", lastName: "Ivanova", displayName: "Anna Ivanova", smallAvatar: nil, mediumAvatar: nil, originalAvatar: nil), isRead: false, redirectedMessages: [], attachments: [], reactions: [], replyTo: replyTo, isChanged: false)
        viewState = .newMessages(mapToMessageCellModels(messages: [message]))
        replyTo = nil
    }
    
    private func mapToMessageCellModels(messages: [Message]) -> [MessageCellModel] {
        return messages.compactMap { message in
            switch message.messageType {
            case .plainText:
                return .plainText(TextMessageCellModel(
                    isMe: true,
                    id: message.id,
                    time: dateFormatter.formatTime(from: message.timestamp),
                    text: message.text,
                    from: message.from,
                    isRead: message.isRead,
                    reactions: message.reactions,
                    isChanged: message.isChanged,
                    replyTo: message.replyTo
                ))
            case .textWithImageAndVideo:
                return nil
            case .audioMessage:
                return nil
            case .videoMessage:
                return nil
            }
        }
    }
    
    private func mapToRepliedMessage(_ message: MessageCellModel?) -> RepliedMessage? {
        switch message {
        case .plainText(let model):
            return RepliedMessage(
                id: model.id,
                messageType: .plainText,
                text: model.text,
                from: model.from,
                attachments: []
            )
        default:
            return nil
        }
    }
}
