//  

import UIKit

public enum SnackBarType {
    case error
}

public enum SnackBarLocation {
    case top
    case bottom
}

class SnackBar {
    
    static func show(in superView: UIView, message: String, style: SnackBarStyle, location: SnackBarLocation) {
        let snackBar = SnackBarView(
            superView: superView,
            text: message,
            style: style,
            location: location
        )
        snackBar.show()
    }
}
