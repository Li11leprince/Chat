//  Copyright © 2021 My organization. All rights reserved.

import Foundation

// MARK: - Account

public struct Account: Codable {

    public let alreadyRegistered: Bool
    public let profile: Profile
    public let settings: Settings

    public init(
        alreadyRegistered: Bool,
        profile: Profile,
        settings: Settings
    ) {
        self.alreadyRegistered = alreadyRegistered
        self.profile = profile
        self.settings = settings
    }

    public static var stub: Account {
        .init(
            alreadyRegistered: false,
            profile: .stub,
            settings: .init(mute: false)
        )
    }
}

extension Account {

    public struct Settings: Codable {
        public let mute: Bool

        public init(mute: Bool) {
            self.mute = mute
        }
    }

    public struct Profile: Codable {
        public let id: String
        public let createdAt: Date
        public let updatedAt: Date
        public let firstName: String
        public let lastName: String
        public let userName: String
        public let phoneNumber: String
        public let avatarImage: Image?
        public let bio: String

        public init(
            id: String,
            createdAt: Date,
            updatedAt: Date,
            firstName: String,
            lastName: String,
            userName: String,
            phoneNumber: String,
            avatarImage: Image?,
            bio: String
        ) {
            self.id = id
            self.createdAt = createdAt
            self.updatedAt = updatedAt
            self.firstName = firstName
            self.lastName = lastName
            self.userName = userName
            self.phoneNumber = phoneNumber
            self.avatarImage = avatarImage
            self.bio = bio
        }

        public static var stub: Profile {
            .init(
                id: "",
                createdAt: Date(),
                updatedAt: Date(),
                firstName: "",
                lastName: "",
                userName: "",
                phoneNumber: "",
                avatarImage: nil,
                bio: ""
            )
        }
    }
}

// MARK: - Credentials

public struct Credentials: Codable {
    public let accessToken: String

    public init(accessToken: String) {
        self.accessToken = accessToken
    }
}
