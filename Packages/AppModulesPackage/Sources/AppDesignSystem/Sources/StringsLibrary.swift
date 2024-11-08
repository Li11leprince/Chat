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

    // MARK: - Common Errors

    public var commonError: String { localized("common_error") }
    public var commonUnexpectedError: String { localized("common_unexpected_error") }
    public var commonAuthErrorTitle: String { localized("common_auth_error_title") }
    public var commonAuthErrorMessage: String { localized("common_auth_error_message") }
    public var commonLoading: String { localized("common_loading") }

    public var commonErrorNetwork: String { localized("common_error_network") }

    // MARK: - Welcome

    public var welcomeTermsServicePrivacyPolicy: String { localized("welcome_terms_service_privacy_policy") }
    public var welcomeTermsService: String { localized("welcome_terms_service") }
    public var welcomePrivacyPolicy: String { localized("welcome_privacy_policy") }

    // MARK: - Sign In

    public func signInWeSentCodeTo(formattedPhoneNumber: String) -> String {
        formatted(
            localized("sign_in_we_sent_code_to"),
            arg: formattedPhoneNumber
        )
    }
    public var signInVerifyContentTitle: String { localized("sign_in_verify_content_title") }
    public var signInVerifyPlaceholder: String { localized("sign_in_verify_placeholder") }
    public var signInResentButtonActive: String { localized("sign_in_resent_button_active") }
    public func signInResentButtonDisable(formattedTimer: String) -> String {
        formatted(
            localized("sign_in_resent_button_disable"),
            arg: formattedTimer
        )
    }

    public var signInPhoneContentTitle: String { localized("sign_in_phone_content_title") }
    public var signInPhoneCaption: String { localized("sign_in_phone_caption") }

    public var signInErrorSmsCodeIsInvalid: String { localized("sign_in_error_sms_code_is_invalid")
    }
    public var signInErrorSmsCodeExpired: String {
        localized("sign_in_error_sms_code_expired")
    }
    public func signInErrorExceedLimitSmsCode(seconds: String) -> String {
        formatted(
            localized("sign_in_error_exceed_limit_sms_code"),
            arg: seconds
        )
    }
}
