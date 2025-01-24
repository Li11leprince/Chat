//  

import UIKit
import SnapKit
import Utilities

class SnackBarView: UIView {
    private let superView: UIView
    private let style: SnackBarStyle
    private let location: SnackBarLocation
    
    private lazy var textLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 16)
        return lbl
    }()
    
    init(
        superView: UIView,
        text: String,
        style: SnackBarStyle,
        location: SnackBarLocation
    ) {
        self.superView = superView
        self.style = style
        self.location = location
        super.init(frame: .zero)
        
        textLabel.text = text
        setupStyle()
        setupLayout()
    }
    
    func show() {
        animation(with: Insets.snackBarVisibleInset) { [weak self] _ in
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                self?.dismiss()
            }
        }
    }
    
    func dismiss() {
        animation(with: Insets.snackBarHiddenInset) { _ in
            self.removeFromSuperview()
        }
    }
    
    private func setupLayout() {
        let window = UIApplication.shared.keyWindow!
        window.addSubview(self)
        self.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30)
            switch location {
            case .top:
                make.top.equalToSuperview().inset(Insets.snackBarHiddenInset)
            case .bottom:
                make.bottom.equalToSuperview().inset(Insets.snackBarHiddenInset)
            }
        }
        
        addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
    }
    
    private func setupStyle() {
        backgroundColor = style.backgroundColor
        textLabel.textColor = style.textColor
        layer.cornerRadius = 12
        self.addSwipeGestureAllDirection(action: #selector(swipeAction))
    }
    
    @objc
    private func swipeAction() {
        dismiss()
    }
    
    private func animation(with offset: CGFloat, completion: ((Bool) -> Void)? = nil) {
        
        superview?.layoutIfNeeded()
        
        self.snp.updateConstraints { make in
            switch location {
            case .top:
                make.top.equalToSuperview().inset(offset)
            case .bottom:
                make.bottom.equalToSuperview().inset(offset)
            }
        }
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0, usingSpringWithDamping: 0.9,
            initialSpringVelocity: 0.7, options: .curveEaseOut,
            animations: {
                self.superview?.layoutIfNeeded()
            }, completion: completion)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private struct Insets {
        static let snackBarHiddenInset: CGFloat = -50
        static let snackBarVisibleInset: CGFloat = 80
    }
}
