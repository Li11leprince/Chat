//  

import Foundation
import Combine


public final class FakeAuthServiceImpl: AuthService {
    
    public var authState: AuthState {
        if isSignedIn {
            return .signedIn
        } else if isSignedUp {
            return .signedUp
        } else {
            return .notRegistered
        }
    }
    
    private let memoryStorage: MemoryStorage
    
    private var isSignedUp: Bool { provideIsSignedUp() }
    private var isSignedIn: Bool { provideIsSignedIn() }
    
    private var signedInKey: String { "\(Self.self).signedInKey" }
    private var signedUpKey: String { "\(Self.self).signedUpKey" }
    
    public init(memoryStorage: MemoryStorage) {
        self.memoryStorage = memoryStorage
    }
    
    public func signUp(email: String, password: String) -> AnyPublisher<VoidResult, Never> {
        saveCredentials()
        let publisher: Just<VoidResult> = Just(Result.success(()))
        return publisher.eraseToAnyPublisher()
    }
    
    public func signIn(email: String, password: String) -> AnyPublisher<VoidResult, Never> {
        if isSignedUp {
            saveCredentials()
            let publisher: Just<VoidResult> = Just(Result.success(()))
            return publisher.eraseToAnyPublisher()
        }
        let publisher: Just<VoidResult> = Just(Result.failure(.unathorized))
        return publisher.eraseToAnyPublisher()
    }
    
    public func signOut() -> AnyPublisher<VoidResult, Never> {
        removeCredentials()
        let publisher: Just<VoidResult> = Just(Result.success(()))
        return publisher.eraseToAnyPublisher()
    }
    
    private func saveCredentials() {
        memoryStorage.add(object: true, forKey: signedInKey)
        memoryStorage.add(object: true, forKey: signedUpKey)
    }
    
    private func provideIsSignedUp() -> Bool {
        memoryStorage.object(forKey: signedUpKey) ?? false
    }
    
    private func provideIsSignedIn() -> Bool {
        memoryStorage.object(forKey: signedInKey) ?? false
    }
    
    private func removeCredentials() {
        memoryStorage.removeObject(forKey: signedInKey)
    }
}
