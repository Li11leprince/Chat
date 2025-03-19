//  

import UIKit
import AppDesignSystem

struct UserDataModel: Hashable {
    let firstName: String
    let lastName: String
    let userName: String
    let phoneNumber: String
    let avatarImage: UIImage?
    let birthday: String
    let bio: String
    
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

enum UserDataItem: Hashable {
    case firstName(String)
    case lastName(String)
    case phone(String)
    case username(String)
    case birthday(String)
    case bio(String)
}
