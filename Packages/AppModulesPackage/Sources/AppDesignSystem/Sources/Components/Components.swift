//  Copyright © 2021 My organization. All rights reserved.

import UIKit
import TweeTextField
import SafariServices

public struct Components {

    public let loadingViewHelper: LoadingViewHelper = .init()

    private let colors: Colors
    private let icons: IconsLibrary
    private let strings: StringsLibrary
    private let typography: Typography

    init(
        colors: Colors,
        icons: IconsLibrary,
        strings: StringsLibrary,
        typography: Typography
    ) {
        self.colors = colors
        self.icons = icons
        self.strings = strings
        self.typography = typography
    }
}

// MARK: - Tabbar

extension Components {

    public var exploreTabBarItem: UITabBarItem {
        .init(
            title: nil,
            image: icons.homeTabbarExplore,
            tag: 0
        )
    }

    public var storeTabBarItem: UITabBarItem {
        .init(
            title: nil,
            image: icons.homeTabbarStore,
            tag: 1
        )
    }

    public var profileTabBarItem: UITabBarItem {
        .init(
            title: nil,
            image: icons.homeTabbarProfile,
            tag: 2
        )
    }

    public var tabbarStandardAppearance: UITabBarAppearance {
        let appearance = UITabBarAppearance()
        appearance.stackedLayoutAppearance.normal.iconColor = colors.labelPrimary
        appearance.stackedLayoutAppearance.selected.iconColor = colors.backgroundSecondaryVariant
        return appearance
    }
}

// MARK: - Common Components

extension Components {

    // INFO: That component is used only for showing examples for TweeTextField library
    public var tweeAttributedTextField: TweeAttributedTextField {
        .makeExampleInputTextField()
    }

    public var inputTextField: TweeAttributedTextField {
        .makeInputTextField(colors: colors, typography: typography)
    }

    public var primaryActionButton: ActionButton {
        let style = PrimaryActionButtonStyle(colors: colors)

        let actionButton = ActionButton(type: .system)
        actionButton.set(style: style)

        return actionButton
    }

    public func textButton(textColor: UIColor, disabledTextColor: UIColor? = nil) -> ActionButton {
        let style = TextButtonStyle(
            textColor: textColor,
            disabledTextColor: disabledTextColor == nil ? textColor : disabledTextColor!,
            typography: typography
        )

        let textButton = ActionButton(type: .system)
        textButton.set(style: style)
        
        return textButton
    }

    public var completedActionCaptionButton: ActionButton {
        let style = CompletedActionButtonStyle(colors: colors)

        let button = ActionButton(type: .system)
        button.setWithCaption(style: style, typography: typography)

        return button
    }

    public var borderedCaptionButton: ActionButton {
        let style = BorderedButtonStyle(colors: colors)

        let button = ActionButton(type: .system)
        button.setWithCaption(style: style, typography: typography)

        return button
    }

    public var filledActionCaptionButton: ActionButton {
        let style = FilledActionStyle(colors: colors)

        let button = ActionButton(type: .system)
        button.setWithCaption(style: style, typography: typography)

        return button
    }

    public var disableBorderedCaptionButton: ActionButton {
        let style = DisableBorderedStyle(colors: colors)

        let button = ActionButton(type: .system)
        button.setWithCaption(style: style, typography: typography)

        return button
    }
    
    public var roundedNoDisabledButton: ActionButton {
        let style = RoundedNoDisabledStyle(colors: colors, cornerRadius: 16)

        let button = ActionButton(type: .system)
        button.set(style: style)

        return button
    }
    
    public var roundedWithDisabledButton: ActionButton {
        let style = RoundedWithDisabledStyle(colors: colors, cornerRadius: 16)

        let button = ActionButton(type: .system)
        button.set(style: style)

        return button
    }

    public var roundedImageView: RoundedImageView {
        let imageView = RoundedImageView()
        imageView.setup(colors: colors, typography: typography)

        return imageView
    }
    
    public var namedAvatarImageView: NamedAvatarImageView {
        let imageView = NamedAvatarImageView()
        imageView.setup(colors: colors, typography: typography)

        return imageView
    }

    public var namedSmallAvatarImageView: NamedAvatarImageView {
        let imageView = NamedAvatarImageView()
        imageView.setup(colors: colors, typography: typography)
        imageView.font = typography.caption1

        return imageView
    }
    
    public func badgeActionButton(cornerRadius: CGFloat) -> ActionButton {
        let baseStyle = ContentActionButtonStyle(
            interItemSpacing: 8, cornerRadius: cornerRadius
        )
        let style = BadgeActionStyle(
            parentStyle: baseStyle, colors: colors
        )

        let button = ActionButton(type: .system)
        button.set(style: style)
        
        button.titleFont = typography.caption1

        return button
    }
    
    public func makeRoundedView(bounds: CGRect, lineColor: UIColor, image: UIImage) -> UIView {
        let view = RoundedView()
        view.bounds = bounds
        view.setup(color: lineColor, image: image)
        return view
    }
    
    public func makeBreakerView(lineColor: UIColor, textColor: UIColor, text: String) -> UIView {
        let view = BreakerView()
        view.setup(lineColor: lineColor, textColor: textColor, text: text)
        return view
    }

    public func makeInAppBrowserViewController(for url: URL) -> UIViewController {
        let viewController = SFSafariViewController(url: url)
        viewController.dismissButtonStyle = .close
        return viewController
    }
}
