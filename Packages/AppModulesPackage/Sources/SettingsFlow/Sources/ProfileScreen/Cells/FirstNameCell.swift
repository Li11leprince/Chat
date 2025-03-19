//  

import UIKit
import AppBaseFlow
import AppDesignSystem

final class FirstNameCell: UserDataCell {
    
    func configure(firstName: String) {
        titleLabel.text = strings.firstName
        subtitleTextField.text = firstName
    }
}
