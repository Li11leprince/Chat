//  

import Foundation
import AppBaseFlow

struct SignUpContext {
    private init() {
        
    }
}

//MARK: ViewState

extension SignUpContext {
    
    enum ViewState: Stubable {
        case initial
        
        static var stub: ViewState { .initial }
    }
}

//MARK: Output Ivent

extension SignUpContext {
    
    enum OutputEvent {
        case didSelectProvider(Provider)
    }
}

//MARK: ViewEvent

extension SignUpContext {
    enum ViewEvent {
        case viewDidLoad
        case signUpWithEmailPressed
        case loginPressed
    }
}

extension SignUpContext {
    typealias ScreenError = BaseUIError<Void>
}

//MARK: SignIn Provider

extension SignUpContext {
    enum Provider {
        case pwd
        case apple
        case facebook
        case google
    }
}
