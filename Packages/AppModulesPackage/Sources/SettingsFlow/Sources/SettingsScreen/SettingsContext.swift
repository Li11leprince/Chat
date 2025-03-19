
import Foundation
import AppBaseFlow

struct SettingsContext {
    private init() {}
}

// MARK: ViewState

extension SettingsContext {
    enum ViewState: Stubable {
        case initial
        
        static var stub: ViewState = .initial
    }
}

// MARK: ViewEvent

extension SettingsContext {
    enum ViewEvent {
        case viewDidLoad
        case settingPressed(SettingModel)
    }
}

// MARK: OutputEvent

extension SettingsContext {
    enum OutputEvent {
        case finish
        case goToSetting(SettingModel)
    }
}
