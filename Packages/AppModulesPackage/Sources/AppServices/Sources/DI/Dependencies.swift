//  Copyright © 2021 My organization. All rights reserved.

import Foundation
import AppEntities
import Utilities
import AppBaseFlow

import Alamofire

struct AppContainer {
    
    fileprivate static let defaultJsonEncoder = JSONEncoder()
    fileprivate static let defaultJsonDecoder = JSONDecoder()
    @Injected(\.debugStorage) fileprivate static var debugStorage: DefaultsStorage


    fileprivate static let networkLogQueue = DispatchQueue(
        label: "\(InfoPlist.bundleId).networkLogQueue"
    )

    @Injected(\.alamofireHttpClient) fileprivate static var alamofireHttpClient: AlamofireHttpClient
    private init() {}
}


//MARK: Dependecy Keyes
private struct EnvKey: InjectionKey {
    static var currentValue: Env = Env(debugStorage: AppContainer.debugStorage)
}
private struct AppCoordinatorKey: InjectionKey {
    static var currentValue: Coordinator = AppCoordinator()
}

private struct MemoryStorageKey: InjectionKey {
    static var currentValue: MemoryStorage = .init()
}

private struct DefaultsStorageKey: InjectionKey {
    static var currentValue: DefaultsStorage = {
        let suiteName = "\(InfoPlist.bundleId).defaultsStorage"

        guard let storage = DefaultsStorage(
            suiteName: suiteName,
            encoder: AppContainer.defaultJsonEncoder,
            decoder: AppContainer.defaultJsonDecoder
        ) else {
            LoggerFactory.default.error(
                message: "UserDefaults can not be instantiated for suiteName: \(suiteName). Used fallback instance."
            )
            return DefaultsStorage.fallbackStorage
        }
        return storage
    }()
}

private struct DebugStorageKey: InjectionKey {
    static var currentValue: DefaultsStorage = {
        let suiteName = "\(InfoPlist.bundleId).debugStorage"
        guard let storage = DefaultsStorage(
            suiteName: suiteName,
            encoder: AppContainer.defaultJsonEncoder,
            decoder: AppContainer.defaultJsonDecoder
        ) else {
            LoggerFactory.default.error(
                message: "UserDefaults can not be instantiated for suiteName: \(suiteName). Used fallback instance."
            )
            return DefaultsStorage.fallbackStorage
        }
        return storage
    }()
}

private struct AlamofireHttpClientKey: InjectionKey {
    static var currentValue: AlamofireHttpClient = {
        let httpClient: AlamofireHttpClient = .init()
        
        return httpClient
    }()
}

private struct AuthServiceKey: InjectionKey {
    static var currentValue: AuthService = {
        let authService: AuthService = FakeAuthServiceImpl()
        
        return authService
    }()
}

//MARK: Dependecy Paths
extension InjectedValues {
    var env: Env {
        get { Self[EnvKey.self] }
        set { Self[EnvKey.self] = newValue }
    }
    
    var networkProvider: Coordinator {
        get { Self[AppCoordinatorKey.self] }
        set { Self[AppCoordinatorKey.self] = newValue }
    }
    
    var memoryStorage: MemoryStorage {
        get { Self[MemoryStorageKey.self] }
        set { Self[MemoryStorageKey.self] = newValue }
    }
    
    var defaultsStorage: DefaultsStorage {
        get { Self[DefaultsStorageKey.self] }
        set { Self[DefaultsStorageKey.self] = newValue }
    }
    
    var debugStorage: DefaultsStorage {
        get { Self[DebugStorageKey.self] }
        set { Self[DebugStorageKey.self] = newValue }
    }
    
    var alamofireHttpClient: AlamofireHttpClient {
        get { Self[AlamofireHttpClientKey.self] }
        set { Self[AlamofireHttpClientKey.self] = newValue }
    }
    
    var authService: AuthService {
        get { Self[AuthServiceKey.self] }
        set { Self[AuthServiceKey.self] = newValue }
    }
}
