//  

import UIKit
import AppBaseFlow
import SnapKit
import AppDesignSystem


final class RepliedMessageView: BaseView {
    private(set) lazy var verticalLineVeiw: UIView = {
        let view = UIView()
        view.backgroundColor = colors.labelSecondaryVariant2
        return view
    }()
    
    private(set) lazy var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = typography.caption1
        lbl.textColor = colors.labelSecondaryVariant2
        return lbl
    }()
    
    private(set) lazy var textLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = typography.caption2
        return lbl
    }()
    
    func setup(name: String, text: String) {
        nameLabel.text = name
        textLabel.text = text
    }
    
    override func setLayout() {
        backgroundColor = UIColor(red: 202/255, green: 246/255, blue: 177/255, alpha: 1.0)
        layer.cornerRadius = 4
        clipsToBounds = true
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupHierarchy() {
        addSubview(verticalLineVeiw)
        addSubview(nameLabel)
        addSubview(textLabel)
    }
    
    private func setupConstraints() {
        verticalLineVeiw.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(2)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.top.equalToSuperview().inset(4)
            make.trailing.equalToSuperview().inset(4)
        }
        
        textLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.top.equalTo(nameLabel.snp.bottom)
            make.bottom.equalToSuperview().inset(4)
            make.trailing.equalToSuperview().inset(4)
        }
    }
}
