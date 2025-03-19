//  

import UIKit
import AppBaseFlow
import SnapKit

class SettingCell: BaseTableViewCell {
    
//    private lazy var imageView: UIImageView = {
//        let im = UIImageView()
//        return im
//    }()
//    
//    private lazy var textLabel: UILabel = {
//        let lbl = UILabel()
//        lbl.font = typography.body
//        return lbl
//    }()
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setLayout()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    func configure(model: SettingModel) {
        imageView?.image = model.icon
        textLabel?.text = model.title
        accessoryType = model.accessoryType
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.separatorInset = UIEdgeInsets(top: 0, left: textLabel!.frame.origin.x, bottom: 0, right: 0)
    }
    
    private func setLayout() {
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupHierarchy() {
//        addSubview(imageView)
//        addSubview(textLabel)
    }
    
    private func setupConstraints() {
//        imageView.snp.makeConstraints { make in
//            make.leading.equalToSuperview().inset(16)
//            make.top.bottom.equalToSuperview().inset(8)
//        }
//        textLabel.snp.makeConstraints { make in
//            make.leading.equalTo(imageView.snp.trailing).inset(-16)
//            make.top.bottom.equalToSuperview().inset(8)
//        }
    }
}
