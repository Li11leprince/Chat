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
        
    }
}

