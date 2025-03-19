//  

import UIKit
import AppBaseFlow
import AppDesignSystem

final class PhoneCell: UserDataCell {
    
    func configure(phone: String) {
        titleLabel.text = strings.profilePhone
        subtitleTextField.text = phone
        
        subtitleTextField.textColor = .systemBlue
    }
}
