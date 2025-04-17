//  

import UIKit
import AppDesignSystem

struct UserDataModel: Hashable {
    var firstName: String
    var lastName: String
    var userName: String
    var phoneNumber: String
    var avatarImage: UIImage?
    var birthday: String
    var bio: String
    
    static let mock = UserDataModel(
        firstName: "Анна",
        lastName: "Иванова",
        userName: "@Anka",
        phoneNumber: "+7 983 653 6578",
        avatarImage: appDesignSystem.icons.mockAvatar,
        birthday: "18.03.2000",
        bio: "Студент медицинского университета"
    )
}

struct UserDataItem: Hashable {
    var type: InfoType
    var value: String
    var image: UIImage?
}

enum InfoType: Hashable {
    case firstName
    case lastName
    case phone
    case username
    case avatar
    case birthday
    case bio
}
