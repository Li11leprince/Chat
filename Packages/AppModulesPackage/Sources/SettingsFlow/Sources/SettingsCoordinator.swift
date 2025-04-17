//  

import UIKit
import Combine
import AppDesignSystem
import AppBaseFlow
import AppServices

public final class SettingsCoordinator: BaseCoordinator, EventCoordinator {

    public enum SettingsEvent {
        case finished
    }

    public var events: AnyPublisher<SettingsEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }

    public var eventsCancelableToken: AnyCancellable?

    private var designSystem = appDesignSystem

    private var eventSubject: PassthroughSubject<Event, Never> = .init()
    private var setCancelable = Set<AnyCancellable>()

    private weak var navigationController: UINavigationController?

    public init(
        navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
    }

    public func start() {
        startSettingsScreen()
    }
}

// MARK: - Home Screen

private extension SettingsCoordinator {
    
    func startSettingsScreen(){
        let viewModel = SettingsViewModel()
        let vc = SettingsViewController(viewModel: viewModel)
        
        viewModel.outputEventPublisher
            .sink { [weak self] event in
                switch event {
                case .finish:
                    break
                case .goToSetting(let setting):
                    if setting == SettingModel.myProfile {
                        self?.startProfileScreen()
                    }
                }
            }
            .store(in: &setCancelable)
        
        navigationController?.setViewControllers([vc], animated: false)
    }
    
    func startProfileScreen(){
        let viewModel = ProfileViewModel()
        let vc = ProfileViewController(viewModel: viewModel)
        
        viewModel.outputEventPublisher
            .sink { [weak self] event in
                switch event {
                case .finish:
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            .store(in: &setCancelable)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

