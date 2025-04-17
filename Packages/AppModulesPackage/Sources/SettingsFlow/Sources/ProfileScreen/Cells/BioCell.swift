//  

import UIKit
import AppBaseFlow
import AppDesignSystem

final class BioCell: UserDataCell {
    
    func configure(bio: String) {
        titleLabel.text = strings.profileBio
        subtitleTextField.text = bio
    }
}
