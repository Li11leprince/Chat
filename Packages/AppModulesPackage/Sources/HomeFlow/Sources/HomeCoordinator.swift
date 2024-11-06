//  Copyright © 2021 My organization. All rights reserved.

import UIKit
import Combine
import AppDesignSystem
import AppBaseFlow
import AppServices

public final class HomeCoordinator: BaseCoordinator, EventCoordinator {

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
        startHomeScreen()
    }
}

// MARK: - Home Screen

private extension HomeCoordinator {
    
    private func startHomeScreen() {
        let tabBarController = UITabBarController()

        tabBarController.tabBar.standardAppearance = appDesignSystem.components.tabbarStandardAppearance

        tabBarController.viewControllers = [
            makeHomeViewController(),
            makeStoreViewController(),
            makeProfileViewController()
        ]

        navigationController?.setViewControllers([tabBarController], animated: false)
        navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
    func makeHomeViewController() -> UIViewController {
        UIViewController()
    }

    func makeStoreViewController() -> UIViewController {
        UIViewController()
    }

    func makeProfileViewController() -> UIViewController {
        UIViewController()
    }
}
