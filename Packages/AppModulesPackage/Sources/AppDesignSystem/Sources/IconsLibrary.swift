//  Copyright © 2021 My organization. All rights reserved.

import UIKit

public struct IconsLibrary: SafeResource {

    var stub: UIImage { .init() }

    init() {}

    private func valueOrStub(_ image: UIImage?) -> UIImage {
        return image ?? stub
    }
}

// MARK: - App Icons

extension IconsLibrary {
    public var homeTabbarExplore: UIImage { valueOrStub("home_tabbar_explore") }
    public var homeTabbarStore: UIImage { valueOrStub("home_tabbar_store") }
    public var homeTabbarProfile: UIImage { valueOrStub("home_tabbar_profile") }
    public var appleIcon: UIImage { valueOrStub("apple_icon") }
    public var facebookIcon: UIImage { valueOrStub("facebook_icon") }
    public var googleIcon: UIImage { valueOrStub("google_icon") }
    public var purpleEllipse: UIImage { valueOrStub("purple_ellipse") }
    public var appLogo: UIImage { valueOrStub("chatLogo") }
    public var backButton: UIImage { valueOrStub("back_button_icon") }
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
}
