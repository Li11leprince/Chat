//  Copyright © 2021 My organization. All rights reserved.

import Foundation

public struct StringsLibrary {

    // MARK: - Init
    
    init() {}

    private func localized(_ name: String) -> String {
        NSLocalizedString(name, bundle: .module, comment: "")
    }

    private func formatted(_ localizedString: String, arg: String) -> String {
        String(format: localizedString, arg)
    }
}

// MARK: - App Strings

extension StringsLibrary {

    // MARK: - Common

    public var commonOk: String { localized("common_ok") }
    public var commonSignIn: String { localized("common_sign_in") }
    public var commonPhoneNumber: String { localized("common_phone_number") }
    public var commonContinue: String { localized("common_continue") }
    public var commonChange: String { localized("common_change") }
    public var commonNext: String { localized("common_next") }
    public var commonCancel: String { localized("common_cancel") }
    public var commonClose: String { localized("common_close") }
    public var commonSettings: String { localized("common_settings") }
    public var commonConfirmation: String { localized("common_confirmation") }
    public var commonDone: String { localized("common_done") }
    public var commonOpenSettings: String { localized("common_use_open_settings") }
    public var commonOr: String { localized("common_or") }

    // MARK: - Common Errors

    public var commonError: String { localized("common_error") }
    public var commonUnexpectedError: String { localized("common_unexpected_error") }
    public var commonAuthErrorTitle: String { localized("common_auth_error_title") }
    public var commonAuthErrorMessage: String { localized("common_auth_error_message") }
    public var commonLoading: String { localized("common_loading") }

    public var commonErrorNetwork: String { localized("common_error_network") }

    // MARK: - Sign In
    public var signUpWithMail: String { localized("sign_in_sign_up_with_email") }
    public var signInOurChatAppIsPerfect: String { localized("sign_in_our_chat_is_perfect_way") }
    public var signInConnectFriends: String { localized("sign_in_connect_friends") }
    public var signInEasyAndQuickly: String { localized("sign_in_easily_quickly") }
    public var signInExistingAccount: String { localized("sign_in_existing_account") }
    public var signInLogIn: String { localized("sign_in_log_in") }
    public var signInGetChattingWithFriends: String { localized("sign_in_get_chatting_with_friends") }
    public var signInYourName: String { localized("sign_in_your_name") }
    public var signInYourEmail: String { localized("sign_in_your_email") }
    public var signInPassword: String { localized("sign_in_password") }
    public var signInConfirmPassword: String { localized("sign_in_confirm_password") }
    public var signInCreateAccount: String { localized("sign_in_create_account") }
    public var signInInvalidName: String { localized("sign_in_invalid_name") }
    public var signInInvalidEmail: String { localized("sign_in_invalid_email") }
    public func signInInvalidPassword(minLength: String) -> String {
        formatted(
            localized("sign_in_invalid_password"),
            arg: minLength
        )
    }
    public var signInInvalidConfirmPassword: String { localized("sign_in_invalid_confirm_password") }
    public var signInLoginToChatbox: String { localized("sign_in_login_to_chatbox") }
    public var signInWelcomeBack: String { localized("sign_in_welcome_back") }
    public var signInLogin: String { localized("sign_in_login") }
    public var signInForgotPassword: String { localized("sign_in_forgot_password") }
    
    
    // MARK: - Chats

    public var chatsChats: String { localized("chats_chats") }
    
    
    // MARK: - Settings

    public var settignsSettings: String { localized("settings_settings") }
    
    
    // MARK: - Contacts

    public var contactsContacts: String { localized("contacts_contacts") }
}
