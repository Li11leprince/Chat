//  

import UIKit
import SnapKit

public class RoundedView: UIView {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    public override var bounds: CGRect {
        didSet {
            layer.cornerRadius = frame.height / 2
            clipsToBounds = true
        }
    }

    public func setup(color: UIColor, image: UIImage) {
        layer.cornerRadius = frame.height / 2
        clipsToBounds = true
        layer.borderWidth = 1
        layer.borderColor = color.cgColor
        contentMode = .center
        imageView.image = image
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
    }
}
