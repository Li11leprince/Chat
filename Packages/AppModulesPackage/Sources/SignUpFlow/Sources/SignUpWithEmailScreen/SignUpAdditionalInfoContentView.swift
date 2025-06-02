import AppBaseFlow
import UIKit
import SnapKit
import AppDesignSystem
import TweeTextField

extension SignUpAdditionalInfoContext {
    final class ContentView: BaseView {
        private(set) lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 18, weight: .bold)
            label.textColor = colors.labelPrimary
            label.text = "Make us know more about you!" /*strings.signUpAdditionalInfo*/
            return label
        }()
        
        private(set) lazy var changeAvatarButton: ActionButton = {
            let button = ActionButton()
            button.setImage(icons.addAvatar, for: .normal)
            button.imageView?.layer.cornerRadius = 40
            button.imageView?.clipsToBounds = true
            return button
        }()
        
        private(set) lazy var firstNameTextField: TweeAttributedTextField = {
            let tf = components.inputTextField
            tf.tweePlaceholder = strings.firstName
            tf.rightView = createRequiredIndicator()
            tf.rightViewMode = .always
            return tf
        }()
        
        private(set) lazy var lastNameTextField: TweeAttributedTextField = {
            let tf = components.inputTextField
            tf.tweePlaceholder = strings.lastName
            return tf
        }()
        
        private(set) lazy var phoneTextField: TweeAttributedTextField = {
            let tf = components.inputTextField
            tf.tweePlaceholder = strings.profilePhone
            tf.keyboardType = .phonePad
            tf.rightView = createRequiredIndicator()
            tf.rightViewMode = .always
            let textView = UITextView()
            textView.text = "+7 "
            textView.font = typography.body
            textView.backgroundColor = .clear
            tf.leftView = textView
            tf.leftViewMode = .always
            return tf
        }()
        
        private(set) lazy var bioTextField: TweeAttributedTextField = {
            let tf = components.inputTextField
            tf.tweePlaceholder = strings.profileBio
            return tf
        }()
        
        private(set) lazy var doneButton: ActionButtonWithLoader = {
            let button = components.roundedWithDisabledButton
            button.setTitle(strings.commonDone, for: .normal)
            button.isEnabled = false
            return button
        }()
        
        private(set) lazy var verticalStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [
                firstNameTextField,
                lastNameTextField,
                phoneTextField,
                bioTextField,
                doneButton
            ])
            stackView.axis = .vertical
            stackView.spacing = 48
            return stackView
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func setLayout() {
            backgroundColor = colors.backgroundPrimary
            setupHierarchy()
            setupConstraints()
        }
        
        private func setupHierarchy() {
            addSubview(changeAvatarButton)
            addSubview(titleLabel)
            addSubview(verticalStackView)
            addSubview(doneButton)
        }
        
        private func setupConstraints() {
            changeAvatarButton.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(40)
                make.centerX.equalToSuperview()
                make.width.height.equalTo(80)
            }
            titleLabel.snp.makeConstraints { make in
                make.top.equalTo(changeAvatarButton.snp.bottom).offset(32)
                make.centerX.equalToSuperview()
            }
            verticalStackView.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(64)
                make.leading.equalToSuperview().offset(24)
                make.trailing.equalToSuperview().offset(-24)
            }
            doneButton.snp.makeConstraints { make in
                make.top.greaterThanOrEqualTo(verticalStackView.snp.bottom).offset(32)
                make.leading.equalToSuperview().offset(24)
                make.trailing.equalToSuperview().offset(-24)
                make.bottom.equalToSuperview().inset(40)
                make.height.equalTo(48)
            }
        }
        
        private func createRequiredIndicator() -> UIView {
            let label = UILabel()
            label.text = "*"
            label.textColor = .systemRed
            label.font = .systemFont(ofSize: 16, weight: .bold)
            return label
        }
    }
} 
