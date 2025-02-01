//  

import UIKit
import SnapKit

final public class BadgeView: UIView {
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    public var count: Int {
        didSet {
            countLabel.text = String(count)
        }
    }
    
    public init() {
        count = 0
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.height / 2
    }
    
    func setup(colors: Colors, typography: Typography) {
        countLabel.textColor = colors.labelPrimaryVariant
        countLabel.font = typography.caption1
        backgroundColor = colors.labelTertiaryVariant
        clipsToBounds = true
    }
    
    private func setupLayout() {
        addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
    }
}
