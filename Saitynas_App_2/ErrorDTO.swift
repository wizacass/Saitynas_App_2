import Foundation

struct ErrorDTO: Codable {
    let type: Int
    let title: String
    let details: String?
}
