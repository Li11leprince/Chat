//  

import UIKit
import AppDesignSystem
import AppBaseFlow

final class ReplyToView: BaseView {
    private(set) lazy var separateVerticalLine: UIView = {
        return UIView()
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = typography.caption1
        return lbl
    }()
    
    private(set) lazy var subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = typography.caption1
        return lbl
    }()
    
    private(set) lazy var closeButton: ActionButton = {
        let btn = ActionButton()
        btn.setImage(icons.crossIcon.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(person: String, text: String, color: UIColor = .systemBlue) {
        separateVerticalLine.backgroundColor = color
        titleLabel.textColor = color
        closeButton.tintColor = color
        
        titleLabel.text = "Reply to \(person)"
        subtitleLabel.text = text
    }
    
    override func setLayout() {
        setupHierarchy()
        setupConstraints()
    }
    
    func setupHierarchy() {
        addSubview(separateVerticalLine)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(closeButton)
    }
    
    func setupConstraints() {
        separateVerticalLine.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(44)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(2)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(separateVerticalLine.snp.trailing).inset(-8)
            make.top.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(separateVerticalLine.snp.trailing).inset(-8)
            make.top.equalTo(titleLabel.snp.bottom)
        }
        
        closeButton.snp.makeConstraints { make in
            make.width.height.equalTo(12)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
}
