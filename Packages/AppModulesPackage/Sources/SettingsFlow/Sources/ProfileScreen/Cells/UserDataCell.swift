//  

import UIKit
import AppBaseFlow
import AppDesignSystem
import SnapKit

class UserDataCell: BaseTableViewCell {
    var isDataEditing = false
    
    var textChanged: ((String) -> Void)?
    
    private(set) lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = typography.caption1
        return lbl
    }()
    
    private(set) lazy var subtitleTextField: UITextField = {
        let tf = UITextField()
        tf.font = .systemFont(ofSize: 14)
        tf.returnKeyType = .done
        tf.isEnabled = false
        return tf
    }()
    
    private(set) lazy var editButton: ActionButton = {
        let btn = ActionButton()
        btn.setImage(icons.pencil, for: .normal)
        return btn
    }()
    
    private(set) lazy var cancelEditButton: ActionButton = {
        let btn = ActionButton()
        btn.setImage(icons.eraser, for: .normal)
        btn.imageView?.tintColor = .systemRed
        btn.alpha = 0
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        subtitleTextField.delegate = self
        subtitleTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    private func setupLayout() {
        setupHierarchy()
        setupConstraints()
    }
    
    func setupHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleTextField)
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(8)
        }
        subtitleTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalToSuperview().inset(8)
        }
    }
    
    func didTapEdit() {
        subtitleTextField.isEnabled = true
        subtitleTextField.becomeFirstResponder()
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        textChanged?(textField.text ?? "")
    }
}

extension UserDataCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
