//
import Foundation

public struct Message {
    let id: String
    let timestamp: Int
    let messageType: MessageType
    let text: String
    let thumb: URL?
    let from: UserProfile
    let isRead: Bool
    let redirectedMessages: [Message]
    let attachments: [Attachment]
    let reactions: [Reaction]
    let replyTo: RepliedToMessage?
    let isChanged: Bool
}

public struct RepliedToMessage {
    let id: String
    let messageType: MessageType
    let text: String
    let from: UserProfile
    let attachments: [Attachment]
}

public struct Reaction: Hashable {
    let emoji: String //unicode symbols
    let count: Int
    let from: [UserProfile]
}

public struct Attachment {
    let type: AttachmentType
    let url: URL
}

public enum MessageType {
    case plainText
    case textWithImageAndVideo
    case audioMessage
    case videoMessage
}

public enum AttachmentType {
    case image
    case video
    case voiceMessage
    case videoMessage
}
