//  Copyright © 2021 My organization. All rights reserved.

import UIKit
import Combine
import AppEntities
import AppServices
import AppDesignSystem
import AppBaseFlow

public final class SignUpCoordinator: EventCoordinator {

    public enum SignUpEvent {
        case finish(AuthState)
    }

    public var events: AnyPublisher<SignUpEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }

    public var eventsCancelableToken: AnyCancellable?

    private var setCancelable = Set<AnyCancellable>()

    private var eventSubject: PassthroughSubject<Event, Never> = .init()

    @Injected(\.authService) private var authService: AuthService
    private var designSystem = appDesignSystem

    private weak var navigationController: UINavigationController?

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        startSignUpScreen()
    }
}

// MARK: - Starting Screens

private extension SignUpCoordinator {
    
    private func startSignUpScreen() {
        let viewModel = SignUpViewModel()
        let viewController = SignUpViewController(viewModel: viewModel)
        
        viewModel.outputEventPublisher
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .didSelectProvider(let provider):
                    switch provider {
                    case .pwd:
//                        startPwdSignUpScreen()
                        startAdditionalInfoScreen()
                    case .apple:
                        print("apple")
                    case .facebook:
                        print("facebook")
                    case .google:
                        print("google")
                    }
                case .login:
                    eventSubject.send(.finish(.signedUp))
                }
            }
            .store(in: &setCancelable)
        
        navigationController?.setViewControllers([viewController], animated: true)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func startPwdSignUpScreen() {
        let viewModel = SignUpWithEmailViewModel()
        let viewController = SignUpWithEmailViewController(viewModel: viewModel)
        let navController = UINavigationController(rootViewController: viewController)
        viewModel.outputEventPublisher
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .finish:
                    self.startAdditionalInfoScreen(/*vc: navController*/)
                }
            }
            .store(in: &setCancelable)
        navigationController?.present(navController, animated: true)
    }

    private func startAdditionalInfoScreen(/*vc: UINavigationController*/) {
        let viewModel = SignUpAdditionalInfoViewModel()
        let viewController = SignUpAdditionalInfoViewController(viewModel: viewModel)
        viewController.navigationItem.hidesBackButton = true
        viewModel.outputEventPublisher
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .finish:
                    viewController.dismiss(animated: false)
                    eventSubject.send(.finish(.signedIn))
                }
            }
            .store(in: &setCancelable)
//        vc.pushViewController(viewController, animated: true)
        navigationController?.present(viewController, animated: true)
    }
}
