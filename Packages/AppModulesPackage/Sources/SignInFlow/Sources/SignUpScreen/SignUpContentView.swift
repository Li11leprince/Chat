//  

import AppBaseFlow
import UIKit
import SnapKit
import AppDesignSystem

extension SignUpContext {
    
    final class ContentView: BaseView {
        private(set) lazy var backgroundImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = icons.purpleEllipse
            
            return imageView
        }()
        
        private(set) lazy var chatLogoImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = icons.appLogo
            return imageView
        }()
        
        private(set) lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.textColor = colors.labelPrimaryVariant
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            return label
        }()
        
        private(set) lazy var subtitleLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 16, weight: .regular)
            label.textColor = colors.labelSecondaryVariant
            label.numberOfLines = 0
            return label
        }()
        
        private(set) lazy var horizontalStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [
                makeRoundedView(icon: icons.facebookIcon),
                makeRoundedView(icon: icons.googleIcon),
                makeRoundedView(icon: icons.appleIcon)
            ])
            stackView.axis = .horizontal
            stackView.spacing = 20
            return stackView
        }()
        
        private(set) lazy var breakerView: UIView = {
            let view = components.makeBreakerView(
                lineColor: colors.labelSecondaryVariant,
                textColor: colors.labelPrimaryVariant,
                text: strings.commonOr
            )
            return view
        }()
        
        private(set) lazy var signUpWithEmailButton: ActionButton = {
            let button = components.roundedNoDisabledButton
            button.setTitle(strings.signUpWithMail, for: .normal)
            return button
        }()
        
        private(set) lazy var existingAccountLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 14, weight: .regular)
            label.textColor = colors.labelSecondaryVariant
            label.textAlignment = .center
            label.text = strings.signInExistingAccount
            return label
        }()
        
        private(set) lazy var loginButton: ActionButton = {
            let button = components.textButton(textColor: colors.labelPrimaryVariant)
            button.setTitle(strings.signInLogIn, for: .normal)
            button.titleFont = .systemFont(ofSize: 14, weight: .regular)
            button.tintColor = colors.labelPrimaryVariant
            return button
        }()
        
        override func setLayout() {
            setupHierarchy()
            setupContraints()
        }
        
        private func setupHierarchy() {
            addSubview(backgroundImageView)
            addSubview(chatLogoImageView)
            addSubview(titleLabel)
            addSubview(subtitleLabel)
            addSubview(horizontalStackView)
            addSubview(breakerView)
            addSubview(signUpWithEmailButton)
            addSubview(existingAccountLabel)
            addSubview(loginButton)
        }
        
        private func setupContraints() {
            backgroundImageView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview()
            }
            
            chatLogoImageView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().inset(70)
            }
            
            titleLabel.snp.makeConstraints { make in
                make.top.equalTo(chatLogoImageView.snp.bottom).inset(-44)
                make.left.right.equalToSuperview().inset(24)
            }
            
            subtitleLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).inset(-16)
                make.left.equalToSuperview().inset(24)
                make.right.equalToSuperview().inset(67)
            }
            
            horizontalStackView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(subtitleLabel.snp.bottom).inset(-38)
            }
            
            breakerView.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(30)
                make.top.equalTo(horizontalStackView.snp.bottom).inset(-30)
                make.height.equalTo(15)
            }
            
            signUpWithEmailButton.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(24)
                make.top.equalTo(breakerView.snp.bottom).inset(-30)
                make.height.equalTo(48)
            }
            
            existingAccountLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(109)
                make.top.equalTo(signUpWithEmailButton.snp.bottom).inset(-46)
            }
            
            loginButton.snp.makeConstraints { make in
                make.right.equalToSuperview().inset(120)
                make.top.equalTo(signUpWithEmailButton.snp.bottom).inset(-46)
            }
        }
        
        private func makeRoundedView(icon: UIImage) -> UIView {
            components.makeRoundedView(
                bounds: CGRect(origin: .zero, size: .init(width: 48, height: 48)),
                lineColor: colors.labelPrimaryVariant,
                image: icon
            )
        }
    }
}
