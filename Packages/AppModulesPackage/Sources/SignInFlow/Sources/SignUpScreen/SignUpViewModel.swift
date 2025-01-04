//  

import Foundation
import AppBaseFlow
import UIKit

final class SignUpViewModel: BaseViewModel<SignUpContext.ViewEvent,
                                     SignUpContext.ViewState,
                                     SignUpContext.OutputEvent> {
    
    override init() {
        
    }
    
    override func onViewEvent(_ event: ViewEvent) {
        switch event {
        case .viewDidLoad:
            viewState = .initial
        case .signUpWithEmailPressed:
            outputEventSubject.send(.didSelectProvider(.pwd))
        case .loginPressed:
            print("fds")
        }
    }
    
    func provideTitleText() -> NSAttributedString {
        var connectFriends = AttributedString(strings.signInConnectFriends)
        connectFriends.setAttributes(AttributeContainer([
            .font: UIFont.systemFont(ofSize: 68)
        ]))
        var easyAndQuick = AttributedString(" \(strings.signInEasyAndQuickly)")
        easyAndQuick.setAttributes(AttributeContainer([
            .font: UIFont.boldSystemFont(ofSize: 68)
        ]))
        connectFriends.append(easyAndQuick)
        return NSAttributedString(connectFriends)
    }
    
    func provideSubtitleText() -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 26

        let attrString = NSMutableAttributedString(string: strings.signInOurChatAppIsPerfect)
        attrString.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        return attrString
    }
}
