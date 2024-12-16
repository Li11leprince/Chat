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
        case empty
        
        static var stub: ViewState { .empty }
    }
}

//MARK: Output Ivent

extension SignUpContext {
    
    enum OutputEvent {
        case didSelectProvider(Provider)
    }
}

//MARK: View Invent

extension SignUpContext {
    enum ViewEvent {
        
    }
}

extension SignUpContext {
    typealias ScreenError = BaseUIError<Void>
}

//MARK: SignIn Provider

extension SignUpProviderContext {
    enum Provider {
        case pwd
        case apple
        case facebook
        case google
    }
}
