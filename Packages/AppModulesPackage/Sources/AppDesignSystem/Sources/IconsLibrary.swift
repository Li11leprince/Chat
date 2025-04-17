//  Copyright © 2021 My organization. All rights reserved.

import UIKit
import Lottie

public struct IconsLibrary: SafeResource {

    var stub: UIImage { .init() }

    init() {}

    private func valueOrStub(_ image: UIImage?) -> UIImage {
        return image ?? stub
    }
    
    private func lottie(_ name: String) -> LottieAnimationView {
        return LottieAnimationView(name: name, bundle: .module)
    }
}

// MARK: - App Icons

extension IconsLibrary {
    public var homeTabbarChats: UIImage { valueOrStub("home_tabbar_chats") }
    public var homeTabbarSettings: UIImage { valueOrStub("home_tabbar_settings") }
    public var homeTabbarContacts: UIImage { valueOrStub("home_tabbar_contacts") }
    public var appleIcon: UIImage { valueOrStub("apple_icon") }
    public var facebookIcon: UIImage { valueOrStub("facebook_icon") }
    public var googleIcon: UIImage { valueOrStub("google_icon") }
    public var purpleEllipse: UIImage { valueOrStub("purple_ellipse") }
    public var appLogo: UIImage { valueOrStub("chatLogo") }
    public var backButton: UIImage { valueOrStub("back_button_icon") }
    public var crossIcon: UIImage { valueOrStub("cross_icon") }
    public var sendMessageIcon: UIImage { valueOrStub("send_message_icon") }
    
    // MARK: Mocks
    
    public var mockAvatar: UIImage { valueOrStub("mock_avatar") }
}

// MARK: - Backgrounds

extension IconsLibrary {
    public var chatBackground: UIImage { valueOrStub("chat_background")}
    public var chatBackgroundDark: UIImage { valueOrStub("chat_background_dark") }
}

// SFSymbols Example

extension IconsLibrary {
    
    public var plusInCircle: UIImage {
        let configuration = UIImage.SymbolConfiguration(
            weight: .medium
        )
        let image = UIImage(
            systemName: "plus.circle",
            withConfiguration: configuration
        )
        return valueOrStub(image)
    }

    public var chevronRight: UIImage {
        let configuration = UIImage.SymbolConfiguration(weight: .medium)
        let image = UIImage(
            systemName: "chevron.right",
            withConfiguration: configuration
        )
        return valueOrStub(image)
    }
    
    public var person: UIImage {
        let configuration = UIImage.SymbolConfiguration(weight: .medium)
        let image = UIImage(
            systemName: "person.crop.circle",
            withConfiguration: configuration
        )
        return valueOrStub(image)
    }
    
    public var pencil: UIImage {
        let configuration = UIImage.SymbolConfiguration(weight: .medium)
        let image = UIImage(
            systemName: "pencil",
            withConfiguration: configuration
        )
        return valueOrStub(image)
    }
    
    public var checkmark: UIImage {
        let configuration = UIImage.SymbolConfiguration(weight: .medium)
        let image = UIImage(
            systemName: "checkmark",
            withConfiguration: configuration
        )
        return valueOrStub(image)
    }
    
    public var eraser: UIImage {
        let configuration = UIImage.SymbolConfiguration(weight: .medium)
        let image = UIImage(
            systemName: "eraser",
            withConfiguration: configuration
        )
        return valueOrStub(image)
    }
}

// MARK: - Lottie

extension IconsLibrary {
    public var chatsIconLottie: LottieAnimationView { lottie("chat_icon_lottie") }
}
