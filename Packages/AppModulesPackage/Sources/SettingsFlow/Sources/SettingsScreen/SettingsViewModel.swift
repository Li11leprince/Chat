import Foundation
import AppBaseFlow

final class SettingsViewModel: BaseViewModel<SettingsContext.ViewEvent,
                            SettingsContext.ViewState,
                            SettingsContext.OutputEvent> {
    
    override func onViewEvent(_ event: SettingsContext.ViewEvent) {
        switch event {
        case .viewDidLoad:
            break
        case .settingPressed(let setting):
            outputEventSubject.send(.goToSetting(setting))
        }
    }
}
