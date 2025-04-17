//  Copyright © 2022 Heramed-Mobile. All rights reserved.

import Foundation
import Alamofire

public struct HttpRequest<Params: Encodable> {
    let endpoint: String
    let method: HTTPMethod
    let params: Params?
    let encoder: ParameterEncoder

    public init(endpoint: String, method: HTTPMethod) {
        self.endpoint = endpoint
        self.method = method
        self.params = nil
        self.encoder = URLEncodedFormParameterEncoder.default
    }

    public init(endpoint: String, method: HTTPMethod, params: Params, encoder: ParameterEncoder) {
        self.endpoint = endpoint
        self.method = method
        self.params = params
        self.encoder = encoder
    }
}

public struct MultipartRequest {

    public struct MultipartParam {
        let data: Data
        let name: String
        let fileName: String?
        let mimeType: String?

        public init(
            data: Data,
            name: String,
            fileName: String? = nil,
            mimeType: String? = nil
        ) {
            self.data = data
            self.name = name
            self.fileName = fileName
            self.mimeType = mimeType
        }
    }

    let endpoint: String
    let multipartParams: [MultipartParam]

    public init(endpoint: String, multipartParams: [MultipartParam]) {
        self.endpoint = endpoint
        self.multipartParams = multipartParams
    }
}
