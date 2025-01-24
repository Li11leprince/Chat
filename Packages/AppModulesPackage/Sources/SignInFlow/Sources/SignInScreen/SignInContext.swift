//  

import Foundation
import AppBaseFlow
import AppEntities

struct SignInContext {
    private init() {}
}

//MARK: ViewState

extension SignInContext {
    
    enum ViewState: Stubable {
        case initial
        case loading
        case loaded
        case error(AppError)
        
        static var stub: ViewState { .initial }
    }
    
}

//MARK: ViewEvent

extension SignInContext {
    enum ViewEvent {
        case viewDidLoad
        case signInTapped(email: String, password: String)
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
