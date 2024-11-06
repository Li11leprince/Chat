//  Copyright © 2021 My organization. All rights reserved.

import UIKit
import Combine

import Utilities
import AppEntities
import AppServices
import AppBaseFlow
import WelcomeFlow
import SignInFlow
import HomeFlow

final class AppCoordinator: BaseCoordinator, Coordinator {

    private static var logger = LoggerFactory.default

    private let navigationController: UINavigationController = .init()
    private var window: UIWindow?

    // Dependencies
    private let debugTogglesHolder = AppContainer.provideDebugTogglesHolder()
    private let env: Env = AppContainer.provideEnv()
    private let debugStorage = AppContainer.provideDebugDefaultsStorage()
    private let defaultsStorage = AppContainer.provideDefaultsStorage()
    private var authService = AppContainer.provideAuthService()

    func start() {
        initWindow()

        if authService.hasAuthorizedUser {
            startAuthorizedFlow()
        } else {
            startWelcomeFlow()
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

    private func startWelcomeFlow() {
        let coordinator = WelcomeCoordinator(
            navigationController: navigationController
        )
        let token = coordinator.events.sink { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .signIn: self.startSignInFlow()
            }
        }
        addDependency(coordinator, token: token)
        coordinator.start()
    }

    private func startSignInFlow() {
//        let coordinator = SignInCoordinator(
//            navigationController: navigationController,
//            authService: authService
//        )
//
//        let token = coordinator.events.sink { [weak self, weak coordinator] event in
//            guard let self = self else { return }
//
//            switch event {
//            case .exit:
//                guard let coordinator = coordinator else { return }
//                self.removeDependency(coordinator)
//            case .finish(let authState):
//                self.handleFinishedSignInFlow(with: authState)
//            }
//        }
//        addDependency(coordinator, token: token)
//        coordinator.start()
    }

    private func handleFinishedSignInFlow(with authState: AuthState) {
        removeAll()
        switch authState {
        case .signIn:
            startAuthorizedFlow()
        case .signUp:
            startCreateProfileFlow()
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
