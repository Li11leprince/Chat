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
        case finish
    }

    public var events: AnyPublisher<SignInEvent, Never> {
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
        startSignInScreen()
    }
}

// MARK: - Starting Screens

private extension SignInCoordinator {
    
    private func startSignInScreen() {
        let viewModel = SignInViewModel()
        let viewController = SignInViewController(viewModel: viewModel)
        
        viewModel.outputEventPublisher
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .didSignIn:
                    self.eventSubject.send(.finish)
                }
            }
            .store(in: &setCancelable)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
