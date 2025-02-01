//  Copyright © 2021 My organization. All rights reserved.

import UIKit
import Combine
import AppDesignSystem
import AppBaseFlow
import AppServices
import ChatsFlow
import SettingsFlow
import ContactsFlow

public final class HomeTabBarCoordinator: BaseCoordinator, EventCoordinator {

    public enum HomeEvent {
        case finished
    }

    public var events: AnyPublisher<HomeEvent, Never> {
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
        initializeHomeTabBar()
    }
}

// MARK: - Home Screen

private extension HomeTabBarCoordinator {
    
    func initializeHomeTabBar(){
        let vc = UITabBarController()
        vc.tabBar.standardAppearance = designSystem.components.tabbarStandardAppearance

        let chatsNavigationController = UINavigationController()
        chatsNavigationController.tabBarItem = designSystem.components.chatsTabBarItem
        
        let settingsNavigationController = UINavigationController()
        settingsNavigationController.tabBarItem = designSystem.components.settingsTabBarItem
        
        let contactsNavigationController = UINavigationController()
        contactsNavigationController.tabBarItem = designSystem.components.contactsTabBarItem
        
        vc.viewControllers = [
            contactsNavigationController,
            chatsNavigationController,
            settingsNavigationController
        ]
        vc.selectedIndex = 1
        
        navigationController?.pushViewController(vc, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        startChatsCoordinator(navController: chatsNavigationController)
        startContactsCoordinator(navController: contactsNavigationController)
        startSettingsCoordinator(navController: settingsNavigationController)
    }
    
    private func startChatsCoordinator(navController: UINavigationController) {
        
        let coordinator = ChatsCoordinator.init(navigationController: navController)
        
        let token = coordinator.events.sink { _ in
            // IMPLEMENT: Event handling
        }
        addDependency(coordinator, token: token)
        
        coordinator.start()
    }
    
    private func startSettingsCoordinator(navController: UINavigationController) {
        let coordinator = SettingsCoordinator.init(navigationController: navController)
        
        let token = coordinator.events.sink { _ in
            // IMPLEMENT: Event handling
        }
        addDependency(coordinator, token: token)
        
        coordinator.start()
    }
    
    private func startContactsCoordinator(navController: UINavigationController) {
        let coordinator = ContactsCoordinator.init(navigationController: navController)
        
        let token = coordinator.events.sink { _ in
            // IMPLEMENT: Event handling
        }
        addDependency(coordinator, token: token)
        
        coordinator.start()
    }
}
