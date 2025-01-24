//  Copyright © 2021 My organization. All rights reserved.

import Foundation
import AppEntities
import AppServices
import Utilities
import AppBaseFlow

import Alamofire

struct AppContainer {
    
    @Injected(\.debugStorage) fileprivate static var debugStorage: DefaultsStorage

    private init() {}
}


//MARK: Dependecy Keyes

private struct AppCoordinatorKey: InjectionKey {
    static var currentValue: Coordinator = AppCoordinator()
}

//MARK: Dependecy Paths
extension InjectedValues {
    var appCoordinator: Coordinator {
        get { Self[AppCoordinatorKey.self] }
        set { Self[AppCoordinatorKey.self] = newValue }
    }
    
}
