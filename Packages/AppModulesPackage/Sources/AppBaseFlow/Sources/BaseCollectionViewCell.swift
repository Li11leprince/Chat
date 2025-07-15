//  Copyright © 2021 My organization. All rights reserved.

import UIKit
import AppDesignSystem

// MARK: - BaseCollectionViewCell

open class BaseCollectionViewCell: UICollectionViewCell {
    
    public let components = appDesignSystem.components
    public let colors = appDesignSystem.colors
    public let strings = appDesignSystem.strings
    public let typography = appDesignSystem.typography
    public let icons = appDesignSystem.icons
    public let formatter = appDesignSystem.formatter
    
    public static var reuseIdentifier: String {
        return String(describing: Self.self)
    }

//    private(set) lazy var genericCellView: UIView = makeCellView()
//
//    private var setCustomLayout: (() -> Void)?
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        backgroundColor = .clear
//        contentView.addSubview(genericCellView)
//
//        setCellViewLayout()
//    }
//
//    public required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    public override func layoutSubviews() {
//        super.layoutSubviews()
//
//        guard setCustomLayout == nil else { return }
//        genericCellView.frame = contentView.bounds
//    }
//
//    open func makeCellView() -> UIView {
//        assertionFailure("It's not intended to use")
//        return UIView()
//    }
//
//    public func typedGenericView<T: UIView>() -> T {
//        guard let view = genericCellView as? T else {
//            assertionFailure("Generic cell view cannot be casted to type \(T.self)")
//            return T()
//        }
//        return view
//    }
//
//    private func setCellViewLayout() {
//        contentView.addSubview(genericCellView)
//
//        setCustomLayout = provideCustomLayout()
//        setCustomLayout?()
//    }
//
//    /// Customize yout layout by setting constaint for typedView and contentView
//    /// It must use autolayout
//    /// - Returns: Setting up constrants closure
//    open func provideCustomLayout() -> (() -> Void)? {
//        nil
//    }
}

// MARK: - Example for custom cell

//final class CustomCollectionViewCell: BaseCollectionViewCell {
//
//    var myContentView: MyContentView { typedGenericView() }
//
//    override func makeCellView() -> MyContentView { .init() }
//}
