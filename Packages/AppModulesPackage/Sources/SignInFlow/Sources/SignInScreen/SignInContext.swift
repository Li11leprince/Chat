//  

import Foundation
import AppBaseFlow

struct SignInContext {
    private init() {}
}

//MARK: ViewState

extension SignInContext {
    
    enum ViewState: Stubable {
        case initial
        
        static var stub: ViewState { .initial }
    }
    
}

//MARK: ViewEvent

extension SignInContext {
    enum ViewEvent {
        case viewDidLoad
    }
}

//MARK: OutputEvent

extension SignInContext {
    enum OutputEvent {
        case didSignIn
    }
}

//MARK: Error

extension SignInContext {
    typealias ScreenError = BaseUIError<Void>
}
