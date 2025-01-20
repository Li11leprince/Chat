//  

import Foundation
import Combine
import AppEntities

public protocol PasswordAuthProvider {
    func signIn(email: String, password: String) -> AnyPublisher<Result<Credentials, AppError>, Never>
    func signUp(email: String, password: String) -> AnyPublisher<Result<Credentials, AppError>, Never>
    func signOut() -> AnyPublisher<Result<Void, AppError>, Never>
}
