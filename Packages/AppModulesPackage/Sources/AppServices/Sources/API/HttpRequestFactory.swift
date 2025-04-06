//  Copyright © 2022 Heramed-Mobile. All rights reserved.

import Foundation
import Alamofire

public struct HttpRequestFactory {

    public static var stub: HttpRequest<Params.None> {
        .init(endpoint: "", method: .get)
    }

    private let baseUrlProviding: () -> String

    public init(baseUrlProviding: @escaping () -> String) {
        self.baseUrlProviding = baseUrlProviding
    }

    private func endpointHb(for path: String) -> String {
        let base = baseUrlProviding()
        return "\(base)/api/"
    }
}

// MARK: - Requests

extension HttpRequestFactory {

    // MARK: - User Profile Requests

    public func getUserProfile() -> HttpRequest<Params.None> {
        .init(endpoint: endpointHb(for: "user/profile"), method: .get)
    }
    
    public func postUserProfile(
        params: Params.UserProfile
    ) -> HttpRequest<Params.UserProfile> {
        return .init(
            endpoint: endpointHb(for: "user/profile"),
            method: .post,
            params: params,
            encoder: JSONParameterEncoder.default
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
