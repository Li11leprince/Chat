import Foundation
import AppBaseFlow

struct SignUpAdditionalInfoContext {
    private init() {}
}

// MARK: ViewState
extension SignUpAdditionalInfoContext {
    enum ViewState: Stubable {
        case initial
        case loading
        case error(ScreenError?)
        
        static var stub: ViewState { .initial }
    }
}

// MARK: OutputEvent
extension SignUpAdditionalInfoContext {
    enum OutputEvent {
        case finish
    }
}

// MARK: ViewEvent
extension SignUpAdditionalInfoContext {
    enum ViewEvent {
        case viewDidLoad
        case updateProfile
    }
}

extension SignUpAdditionalInfoContext {
    typealias ScreenError = BaseUIError<Void>
} 
