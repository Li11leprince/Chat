//  

import Foundation

public enum AuthState {
    case signedIn
    case signedOut
    case signUp
}

public protocol AuthService {
    var authState: AuthState { get }
    func signUp()
    func signIn()
    func signOut()
    func isLoggedIn() -> Bool
}

//public final class AuthServiceImpl: AuthService {
//    public init() {
//        
//    }
//    
//    public func signUp() {
//        <#code#>
//    }
//    
//    public func signIn() {
//        <#code#>
//    }
//    
//    public func signOut() {
//        <#code#>
//    }
//    
//    public func isLoggedIn() -> Bool {
//        false
//    }
//    
//    
//}
