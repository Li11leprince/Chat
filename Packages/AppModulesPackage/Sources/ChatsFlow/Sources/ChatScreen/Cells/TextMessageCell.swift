//

import UIKit
import SnapKit
import AppBaseFlow
import AppEntities
import Combine

class TextMessageCell: BaseCollectionViewCell {
    
    var onReply: ((MessageCellModel?) -> Void)?
    
    private var isFeedbackHappened = false
    
    private(set) lazy var bubbleView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        return view
    }()
    
    private(set) lazy var messageLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = typography.subheadline
        lbl.textColor = colors.labelPrimary
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private(set) lazy var timeLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = typography.caption2
        return lbl
    }()
    
    private(set) lazy var repliedMessageView: RepliedMessageView = {
        return RepliedMessageView()
    }()
    
    //    private lazy var isReadImageView: UIImageView = {
    //        let im = UIImageView()
    //        im.image =
    //        return lbl
    //    }()
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    private let maxBubbleWidth: CGFloat = UIScreen.main.bounds.width * 0.7
    
    private var model: MessageCellModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutMessageInfo()
    }
    
    
    private func setupLayout() {
        setupHierarchy()
        setupConstraints()
    }
    
    func setupHierarchy() {
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)
        bubbleView.addSubview(timeLabel)
    }
    
    func setupConstraints() {
        bubbleView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.width.lessThanOrEqualTo(maxBubbleWidth)
            make.bottom.equalToSuperview()
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8).priority(.low)
            make.leading.bottom.equalToSuperview().inset(8)
            make.trailing.equalTo(timeLabel.snp.leading).inset(-4)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(bubbleView.snp.trailing).inset(8)
            make.bottom.equalToSuperview().inset(4)
        }
    }
    
    private func layoutMessageInfo() {
        let padding: CGFloat = 8
        let maxTextWidth = maxBubbleWidth - padding * 2
        
        // Размер текста
        let textSize = messageLabel.sizeThatFits(CGSize(width: maxTextWidth, height: .greatestFiniteMagnitude))
        let timeSize = timeLabel.sizeThatFits(.zero)
        
        let totalWidth = textSize.width + timeSize.width + 4
        
        if totalWidth <= maxTextWidth {
            layoutMessageInfoInOneLineWithText(padding)
        } else if textSize.width.truncatingRemainder(dividingBy: maxTextWidth) <= maxTextWidth {
            layoutMessageInfoUnderText(padding)
        } else {
            layoutMessageInfoInOneLineWithLastTextLine(padding)
        }
    }
    
    private func layoutMessageInfoInOneLineWithText(_ padding: CGFloat) {
        messageLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().inset(padding).priority(.low)
            make.leading.bottom.equalToSuperview().inset(padding)
            make.trailing.equalTo(timeLabel.snp.leading).inset(-4)
        }
        
        timeLabel.snp.remakeConstraints { make in
            make.trailing.equalTo(bubbleView.snp.trailing).inset(padding)
            make.bottom.equalToSuperview().inset(4)
        }
    }
    
    private func layoutMessageInfoUnderText(_ padding: CGFloat) {
        messageLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().inset(padding).priority(.low)
            make.leading.trailing.equalToSuperview().inset(padding)
        }
        timeLabel.snp.remakeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).inset(-2)
            make.bottom.equalToSuperview().inset(4)
            make.trailing.equalTo(bubbleView.snp.trailing).inset(padding)
        }
    }
    
    private func layoutMessageInfoInOneLineWithLastTextLine(_ padding: CGFloat) {
        messageLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().inset(padding).priority(.low)
            make.leading.bottom.trailing.equalToSuperview().inset(padding)
        }
        timeLabel.snp.remakeConstraints { make in
            make.bottom.equalToSuperview().inset(8)
            make.trailing.equalTo(bubbleView.snp.trailing).inset(padding)
        }
    }
    
    // MARK: - Конфигурация ячейки
    
    func configure(model: TextMessageCellModel) {
        self.model = .plainText(model)
        messageLabel.text = model.text
        timeLabel.text = model.time
        
        if let replyTo = model.replyTo {
            setupRepliedMessageView(replyTo)
        }
        
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
    
    private func setupRepliedMessageView(_ replyTo: RepliedMessage) {
        repliedMessageView.setup(name: replyTo.from.displayName, text: replyTo.text)
        bubbleView.addSubview(repliedMessageView)
        repliedMessageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalTo(messageLabel.snp.top).inset(-8)
        }
    }
}

extension TextMessageCell {
    private func setupGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGesture.delegate = self
        contentView.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: contentView)
        let velocity = gesture.velocity(in: contentView)
        let criticalPoint: CGFloat = -50
        
        switch gesture.state {
        case .began, .changed:
            // Ограничиваем свайп только влево
            if translation.x < 0 {
                contentView.frame.origin.x = max(translation.x, -65)
            }
            let shouldTriggerAction = contentView.frame.origin.x <= criticalPoint || velocity.x < -500
            if shouldTriggerAction && isFeedbackHappened == false {
                isFeedbackHappened = true
                let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
                feedbackGenerator.impactOccurred()
            }
        case .ended, .cancelled:
            isFeedbackHappened = false
            let shouldTriggerAction = contentView.frame.origin.x <= criticalPoint || velocity.x < -500
            if shouldTriggerAction {
                onReply?(model)
                UIView.animate(withDuration: 0.2) {
                    self.contentView.frame.origin.x = 0
                }
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.contentView.frame.origin.x = 0
                }
            }
            
        default:
            break
        }
    }
}

extension TextMessageCell: UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGesture.translation(in: contentView)
            // Разрешаем только горизонтальные свайпы
            return abs(translation.x) > abs(translation.y)
        }
        return true
    }
}
