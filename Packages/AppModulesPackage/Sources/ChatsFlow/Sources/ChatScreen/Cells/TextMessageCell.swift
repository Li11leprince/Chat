//  

import UIKit
import SnapKit
import AppBaseFlow
import AppEntities
import Combine

class TextMessageCell: BaseCollectionViewCell {
    
    private lazy var bubbleView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        return view
    }()
    
    private lazy var messageLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = typography.subheadline
        lbl.textColor = colors.labelPrimary
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private lazy var timeLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = typography.caption2
        return lbl
    }()
    
//    private lazy var isReadImageView: UIImageView = {
//        let im = UIImageView()
//        im.image =
//        return lbl
//    }()
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    private let maxBubbleWidth: CGFloat = UIScreen.main.bounds.width * 0.7
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    private func setupLayout() {
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupHierarchy() {
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)
        bubbleView.addSubview(timeLabel)
    }
    
    private func setupConstraints() {
        bubbleView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.width.lessThanOrEqualTo(maxBubbleWidth)
            make.bottom.equalToSuperview()
        }
        
        messageLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(8)
            make.trailing.equalTo(timeLabel.snp.leading).inset(-4)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(bubbleView.snp.trailing).inset(8)
            make.bottom.equalToSuperview().inset(4)
        }
    }
    
    // MARK: - Конфигурация ячейки
    func configure(model: TextMessageCellModel) {
        messageLabel.text = model.text
        timeLabel.text = model.time
        
        bubbleView.backgroundColor = model.isMe ? colors.backgroundTertiary : colors.backgroundPrimary
        timeLabel.textColor = model.isMe ? colors.labelSecondaryVariant2 : colors.labelSecondary
        bubbleView.layer.maskedCorners = [model.isMe ? .layerMinXMaxYCorner : .layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        bubbleView.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.width.lessThanOrEqualTo(maxBubbleWidth)
            make.bottom.equalToSuperview()
            
            if model.isMe {
                make.trailing.equalToSuperview().inset(10)
            } else {
                make.leading.equalToSuperview().inset(10)
            }
        }
    }
}

struct TextMessageCellModel: Hashable {
    let isMe: Bool
    let id: String
    let time: String
    let text: String
//    let from: UserProfile
    let isRead: Bool
    let reactions: [Reaction]
    let isChanged: Bool
    
    static var mock: [TextMessageCellModel] = {
        var data: [TextMessageCellModel] = []
        for i in 0...10 {
            data.append(TextMessageCellModel(
                isMe: true,
                id: String(i),
                time: "12:05",
                text: String("Text\(i)"),
                //                from: UserProfl,
                isRead: true,
                reactions: [],
                isChanged: false
            ))
        }
        return data
    }()
}
