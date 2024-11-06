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

//    private let signInInteractor: SignInInteractor
//    private let authService: AuthService
    private var designSystem = appDesignSystem

    private weak var navigationController: UINavigationController?

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
//        self.authService = authService
//        self.signInInteractor = SignInInteractor(authService: authService)
    }

    public func start() {
        startEnterPhoneScreen()
    }
}

// MARK: - Starting Screens

private extension SignInCoordinator {

    private func startEnterPhoneScreen() {
//        let viewModel = EnterPhoneViewModel(signInInteractor: signInInteractor)
//        let viewController = EnterPhoneNumberViewController(viewModel: viewModel)
//        viewController.title = appDesignSystem.strings.commonSignIn
//
//        viewModel.outputEventPublisher
//            .sink { [weak self] event in
//                guard let self = self else { return }
//
//                switch event {
//                case .continue: self.startEnterSmsCode()
//                case .back: self.eventSubject.send(.exit)
//                }
//            }
//            .store(in: &setCancelable)
//
//        navigationController?.pushViewController(viewController, animated: true)
//        navigationController?.setNavigationBarHidden(false, animated: false)
    }

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
}
