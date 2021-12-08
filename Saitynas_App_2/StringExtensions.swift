import Foundation

extension String {
    var formattedMessage: String {
        var formatted = prefix(1).capitalized + dropFirst()
        formatted = formatted.replacingOccurrences(of: "_", with: " ")

        return "\(formatted)!"
    }
}
