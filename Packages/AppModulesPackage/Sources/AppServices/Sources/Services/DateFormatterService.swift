//  

import Foundation

public protocol DateFormatting {
    func formatTime(from timestamp: Double) -> String
    func formatRelativeDate(from timestamp: Double) -> String
    func formatMessageDate(from timestamp: Double) -> String
}

public class DefaultDateFormatterService: DateFormatting {
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()
    
    private let relativeFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter
    }()

    public func formatTime(from timestamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        return timeFormatter.string(from: date)
    }

    public func formatRelativeDate(from timestamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        return relativeFormatter.localizedString(for: date, relativeTo: Date())
    }
    
    public func formatMessageDate(from timestamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        return dateFormatter.string(from: date)
    }
}
