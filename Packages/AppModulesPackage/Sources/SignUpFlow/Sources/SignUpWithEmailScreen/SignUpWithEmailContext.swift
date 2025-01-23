//  

import Foundation
import AppBaseFlow

struct SignUpWithEmailContext {
    private init() {}
}


//MARK: ViewState

extension SignUpWithEmailContext {
    enum ViewState: Stubable {
        case initial
        case loading
        
        static var stub: ViewState { .initial }
    }
}

//MARK: OutputEvent

extension SignUpWithEmailContext {
    enum OutputEvent {
        case finish
    }
}

//MARK: ViewEvent

extension SignUpWithEmailContext {
    enum ViewEvent {
        case viewDidLoad
        case signUp(email: String, password: String)
    }
}

extension SignUpWithEmailContext {
    typealias ScreenError = BaseUIError<Void>
}
