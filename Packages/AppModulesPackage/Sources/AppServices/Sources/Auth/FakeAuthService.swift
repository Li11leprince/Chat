//  

import Foundation


public final class FakeAuthServiceImpl: AuthService {
    public var authState: AuthState = .signedOut
    
    public init() {}
    public func signUp() {
        print("SignUP")
    }
    
    public func signIn() {
        print("SingIn")
    }
    
    public func signOut() {
        print("SingOut")
    }
    
    public func isLoggedIn() -> Bool {
        false
    }
    
    
}
