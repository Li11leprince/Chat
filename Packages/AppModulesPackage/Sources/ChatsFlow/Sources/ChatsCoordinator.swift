//  Copyright © 2021 My organization. All rights reserved.

import UIKit
import Combine
import AppDesignSystem
import AppBaseFlow
import AppServices

public final class ChatsCoordinator: BaseCoordinator, EventCoordinator {

    public enum ChatsEvent {
        case finished
    }

    public var events: AnyPublisher<ChatsEvent, Never> {
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
        startChatsScreen()
    }
}

// MARK: - Home Screen

private extension ChatsCoordinator {
    
    func startChatsScreen(){
        let viewModel = ChatsViewModel()
        let vc = ChatsViewController(viewModel: viewModel)
        
        viewModel.outputEventPublisher
            .sink { [weak self] event in
                switch event {
                case .finish:
                    break
                }
            }
            .store(in: &setCancelable)
        
        navigationController?.setViewControllers([vc], animated: false)
    }
}
