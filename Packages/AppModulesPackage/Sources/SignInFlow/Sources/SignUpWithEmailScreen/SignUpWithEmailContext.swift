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
    }
}
