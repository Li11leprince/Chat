//  

import UIKit

public class BreakerView: UIView {
    private lazy var leftLine: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var rightLine: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    public func setup(lineColor: UIColor, textColor: UIColor, text: String) {
        leftLine.backgroundColor = lineColor
        rightLine.backgroundColor = lineColor
        textLabel.textColor = textColor
        textLabel.text = text.uppercased()
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(leftLine)
        addSubview(rightLine)
        addSubview(textLabel)
        
        leftLine.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(1)
            make.right.equalTo(textLabel.snp.left).inset(-16)
            make.left.equalToSuperview()
        }
        rightLine.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(1)
            make.left.equalTo(textLabel.snp.right).inset(-16)
            make.right.equalToSuperview()
        }
        textLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
