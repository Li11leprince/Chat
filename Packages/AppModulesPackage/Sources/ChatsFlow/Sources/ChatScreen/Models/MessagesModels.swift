//  

import Foundation
import AppEntities


enum MessageType: Hashable {
    case plainText
    case circleVideo(VideoMessageModel)
}

struct MessageCellModel: Hashable {
    let isMe: Bool
    let id: String
    let time: String
    let text: String
    let from: UserProfile
    let isRead: Bool
    let reactions: [Reaction]
    let isChanged: Bool
    let replyTo: RepliedMessage?
    let messageType: MessageType
    
    static var mock: [MessageCellModel] = {
        var data: [MessageCellModel] = []
        for i in 0...10 {
            data.append(MessageCellModel(
                isMe: true,
                id: String(i),
                time: "12:05",
                text: String("Text\(i)"),
                from: .init(id: "fds", phoneNumber: "fsd", firstName: "Anna", lastName: "Ivanova", displayName: "Anna Ivanova", bio: "fsd", birthday: 4234, avatar: "fsd"),
                isRead: true,
                reactions: [],
                isChanged: false,
                replyTo: nil,
                messageType: .plainText
            ))
        }
        return data
    }()
}

struct UserModel: Hashable {
    let id: String
    let name: String
}

struct VideoMessageModel: Hashable {
    let videoURL: URL
    let thumbnailURL: URL?
    let duration: String
}
