//  

import Foundation
import AppEntities


enum MessageCellModel: Hashable {
    case plainText(TextMessageCellModel)
}

struct TextMessageCellModel: Hashable {
    let isMe: Bool
    let id: String
    let time: String
    let text: String
    let from: UserProfile
    let isRead: Bool
    let reactions: [Reaction]
    let isChanged: Bool
    let replyTo: RepliedMessage?
    
    static var mock: [TextMessageCellModel] = {
        var data: [TextMessageCellModel] = []
        for i in 0...10 {
            data.append(TextMessageCellModel(
                isMe: true,
                id: String(i),
                time: "12:05",
                text: String("Text\(i)"),
                from: .init(id: "fds", phoneNumber: "fsd", firstName: "Anna", lastName: "Ivanova", displayName: "Anna Ivanova", bio: "fsd", birthday: 4234, avatar: "fsd"),
                isRead: true,
                reactions: [],
                isChanged: false,
                replyTo: nil
            ))
        }
        return data
    }()
}

struct UserModel: Hashable {
    let id: String
    let name: String
}
