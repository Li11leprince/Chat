//  Copyright © 2022 Heramed-Mobile. All rights reserved.

import Foundation
import Alamofire

public struct HttpRequestFactory {

    public static var stub: HttpRequest<Params.None> {
        .init(endpoint: "", method: .get)
    }

    private let meadiaStorageUrlProviding: () -> String

    public init(meadiaStorageUrlProviding: @escaping () -> String) {
        self.meadiaStorageUrlProviding = meadiaStorageUrlProviding
    }

    private func endpointMediaStorage(for path: String) -> String {
        let base = meadiaStorageUrlProviding()
        return "\(base)/media/\(path)"
    }
}

// MARK: - Storage

extension HttpRequestFactory {

//    // MARK: - User Profile Requests
//
//    public func getUserProfile() -> HttpRequest<Params.None> {
//        .init(endpoint: endpointHb(for: "user/profile"), method: .get)
//    }
//    
//    public func postUserProfile(
//        params: Params.UserProfile
//    ) -> HttpRequest<Params.UserProfile> {
//        return .init(
//            endpoint: endpointHb(for: "user/profile"),
//            method: .post,
//            params: params,
//            encoder: JSONParameterEncoder.default
//        )
//    }
    
    public func putFileToStorage(_ data: Data, fileName: String) -> FileRequest {
        return .init(
            endpoint: endpointMediaStorage(for: fileName),
            data: data
        )
    }
}

// MARK: - Request Params

public struct Params {

    // It's used as workaround to provide explicit type for request
    public struct None: Encodable {}

    public struct RequestAuth: Encodable {
        let uuid: String
        let number: String
        let access: String = "user"
    }

    public struct ConfirmAuth: Encodable {
        let uuid: String
        let number: String
        let access: String = "user"
        let code: String
    }
    
    public struct UserProfile: Encodable {
        
    }
}
