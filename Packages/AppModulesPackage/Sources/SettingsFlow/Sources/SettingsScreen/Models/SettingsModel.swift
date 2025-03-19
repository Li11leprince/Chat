//  

import UIKit
import AppDesignSystem

struct SettingModel: Hashable {
    let title: String
    let icon: UIImage?
    let accessoryType: UITableViewCell.AccessoryType
    
    static let myProfile = SettingModel(
        title: strings.settingsMyProfile,
        icon: icons.person,
        accessoryType: .disclosureIndicator
    )
    
    private static let strings: StringsLibrary = {
        appDesignSystem.strings
    }()
    
    private static let icons: IconsLibrary = {
        appDesignSystem.icons
    }()
}

//enum SettingOption {
//    case myProfile(SettingModel)
//}

enum SettingsSection: Int, CaseIterable {
    case account

    var settings: [SettingModel] {
        switch self {
        case .account:
            return [
                SettingModel.myProfile
            ]
        }
    }
}

