//  

import AppBaseFlow
import UIKit
import SnapKit
import AppDesignSystem
import TweeTextField

extension SignUpWithEmailContext {
    final class ContentView: BaseView {
        private(set) lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 18, weight: .bold)
            label.textColor = colors.labelPrimary
            label.text = strings.signUpWithMail
            return label
        }()
        
        private(set) lazy var subTitleLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 14, weight: .medium)
            label.textColor = colors.labelSecondary
            label.text = strings.signInGetChattingWithFriends
            label.textAlignment = .center
            label.numberOfLines = 0
            return label
        }()
        
        private(set) lazy var nameTextField: TweeAttributedTextField = {
            let tf = components.inputTextField
            tf.tweePlaceholder = strings.signInYourName
            return tf
        }()
        
        private(set) lazy var emailTextField: TweeAttributedTextField = {
            let tf = components.inputTextField
            tf.tweePlaceholder = strings.signInYourEmail
            return tf
        }()
        
        private(set) lazy var passwordTextField: TweeAttributedTextField = {
            let tf = components.inputTextField
            tf.isSecureTextEntry = true
            tf.tweePlaceholder = strings.signInPassword
            return tf
        }()
        
        private(set) lazy var confirmPasswordTextField: TweeAttributedTextField = {
            let tf = components.inputTextField
            tf.isSecureTextEntry = true
            tf.tweePlaceholder = strings.signInConfirmPassword
            return tf
        }()
        
        private(set) lazy var verticalStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [nameTextField, emailTextField, passwordTextField, confirmPasswordTextField])
            stackView.axis = .vertical
            stackView.spacing = 60
            return stackView
        }()
        
        private(set) lazy var showPasswordButton: ActionButton = {
            let button = components.primaryActionButton
            let image = UIImage(systemName: "eye")
            button.setImage(image, for: .normal)
            button.imageView?.tintColor = colors.labelSecondary
            return button
        }()
        
        private(set) lazy var signUpButton: ActionButtonWithLoader = {
            let button = components.roundedWithDisabledButton
            button.setTitle(strings.signInCreateAccount, for: .normal)
            button.isEnabled = false
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
            addSubview(verticalStackView)
            addSubview(signUpButton)
            addSubview(showPasswordButton)
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
            
            verticalStackView.snp.makeConstraints { make in
                make.top.equalTo(subTitleLabel.snp.bottom).offset(60)
                make.leading.equalToSuperview().offset(24)
                make.trailing.equalToSuperview().offset(-24)
            }
            
            showPasswordButton.snp.makeConstraints { make in
                make.bottom.equalTo(passwordTextField.snp.bottom).inset(4)
                make.trailing.equalTo(passwordTextField.snp.trailing).inset(4)
            }
            
            signUpButton.snp.makeConstraints { make in
                make.bottom.equalToSuperview().inset(40)
                make.leading.equalToSuperview().offset(24)
                make.trailing.equalToSuperview().offset(-24)
                make.height.equalTo(48)
            }
        }
    }
}
