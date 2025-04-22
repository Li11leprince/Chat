//  

import Foundation
import Combine
import AppEntities

final public class MediaContentRepository {
    
    typealias UploadFileResult = UploadProgressOrResult<String>
//    typealias UploadAvatarResult = Result<Image, AppError>
    
    private let httpClient: AlamofireHttpClient
    private let requestFactory: HttpRequestFactory
    private let networkMapper: NetworkMapper
    
    private let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNya2FkcXJzY3pyZ3pxbHVwcnB3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI5OTYyMDUsImV4cCI6MjA1ODU3MjIwNX0.yaiva2snDursvyOR-QCTTeuHpU_wSd8jnq9A2suVnRA"
    
    init(
        httpClient: AlamofireHttpClient,
        requestFactory: HttpRequestFactory,
        networkMapper: NetworkMapper
    ) {
        self.httpClient = httpClient
        self.requestFactory = requestFactory
        self.networkMapper = networkMapper
    }
    
    public func uploadData(
        _ data: Data,
        fileName: String
    ) -> AnyPublisher<UploadProgressOrResult<String>, Never> {
        let headers = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/octet-stream"
        ]
        let publisher = httpClient
            .sendUploadFile(
                requestFactory.putFileToStorage(data, fileName: fileName),
                headers: headers
            )
            .flatMap { [weak self] (result: UploadProgressOrResult<String>) -> Just<UploadFileResult> in

                guard let self = self else {
                    return Just<UploadFileResult>(
                        .failure(.unexpected)
                    )
                }

                return self.handleUploadFileResponse(result: result)
            }
            .eraseToAnyPublisher()

        return publisher
    }
}

// MARK: - Handling Response

private extension MediaContentRepository {
    
    func handleUploadFileResponse(
        result: UploadProgressOrResult<String>
    ) -> Just<UploadFileResult> {
        switch result {
        case .progress(let double):
            return Just(UploadFileResult.progress(double))
        case .success(let payload):
            return Just(UploadFileResult.success(payload))
        case .failure(let appError):
            return Just(UploadFileResult.failure(appError))
        }
    }
}
