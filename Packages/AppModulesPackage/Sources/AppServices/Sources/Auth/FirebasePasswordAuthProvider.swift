//  

import Combine
import FirebaseAuth
import AppEntities

final public class FirebasePasswordAuthProvider: PasswordAuthProvider {
    
    public func signUp(email: String, password: String) -> AnyPublisher<Result<Credentials, AppError>, Never> {
        let future = Future<Result<Credentials, AppError>, Never> { promise in
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                guard error == nil else {
                    promise(.success(.failure(.undefined(causedError: error!))))
                    return
                }
                guard let authResult else {
                    promise(.success(.failure(.unexpected)))
                    return
                }
                let creds = Credentials(accessToken: authResult.credential?.accessToken ?? "")
                promise(.success(.success(creds)))
            }
        }
        .eraseToAnyPublisher()
        
        return future
    }
    
    public func signIn(email: String, password: String) -> AnyPublisher<Result<Credentials, AppError>, Never> {
        let future = Future<Result<Credentials, AppError>, Never> { promise in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                guard error == nil else {
                    promise(.success(.failure(.undefined(causedError: error!))))
                    return
                }
                guard let authResult else {
                    promise(.success(.failure(.unexpected)))
                    return
                }
                let creds = Credentials(accessToken: authResult.credential?.accessToken ?? "")
                promise(.success(.success(creds)))
            }
        }
        .eraseToAnyPublisher()
        
        return future
    }
    
    public func signOut() -> AnyPublisher<Result<Void, AppError>, Never> {
        let future = Future<Result<Void, AppError>, Never> { promise in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                promise(.success(.success(())))
            } catch let signOutError as NSError {
                promise(.success(.failure(.undefined(causedError: signOutError))))
            }
        }
        .eraseToAnyPublisher()
        
        return future
    }
}
