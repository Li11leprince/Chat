//

import UIKit
import Combine
import AppDesignSystem
import AppBaseFlow
import AppServices

public final class ContactsCoordinator: BaseCoordinator, EventCoordinator {

    public enum ContactsEvent {
        case finished
    }

    public var events: AnyPublisher<ContactsEvent, Never> {
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
        startContactsScreen()
    }
}

// MARK: - Home Screen

private extension ContactsCoordinator {
    
    func startContactsScreen(){
        
    }
}
