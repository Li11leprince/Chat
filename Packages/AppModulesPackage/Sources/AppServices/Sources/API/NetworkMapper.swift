

import Foundation

// MARK: - NetworkMapper

public final class NetworkMapper {

    private static var logger: Logger { LoggerFactory.default }

    private let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.formatOptions = [
            .withFullDate,
            .withFullTime,
            .withDashSeparatorInDate,
            .withFractionalSeconds
        ]

        return formatter
    }()

    public init() {}

    public func convertToDate(_ string: String) -> Date {
        guard let date = dateFormatter.date(from: string) else {
            Self.logger.error(
                message: "\(string) cannot be converted to Date type!"
            )
            return Date()
        }
        return date
    }
}


extension NetworkMapper {

}
