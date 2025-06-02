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
    @Injected(\.defaultsStorage) fileprivate static var defautlsStorage: DefaultsStorage
    @Injected(\.memoryStorage) fileprivate static var memoryStorage: MemoryStorage
    @Injected(\.passwordAuthProvide) fileprivate static var passwordAuthProvider: PasswordAuthProvider
    @Injected(\.alamofireHttpClient) fileprivate static var alamofireHttpClient: AlamofireHttpClient
    @Injected(\.httpRequestFactory) fileprivate static var httpRequestFactory: HttpRequestFactory
    @Injected(\.networkMapper) fileprivate static var networkMapper: NetworkMapper
    @Injected(\.authService) fileprivate static var authService: AuthService
    @Injected(\.accountHolder) fileprivate static var accountHolder: AccountHolder


    fileprivate static let networkLogQueue = DispatchQueue(
        label: "\(InfoPlist.bundleId).networkLogQueue"
    )

//    @Injected(\.alamofireHttpClient) fileprivate static var alamofireHttpClient: AlamofireHttpClient
    private init() {}
}


//MARK: Dependecy Keyes
private struct EnvKey: InjectionKey {
    static var currentValue: Env = Env(debugStorage: AppContainer.debugStorage)
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

private struct NetworkMapperKey: InjectionKey {
    static var currentValue: NetworkMapper = .init()
}

private struct AlamofireHttpClientKey: InjectionKey {
    static var currentValue: AlamofireHttpClient = {
        let httpClient: AlamofireHttpClient = .init(
            urlSessionConfiguration: URLSessionConfiguration.af.default,
            eventMonitors: [
                RequestLogEventMonitor(queue: AppContainer.networkLogQueue),
                ResponseLogEventMonitor(queue: AppContainer.networkLogQueue)
            ]
        )
        
        return httpClient
    }()
}

private struct PasswordAuthProviderKey: InjectionKey {
    static var currentValue: PasswordAuthProvider = {
        let authProvider: PasswordAuthProvider = FirebasePasswordAuthProvider()
        
        return authProvider
    }()
}

private struct AuthServiceKey: InjectionKey {
    static var currentValue: AuthService = {
        let authService: AuthService = AuthServiceImpl(
            authProvider: AppContainer.passwordAuthProvider,
            defaultsStorage: AppContainer.defautlsStorage
        )
        
        return authService
    }()
}

private struct AccountHolderKey: InjectionKey {
    static var currentValue: AccountHolder = {
        let authService: AccountHolder = AuthServiceImpl(
            authProvider: AppContainer.passwordAuthProvider,
            defaultsStorage: AppContainer.defautlsStorage
        )
        
        return authService
    }()
}

private struct DateFormatterServiceKey: InjectionKey {
    static var currentValue: DateFormatting = {
        return DefaultDateFormatterService()
    }()
}

private struct HttpRequestFactoryKey: InjectionKey {
    static var currentValue: HttpRequestFactory = {
        return HttpRequestFactory(meadiaStorageUrlProviding: { InfoPlist.apiMediaStorage })
    }()
}

private struct MediaContentRepositoryKey: InjectionKey {
    static var currentValue: MediaContentRepository = {
        let mediaContentRepository = MediaContentRepository(
            httpClient: AppContainer.alamofireHttpClient,
            requestFactory: AppContainer.httpRequestFactory,
            networkMapper: AppContainer.networkMapper
        )
        
        return mediaContentRepository
    }()
}

private struct AccountRepositoryKey: InjectionKey {
    static var currentValue: AccountRepository = {
        let accountRepository = AccountRepository(
            accountHolder: AppContainer.accountHolder
        )
        
        return accountRepository
    }()
}

//MARK: Dependecy Paths
public extension InjectedValues {
    var env: Env {
        get { Self[EnvKey.self] }
        set { Self[EnvKey.self] = newValue }
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
    
    var passwordAuthProvide: PasswordAuthProvider {
        get { Self[PasswordAuthProviderKey.self] }
        set { Self[PasswordAuthProviderKey.self] = newValue }
    }
    var authService: AuthService {
        get { Self[AuthServiceKey.self] }
        set { Self[AuthServiceKey.self] = newValue }
    }
    
    var accountHolder: AccountHolder {
        get { Self[AccountHolderKey.self] }
        set { Self[AccountHolderKey.self] = newValue }
    }
    
    var dateFormatter: DateFormatting {
        get { Self[DateFormatterServiceKey.self] }
        set { Self[DateFormatterServiceKey.self] = newValue }
    }
    
    var networkMapper: NetworkMapper {
        get { Self[NetworkMapperKey.self] }
        set { Self[NetworkMapperKey.self] = newValue }
    }
    
    var httpRequestFactory: HttpRequestFactory {
        get { Self[HttpRequestFactoryKey.self] }
        set { Self[HttpRequestFactoryKey.self] = newValue }
    }

    var mediaContentRepository: MediaContentRepository {
        get { Self[MediaContentRepositoryKey.self] }
        set { Self[MediaContentRepositoryKey.self] = newValue }
    }
    
    var accountRepository: AccountRepository {
        get { Self[AccountRepositoryKey.self] }
        set { Self[AccountRepositoryKey.self] = newValue }
    }
}
