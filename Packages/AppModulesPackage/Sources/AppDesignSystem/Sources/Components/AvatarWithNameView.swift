//  

import UIKit
import SnapKit

public class AvatarWithNameView: UIView {
    
    // Аватарка
    private let avatarImageView: UIImageView = {
        let imageView = RoundedImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // Имя
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    // Подзаголовок
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Инициализация
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Настройка UI
    private func setupView() {
        addSubview(avatarImageView)
        addSubview(nameLabel)
        addSubview(subtitleLabel)
        
        avatarImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(100)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.left.right.equalToSuperview()
        }
    }
    
    // MARK: - Настройка контента
    public func configure(avatar: UIImage?, name: String, subtitle: String?) {
        avatarImageView.image = avatar
        nameLabel.text = name
        subtitleLabel.text = subtitle
    }
    
    public func hideLabels(duration: Double = 0.2) {
        UIView.animate(withDuration: duration) {
            self.nameLabel.alpha = 0.0
            self.subtitleLabel.alpha = 0.0
        }
    }
    
    public func showLabels(duration: Double = 0.2) {
        UIView.animate(withDuration: duration) {
            self.nameLabel.alpha = 1.0
            self.subtitleLabel.alpha = 1.0
        }
    }
    
    public func setImage(_ image: UIImage) {
        avatarImageView.image = image
    }
    
    public func setName(firstName: String, lastName: String?) {
        nameLabel.text = "\(firstName)\((lastName != nil) ? " \(lastName!)" : "")"
    }
    
    func setup(typography: Typography) {
        nameLabel.font = typography.title1
        subtitleLabel.font = typography.subheadline
    }
}
