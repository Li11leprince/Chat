//  Copyright © 2021 My organization. All rights reserved.

import UIKit
import Combine
import AppEntities
import AppServices
import AppDesignSystem
import AppBaseFlow

public final class SignInCoordinator: EventCoordinator {

    public enum SignInEvent {
        case exit
        case finish(AuthState)
    }

    public var events: AnyPublisher<SignInEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }

    public var eventsCancelableToken: AnyCancellable?

    private var setCancelable = Set<AnyCancellable>()

    private var eventSubject: PassthroughSubject<Event, Never> = .init()

//    private let signInInteractor: SignInInteractor
    @Injected(\.authService) private var authService: AuthService
    private var designSystem = appDesignSystem

    private weak var navigationController: UINavigationController?

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
//        self.signInInteractor = SignInInteractor(authService: authService)
    }

    public func start() {
        startSignUpScreen()
    }
}

// MARK: - Starting Screens

private extension SignInCoordinator {

    private func startEnterSmsCode() {
//        let viewModel = EnterSmsCodeViewModel(signInInteractor: signInInteractor)
//        let viewController = EnterSmsCodeViewController(viewModel: viewModel)
//        viewController.title = appDesignSystem.strings.commonSignIn
//
//        viewModel.outputEventPublisher
//            .sink { [weak self] event in
//                guard let self = self else { return }
//
//                switch event {
//                case .continue(let authState): self.eventSubject.send(
//                    .finish(authState: authState)
//                )
//                case .back: break
//                case .changePhone:
//                    self.navigationController?.popViewController(animated: true)
//                }
//            }
//            .store(in: &setCancelable)
//
//        navigationController?.pushViewController(viewController, animated: false)
//        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
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
                        print("pwd")
                    case .apple:
                        print("apple")
                    case .facebook:
                        print("facebook")
                    case .google:
                        print("google")
                    }
                }
            }
            .store(in: &setCancelable)
        
        navigationController?.setViewControllers([viewController], animated: true)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
