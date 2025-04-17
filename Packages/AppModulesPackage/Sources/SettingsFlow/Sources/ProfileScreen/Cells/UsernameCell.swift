//  

import UIKit
import AppBaseFlow
import AppDesignSystem

final class UsernameCell: UserDataCell {
    
    func configure(username: String) {
        titleLabel.text = strings.profileUsername
        subtitleTextField.text = username
        
        subtitleTextField.textColor = .systemBlue
    }
}
