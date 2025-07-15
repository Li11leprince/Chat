//  

import UIKit
import AppBaseFlow
import AppEntities
import AppServices
import Combine

final class ChatViewModel: BaseViewModel<ChatContext.ViewEvent,
                            ChatContext.ViewState,
                            ChatContext.OutputEvent> {
    @Injected(\.dateFormatter) var dateFormatter
    
    private var replyTo: RepliedMessage?
    let videoRecordingManager = VideoRecordingManager()
    
    override init() {
        super.init()
        setupVideoRecording()
    }
    
    private func setupVideoRecording() {
        videoRecordingManager.videoRecordedPublisher
            .sink { [weak self] videoURL in
                self?.handleRecordedVideo(url: videoURL)
            }
            .store(in: &cancelableSet)
    }
    
    private func handleRecordedVideo(url: URL) {
        let message = Message(
            id: String(describing: UUID()),
            timestamp: Date().timeIntervalSince1970,
            messageType: .video,
            text: "",
            thumb: nil,
            from: .init(id: "fsd", phoneNumber: "fsd", firstName: "Anna", lastName: "Ivanova", displayName: "Anna Ivanova", bio: "fsd", birthday: 423, avatar: "fds"),
            isRead: false,
            redirectedMessages: [],
            attachments: [.init(type: .video, url: url)],
            reactions: [],
            replyTo: replyTo,
            isChanged: false
        )
        viewState = .newMessages(mapToMessageCellModels(messages: [message]))
        replyTo = nil
    }
    
    override func onViewEvent(_ event: ChatContext.ViewEvent) {
        switch event {
        case .viewDidLoad:
            print("f")
        case .messageButtonClicked(let message):
            sendMessage(message)
        case .replyTo(let repliedMessage):
            replyTo = mapToRepliedMessage(repliedMessage)
        case .startVideoRecording:
            videoRecordingManager.startSession()
        case .stopVideoRecording:
            videoRecordingManager.stopSession()
        }
    }
    
    private func sendMessage(_ message: String) {
        let trimmedMessage = message.trimmingCharacters(in: .whitespacesAndNewlines)
        let message = Message(id: String(describing: UUID()), timestamp: Date().timeIntervalSince1970, messageType: .plainText, text: trimmedMessage, thumb: nil, from: .init(id: "fsd", phoneNumber: "fsd", firstName: "Anna", lastName: "Ivanova", displayName: "Anna Ivanova", bio: "fsd", birthday: 423, avatar: "fds"), isRead: false, redirectedMessages: [], attachments: [], reactions: [], replyTo: replyTo, isChanged: false)
        viewState = .newMessages(mapToMessageCellModels(messages: [message]))
        replyTo = nil
    }
    
    private func mapToMessageCellModels(messages: [Message]) -> [MessageCellModel] {
        return messages.compactMap { message in
            switch message.messageType {
//            case .textWithImageAndVideo:
//                return
//            case .audioMessage:
//                return nil
            case .video:
                return MessageCellModel(
                    isMe: true,
                    id: message.id,
                    time: dateFormatter.formatTime(from: message.timestamp),
                    text: message.text,
                    from: message.from,
                    isRead: message.isRead,
                    reactions: message.reactions,
                    isChanged: message.isChanged,
                    replyTo: message.replyTo,
                    messageType: .circleVideo(.init(
                        videoURL: message.attachments.first!.url,
                        thumbnailURL: nil,
                        duration: dateFormatter.formatTime(from: 30.0))
                    )
                )
            default:
                return MessageCellModel(
                    isMe: true,
                    id: message.id,
                    time: dateFormatter.formatTime(from: message.timestamp),
                    text: message.text,
                    from: message.from,
                    isRead: message.isRead,
                    reactions: message.reactions,
                    isChanged: message.isChanged,
                    replyTo: message.replyTo,
                    messageType: .plainText
                )
            }
        }
    }
    
    private func mapToRepliedMessage(_ message: MessageCellModel?) -> RepliedMessage? {
        guard let message else {
            return nil
        }
        switch message.messageType {
        case .plainText:
            return RepliedMessage(
                id: message.id,
                messageType: .plainText,
                text: message.text,
                from: message.from,
                attachments: []
            )
        default:
            return nil
        }
    }
    
    private func handleVideoRecorded(_ url: URL) {
        let message = Message(id: UUID().uuidString, timestamp: Date().timeIntervalSince1970, messageType: .video, text: "", thumb: nil, from: .init(id: "fsd", phoneNumber: "fsd", firstName: "Anna", lastName: "Ivanova", displayName: "Anna Ivanova", bio: "fsd", birthday: 423, avatar: "fds"), isRead: false, redirectedMessages: [], attachments: [.init(type: .video, url: url)], reactions: [], replyTo: replyTo, isChanged: false)
        
        viewState = .newMessages(mapToMessageCellModels(messages: [message]))
    }
}
