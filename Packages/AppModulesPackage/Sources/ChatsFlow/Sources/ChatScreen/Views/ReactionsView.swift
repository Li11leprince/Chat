//  

import Foundation
import AppBaseFlow
import AppDesignSystem
import UIKit
import SnapKit
import AppEntities
import Combine

public struct ReactionViewModel: Hashable {
    public let emoji: String //unicode symbols
    public let from: UIImage
}

final class ReactionsView: BaseView {
    var reactions: CurrentValueSubject<[ReactionViewModel], Never> = .init([])
    
    private var reactionsCancellable: AnyCancellable?
    
    private(set) lazy var reactionLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = typography.body
        return lbl
    }()
    
    private(set) lazy var avatarImageView: UIImageView = {
        let im = components.roundedImageView
        im.contentMode = .scaleAspectFit
        return im
    }()
    
    private(set) lazy var counterLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = typography.footnote
        return lbl
    }()
    
    private(set) lazy var horizontalStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 4
        return sv
    }()
    
    override func setLayout() {
        layer.cornerRadius = 14
        backgroundColor = colors.backgroundSecondaryVariant
        clipsToBounds = true
        setupObserver()
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupHierarchy() {
//        addSubview(reactionLabel)
//        addSubview(avatarImageView)
//        addSubview(counterLabel)
        addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(reactionLabel)
        horizontalStackView.addArrangedSubview(avatarImageView)
        horizontalStackView.addArrangedSubview(counterLabel)
        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
    }
    
    private func setupConstraints() {
        horizontalStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.leading.trailing.equalToSuperview().inset(8)
        }
    }
    
    private func setupObserver() {
        reactionsCancellable = reactions
            .sink { [weak self] reactions in
                guard let self else { return }
                switch reactions.count {
                case 0...1:
                    self.showAvatars()
                default:
                    self.showCounter()
                }
            }
    }
    
    private func showAvatars() {
        horizontalStackView.removeArrangedSubview(counterLabel)
        if reactions.value.count > 0 {
            avatarImageView.image = reactions.value[0].from
            reactionLabel.text = reactions.value[0].emoji
        }
    }
    
    private func showCounter() {
        horizontalStackView.removeArrangedSubview(avatarImageView)
        counterLabel.text = String(reactions.value.count)
        reactionLabel.text = reactions.value[0].emoji
    }
}
