//  Copyright © 2021 My organization. All rights reserved.

import Foundation

// MARK: - Account

public struct Account: Codable {

    public let alreadyRegistered: Bool
    public let profile: UserProfile
    public let settings: Settings

    public init(
        alreadyRegistered: Bool,
        profile: UserProfile,
        settings: Settings
    ) {
        self.alreadyRegistered = alreadyRegistered
        self.profile = profile
        self.settings = settings
    }

//    public static var stub: Account {
//        .init(
//            alreadyRegistered: false,
//            profile: .stub,
//            settings: .init()
//        )
//    }
}

extension Account {

    public struct Settings: Codable {
//        public let mute: Bool

//        public init(mute: Bool) {
//            self.mute = mute
//        }
    }

}

// MARK: - Credentials

public struct Credentials: Codable {
    public let accessToken: String

    public init(accessToken: String) {
        self.accessToken = accessToken
    }
}
