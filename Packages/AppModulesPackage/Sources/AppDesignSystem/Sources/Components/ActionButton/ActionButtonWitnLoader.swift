//  

import Foundation
import UIKit
import SnapKit

public final class ActionButtonWithLoader: ActionButton {
    
    private let colors: Colors
    private var titleColor: UIColor?
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = colors.labelPrimaryVariant
        return activityIndicator
    }()
    
    public var isLoading: Bool {
        didSet {
            if isLoading {
                showLoader()
            } else {
                hideLoader()
            }
        }
    }
    
    public init(colors: Colors) {
        isLoading = false
        self.colors = colors
        super.init(frame: .zero)
        
        setLayout()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func showLoader() {
        titleColor = titleLabel?.textColor
        setTitleColor(.clear, for: .normal)
        activityIndicator.startAnimating()
    }
    
    private func hideLoader() {
        setTitleColor(titleColor, for: .normal)
        activityIndicator.stopAnimating()
    }
}
