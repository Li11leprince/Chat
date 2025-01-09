//  Copyright © 2021 My organization. All rights reserved.

import UIKit
import Combine

import Utilities
import AppEntities
import AppServices
import AppBaseFlow
import SignInFlow
import HomeFlow
import AppDesignSystem

final class AppCoordinator: BaseCoordinator, Coordinator {

    private static var logger = LoggerFactory.default

    private let navigationController: UINavigationController = .init()
    private var window: UIWindow?

    // Dependencies
    @Injected(\.env) private var env: Env
    @Injected(\.debugStorage) private var debugStorage
    @Injected(\.defaultsStorage) private var defaultsStorage
    @Injected(\.authService) private var authService: AuthService
    
    func start() {
        initWindow()
        appDesignSystem.components.navBarAppearance()
        if authService.isLoggedIn() {
            startAuthorizedFlow()
        } else {
            startSignInFlow()
        }
    }

    private func initWindow() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window

    }
}

// MARK: - App Root Flows

private extension AppCoordinator {

    private func startAuthorizedFlow() {

    }

    private func startSignInFlow() {
        let coordinator = SignInCoordinator(
            navigationController: navigationController
        )

        let token = coordinator.events.sink { [weak self, weak coordinator] event in
            guard let self = self else { return }

            switch event {
            case .exit:
                guard let coordinator = coordinator else { return }
                self.removeDependency(coordinator)
            case .finish(let authState):
                self.handleFinishedSignInFlow(with: authState)
            }
        }
        addDependency(coordinator, token: token)
        coordinator.start()
    }

    private func handleFinishedSignInFlow(with authState: AuthState) {
        removeAll()
        switch authState {
        case .signedIn:
            startAuthorizedFlow()
        case .signUp:
            startCreateProfileFlow()
        case .signedOut:
            break
        }
    }

    private func startHomeFlow() {
//        let coordinator = HomeCoordinator(
//            navigationController: navigationController,
//            authService: authService,
//            debugTogglesHolder: debugTogglesHolder
//        )
//        let token = coordinator.events.sink { _ in
//            // IMPLEMENT: Event handling
//        }
//        addDependency(coordinator, token: token)
//        coordinator.start()
    }

    private func startCreateProfileFlow() {
//        let coordinator = StubFlowCoordinator(
//            navigationController: navigationController
//        )
//        let token = coordinator.events.sink { [weak self] event in
//            guard let self = self else { return }
//
//            switch event {
//            case .finish:
//                self.removeAll()
//                self.startOnboardingIfNeededOrHomeFlow()
//            }
//        }
//        addDependency(coordinator, token: token)
//        coordinator.start()
    }
    
    private func startOnboardingIfNeededOrHomeFlow() {
        if hasOnboardingCompleted() {
            startHomeFlow()
        } else {
            startOnboardingFlow()
        }
    }

    private func startOnboardingFlow() {
//        let coordinator = StubFlowCoordinator(
//            navigationController: navigationController
//        )
//        addDependency(coordinator)
//        coordinator.start()
    }

    private func showAuthErrorAlert() {
        navigationController.showAuthErrorAlert()
    }
    
    private func saveCompletedOnboarding() {
        defaultsStorage.add(
            primitiveValue: true,
            forKey: GlobalConfig.Keys.onboardingCompleted
        )
    }
    
    private func hasOnboardingCompleted() -> Bool {
        defaultsStorage.primitiveValue(
            forKey: GlobalConfig.Keys.onboardingCompleted
        ) ?? false
    }
}
