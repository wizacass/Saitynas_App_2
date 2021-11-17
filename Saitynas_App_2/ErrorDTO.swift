import Foundation

struct ErrorDTO: Codable {
    let type: Int
    let title: String
    let details: String?
}

// MARK: - Initializers
extension ErrorDTO {
    init(_ title: String) {
        type = -1
        self.title = title
        details = nil
    }
}

// MARK: - Predefined errors
extension ErrorDTO {
    static var TokenExpiredError: ErrorDTO {
        return ErrorDTO(type: 401, title: "token_expired", details: nil)
    }

    static func serializationError(_ details: String? = nil) -> ErrorDTO {
        return ErrorDTO(type: -1, title: "serialization_error", details: details)
    }
}
