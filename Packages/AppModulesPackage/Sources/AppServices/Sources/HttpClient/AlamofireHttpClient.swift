//  

import Foundation
import Alamofire
import Combine
import AppEntities

public class AlamofireHttpClient {
    private let session: Session
    
    public init(
        urlSessionConfiguration: URLSessionConfiguration,
        requestInterceptor: RequestInterceptor,
        eventMonitors: [EventMonitor]
    ) {
        self.session = Session(
            configuration: urlSessionConfiguration,
            interceptor: requestInterceptor,
            eventMonitors: eventMonitors
        )
    }
    
    public func sendRequest<Params: Encodable, Payload: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        params: Params?,
        encoder: ParameterEncoder,
        payloadType: Payload.Type
    ) -> AnyPublisher<Result<Payload, AppError>, Never> {

        session.request(
            endpoint,
            method: method,
            parameters: params,
            encoder: encoder,
            headers: nil,
            interceptor: nil,
            requestModifier: nil
        )
        .processResponse()
    }
}

// MARK: - AlamofireHttpClient + HttpRequest

extension AlamofireHttpClient {

    public func sendRequest<Params: Encodable, Payload: Decodable>(
        _ request: HttpRequest<Params>,
        payloadType: Payload.Type
    ) -> AnyPublisher<Result<Payload, AppError>, Never> {
        sendRequest(
            endpoint: request.endpoint,
            method: request.method,
            params: request.params,
            encoder: request.encoder,
            payloadType: Payload.self
        )
    }
}

extension DataRequest {

    func processResponse<Payload: Decodable>(
//        errorMapper: ResponseErrorMapper
    ) -> AnyPublisher<Result<Payload, AppError>, Never> {
        self
            .validate(statusCode: 200..<500)
            .publishDecodable(
                type: Payload.self,
                queue: DispatchQueue.global(qos: .utility)
            )
            .value()
            .mapError { (afError: AFError) -> AppError in
                
                let error = AppError.network(causedByError: afError)
                return error
            }
            .tryMap { (httpResponse: Payload) -> Payload in
//                if let error = httpResponse.error {
//                    throw errorMapper.makeAppError(from: error)
//                }

//                if let payload = httpResponse.data {
//                    return payload
//                }

                return httpResponse
//                throw AppError.undefined(
//                    causedError: AnyLocalizedError(failureMessage: "Response is empty")
//                )
            }
            .mapError {
                guard let appError = $0 as? AppError else {
                    return AppError.network(causedByError: AnyLocalizedError.unexpected)
                }
                return appError
            }
            .map { (payload: Payload) -> Result<Payload, AppError> in
                .success(payload)
            }
            .catch { (error: AppError) -> Just<Result<Payload, AppError>> in
                Just(.failure(error))
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

