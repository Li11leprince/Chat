//  

import Foundation
import Combine
import AppEntities

final public class MediaContentRepository {
    
    public typealias UploadFileResult = LoadingProgressOrResult<String>
    public typealias DownloadFileResult = LoadingProgressOrResult<URL>
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
    
    public func uploadFile(
        _ data: Data,
        fileName: String
    ) -> AnyPublisher<UploadFileResult, Never> {
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        let publisher = httpClient
            .sendUploadFile(
                requestFactory.putFileToStorage(data, fileName: fileName),
                payloadType: UploadFilePayload.self,
                headers: headers
            )
            .flatMap { [weak self] (result: LoadingProgressOrResult<UploadFilePayload>) -> Just<UploadFileResult> in

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
    
    public func downloadFile(
        _ url: String
    ) -> AnyPublisher<DownloadFileResult, Never> {
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        let publisher = httpClient
            .sendDownloadFile(url, headers: headers)
            .flatMap { [weak self] (result: LoadingProgressOrResult<URL>) -> Just<DownloadFileResult> in

                guard let self = self else {
                    return Just<DownloadFileResult>(
                        .failure(.unexpected)
                    )
                }

                return self.handleDownloadFileResponse(result: result)
            }
            .eraseToAnyPublisher()
        
        return publisher
    }
}

// MARK: - Payload types

struct UploadFilePayload: Decodable {
    let Key: String
    let Id : String
}

// MARK: - Handling Response

private extension MediaContentRepository {
    
    func handleUploadFileResponse(
        result: LoadingProgressOrResult<UploadFilePayload>
    ) -> Just<UploadFileResult> {
        switch result {
        case .success(let payload):
            let url = networkMapper.publicFileUrl(from: payload)
            return Just(UploadFileResult.success(url))
        case .failure(let appError):
            return Just(UploadFileResult.failure(appError))
        case .progress(let progress):
            return Just(UploadFileResult.progress(progress))
        }
    }
    
    func handleDownloadFileResponse(
        result: LoadingProgressOrResult<URL>
    ) -> Just<DownloadFileResult> {
        switch result {
        case .success(let payload):
            return Just(DownloadFileResult.success(payload))
        case .failure(let appError):
            return Just(DownloadFileResult.failure(appError))
        case .progress(let progress):
            return Just(DownloadFileResult.progress(progress))
        }
    }
}

// MARK: - Mapper

extension NetworkMapper {
    fileprivate func publicFileUrl(from payload: UploadFilePayload) -> String {
        return "\(InfoPlist.apiMediaStorage)/public/\(payload.Key)"
    }
}
