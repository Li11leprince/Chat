//  

import UIKit
import AppBaseFlow
import AppDesignSystem

final class LastNameCell: UserDataCell {
    
    func configure(lastName: String) {
        titleLabel.text = strings.lastName
        subtitleTextField.text = lastName
    }
}
