//  

import UIKit
import AppBaseFlow
import SnapKit
import AppDesignSystem
import TweeTextField

extension SignInContext {
    final class ContentView: BaseView {
        private(set) lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 18, weight: .bold)
            label.textColor = colors.labelPrimary
            label.text = strings.signInLoginToChatbox
            return label
        }()
        
        private(set) lazy var subTitleLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 14, weight: .medium)
            label.textColor = colors.labelSecondary
            label.text = strings.signInWelcomeBack
            label.textAlignment = .center
            label.numberOfLines = 0
            return label
        }()
        
        private(set) lazy var horizontalStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [
                makeRoundedView(icon: icons.facebookIcon),
                makeRoundedView(icon: icons.googleIcon),
                makeRoundedView(icon: icons.appleIcon.withTintColor(colors.labelPrimary))
            ])
            stackView.axis = .horizontal
            stackView.spacing = 20
            return stackView
        }()
        
        private(set) lazy var breakerView: UIView = {
            let view = components.makeBreakerView(
                lineColor: colors.labelSecondaryVariant,
                textColor: colors.labelSecondaryVariant,
                text: strings.commonOr
            )
            return view
        }()
        
        private(set) lazy var emailTextField: TweeAttributedTextField = {
            let tf = components.inputTextField
            tf.tweePlaceholder = strings.signInYourEmail
            return tf
        }()
        
        private(set) lazy var passwordTextField: TweeAttributedTextField = {
            let tf = components.inputTextField
            tf.tweePlaceholder = strings.signInPassword
            tf.isSecureTextEntry = true
            return tf
        }()
        
        private(set) lazy var verticalStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
            stackView.axis = .vertical
            stackView.spacing = 60
            return stackView
        }()
        
        private(set) lazy var logInButton: ActionButton = {
            let button = components.roundedWithDisabledButton
            button.setTitle(strings.signInLogin, for: .normal)
            button.isEnabled = false
            return button
        }()
        
        private(set) lazy var forgotPasswordButton: ActionButton = {
            let button = components.textButton(textColor: colors.labelTertiary)
            button.setTitle(strings.signInForgotPassword, for: .normal)
            return button
        }()
        
        override func setLayout() {
            backgroundColor = colors.backgroundPrimary
            setupHierarchy()
            setupConstraints()
        }
        
        private func setupHierarchy() {
            addSubview(titleLabel)
            addSubview(subTitleLabel)
            addSubview(horizontalStackView)
            addSubview(breakerView)
            addSubview(verticalStackView)
            addSubview(logInButton)
            addSubview(forgotPasswordButton)
        }
        
        private func setupConstraints() {
            titleLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(145)
                make.centerX.equalToSuperview()
            }
            
            subTitleLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(17)
                make.centerX.equalToSuperview()
                make.leading.equalToSuperview().offset(31)
                make.trailing.equalToSuperview().offset(-31)
            }
            
            horizontalStackView.snp.makeConstraints { make in
                make.top.equalTo(subTitleLabel.snp.bottom).offset(32)
                make.centerX.equalToSuperview()
            }
            
            breakerView.snp.makeConstraints { make in
                make.top.equalTo(horizontalStackView.snp.bottom).offset(30)
                make.leading.trailing.equalToSuperview().inset(30)
            }
            
            verticalStackView.snp.makeConstraints { make in
                make.top.equalTo(breakerView.snp.bottom).offset(60)
                make.leading.trailing.equalToSuperview().inset(24)
            }
            
            logInButton.snp.makeConstraints { make in
                make.bottom.equalTo(forgotPasswordButton.snp.top).inset(-16)
                make.leading.trailing.equalToSuperview().inset(24)
                make.height.equalTo(48)
            }

            forgotPasswordButton.snp.makeConstraints { make in
                make.bottom.equalToSuperview().inset(40)
                make.centerX.equalToSuperview()
            }
        }
        
        private func makeRoundedView(icon: UIImage) -> UIView {
            components.makeRoundedView(
                bounds: CGRect(origin: .zero, size: .init(width: 48, height: 48)),
                lineColor: colors.labelPrimary,
                image: icon
            )
        }
    }
}
