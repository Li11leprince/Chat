//  
import UIKit
import AppDesignSystem

struct ChatModel {
    let avatar: UIImage
    let name: String
    let message: String
    let time: String
    let unreadCount: Int
    let isOnline: Bool
    let isRead: Bool?
    
    static let mock = ChatModel(
        avatar: appDesignSystem.icons.mockAvatar,
        name: "Анечка❤️",
        message: "Люблю тебя!",
        time: "18:42",
        unreadCount: 182,
        isOnline: true,
        isRead: true
    )
}
