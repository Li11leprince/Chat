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
        return getDebouncedPublisher(isSuccess: true)
    }
    
    public func signIn(email: String, password: String) -> AnyPublisher<VoidResult, Never> {
        if isSignedUp {
            saveCredentials()
            return getDebouncedPublisher(isSuccess: true)
        }
        return getDebouncedPublisher(isSuccess: false)
    }
    
    public func signOut() -> AnyPublisher<VoidResult, Never> {
        removeCredentials()
        return getDebouncedPublisher(isSuccess: true)
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
    
    private func getDebouncedPublisher(isSuccess: Bool) -> AnyPublisher<VoidResult, Never> {
        let publisher = Just<VoidResult>(isSuccess ? .success(()) : .failure(.unathorized))
            .delay(for: .seconds(1.0), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
        
        return publisher
    }
}
