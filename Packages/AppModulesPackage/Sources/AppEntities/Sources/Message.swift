//
import Foundation

public struct Message: Hashable {
    public let id: String
    public let timestamp: Int
    public let messageType: MessageType
    public let text: String
    public let thumb: URL?
    public let from: UserProfile?
    public let isRead: Bool
    public let redirectedMessages: [Message]
    public let attachments: [Attachment]
    public let reactions: [Reaction]
    public let replyTo: RepliedToMessage?
    public let isChanged: Bool
    
    public init(id: String, timestamp: Int, messageType: MessageType, text: String, thumb: URL?, from: UserProfile?, isRead: Bool, redirectedMessages: [Message], attachments: [Attachment], reactions: [Reaction], replyTo: RepliedToMessage?, isChanged: Bool) {
        self.id = id
        self.timestamp = timestamp
        self.messageType = messageType
        self.text = text
        self.thumb = thumb
        self.from = from
        self.isRead = isRead
        self.redirectedMessages = redirectedMessages
        self.attachments = attachments
        self.reactions = reactions
        self.replyTo = replyTo
        self.isChanged = isChanged
    }
}

public struct RepliedToMessage: Hashable {
    public let id: String
    public let messageType: MessageType
    public let text: String
    public let from: UserProfile
    public let attachments: [Attachment]
}

public struct Reaction: Hashable {
    public let emoji: String //unicode symbols
    public let count: Int
    public let from: [UserProfile]
}

public struct Attachment: Hashable {
    public let type: AttachmentType
    public let url: URL
}

public enum MessageType: Hashable {
    case plainText
    case textWithImageAndVideo
    case audioMessage
    case videoMessage
}

public enum AttachmentType: Hashable {
    case image
    case video
    case voiceMessage
    case videoMessage
}
