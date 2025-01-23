//  

import Foundation
import Combine
import AppEntities

public enum AuthState {
    case signedIn
    case signedUp
    case notRegistered
}

public protocol AuthService {
    typealias VoidResult = Result<Void, AppError>
    
    var authState: AuthState { get }
    func signUp(email: String, password: String) -> AnyPublisher<VoidResult, Never>
    func signIn(email: String, password: String) -> AnyPublisher<VoidResult, Never>
    func signOut() -> AnyPublisher<VoidResult, Never>
}

public final class AuthServiceImpl: AuthService {
    public var authState: AuthState {
        if isSignedIn {
            return .signedIn
        } else if isSignedUp {
            return .signedUp
        } else {
            return .notRegistered
        }
    }
    public var credential: Credentials? { provideCredentials() }
    
    private let authProvider: PasswordAuthProvider
    private let defaultsStorage: DefaultsStorage
    
    private var isSignedUp: Bool { provideIsSignedUp() }
    private var isSignedIn: Bool { credential != nil }
    
    private var credentialsKey: String { "\(Self.self).credentialsKey" }
    private var signedUpKey: String { "\(Self.self).signedUpKey" }
    
    public init(
        authProvider: PasswordAuthProvider,
        defaultsStorage: DefaultsStorage
    ) {
        self.authProvider = authProvider
        self.defaultsStorage = defaultsStorage
    }
    
    public func signUp(
        email: String,
        password: String
    ) -> AnyPublisher<Result<Void, AppError>, Never> {
        let publisher = authProvider.signUp(email: email, password: password)
            .flatMap { [weak self] (result: Result<Credentials, AppError>) -> Just<VoidResult> in
                guard let self else {
                    return Just(.failure(.unexpected))
                }
                
                return self.handleSignUpSignInResult(result)
            }
            .eraseToAnyPublisher()
        
        return publisher
    }
    
    public func signIn(email: String, password: String) -> AnyPublisher<VoidResult, Never> {
        let publisher = authProvider.signIn(email: email, password: password)
            .flatMap { [weak self] (result: Result<Credentials, AppError>) -> Just<VoidResult> in
                guard let self else {
                    return Just(.failure(.unexpected))
                }
                
                return self.handleSignUpSignInResult(result)
            }
            .eraseToAnyPublisher()
        
        return publisher
    }
    
    public func signOut() -> AnyPublisher<VoidResult, Never> {
        let publisher = authProvider.signOut()
            .flatMap { [weak self] (result: VoidResult) -> Just<VoidResult> in
                guard let self else {
                    return Just(.failure(.unexpected))
                }
            
                return self.handleSignOutResult(result)
            }
            .eraseToAnyPublisher()
        
        return publisher
    }
}

// MARK: Helpers

private extension AuthServiceImpl {
    private func handleSignUpSignInResult(_ result: Result<Credentials, AppError>) -> Just<VoidResult> {
        switch result {
        case .success(let credentials):
            saveCredentials(credentials)
            return Just(.success(()))
        case .failure(let error):
            return Just(.failure(error))
        }
    }
    
    private func handleSignOutResult(_ result: VoidResult) -> Just<VoidResult> {
        switch result {
        case .success():
            removeCredentials()
            return Just(.success(()))
        case .failure(let error):
            return Just(.failure(error))
        }
    }
    
    private func saveCredentials(_ credentials: Credentials) {
        defaultsStorage.add(object: credentials, forKey: credentialsKey)
        defaultsStorage.add(primitiveValue: true, forKey: signedUpKey)
    }
    
    private func provideIsSignedUp() -> Bool {
        defaultsStorage.primitiveValue(forKey: signedUpKey) ?? false
    }
    
    private func provideCredentials() -> Credentials? {
        defaultsStorage.object(forKey: credentialsKey)
    }
    
    private func removeCredentials() {
        defaultsStorage.removeObject(forKey: credentialsKey)
    }
}
