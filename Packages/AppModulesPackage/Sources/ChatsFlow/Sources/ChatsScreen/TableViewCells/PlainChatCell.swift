//  

import UIKit
import AppBaseFlow
import AppDesignSystem

final class ChatCell: UITableViewCell {
    public let components = appDesignSystem.components
    public let colors = appDesignSystem.colors
    public let strings = appDesignSystem.strings
    public let typography = appDesignSystem.typography
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = components.roundedImageView
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var onlineIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = colors.fillSecondary
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 2.0
        view.layer.borderColor = colors.labelPrimaryVariant.cgColor
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = typography.headline
        return lbl
    }()
    
    private lazy var contentLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = typography.subheadline
        lbl.numberOfLines = 2
        return lbl
    }()
    
    private lazy var timeLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = typography.subheadline
        return lbl
    }()
    
    private lazy var sentMarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var readMarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var badgeView: BadgeView = {
        let view = components.makeBadgeView()
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.separatorInset = UIEdgeInsets(top: 0, left: nameLabel.frame.origin.x, bottom: 0, right: 0)
    }
    
    func configure() {
        setupHierarchy()
        setupConstraints()
    }
    
    func update(data: ChatModel) {
        avatarImageView.image = data.avatar
        nameLabel.text = data.name
        contentLabel.text = data.message
        timeLabel.text = data.time
        if data.isOnline {
            onlineIndicator.isHidden = false
        } else {
            onlineIndicator.isHidden = true
        }
        if data.unreadCount > 0 {
            badgeView.isHidden = false
            badgeView.count = data.unreadCount
        } else {
            badgeView.isHidden = true
        }
        guard let isRead = data.isRead else {
            readMarkImageView.isHidden = false
            sentMarkImageView.isHidden = false
            return
        }
        if isRead {
            readMarkImageView.isHidden = false
            sentMarkImageView.isHidden = true
        } else {
            readMarkImageView.isHidden = true
            sentMarkImageView.isHidden = false
        }
    }
    
    private func setupHierarchy() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(onlineIndicator)
        contentView.addSubview(nameLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(sentMarkImageView)
        contentView.addSubview(readMarkImageView)
        contentView.addSubview(badgeView)
    }
    
    private func setupConstraints() {
        avatarImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Paddings.contentPadding)
            make.top.equalToSuperview().inset(Paddings.contentPadding)
            make.bottom.equalToSuperview().inset(Paddings.contentPadding)
            make.width.equalTo(56)
            make.height.equalTo(56)
        }
        
        onlineIndicator.snp.makeConstraints { make in
            make.centerX.equalTo(avatarImageView.snp.centerX).offset(21)
            make.centerY.equalTo(avatarImageView.snp.centerY).offset(14)
            make.width.height.equalTo(16)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Paddings.contentPadding)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(8)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(8)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Paddings.contentPadding)
            make.trailing.equalToSuperview().inset(Paddings.contentPadding)
        }
        
        badgeView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(Paddings.contentPadding)
            make.trailing.equalToSuperview().inset(Paddings.contentPadding)
        }
    }
    
    private struct Paddings {
        static let contentPadding: CGFloat = 8
    }
}
