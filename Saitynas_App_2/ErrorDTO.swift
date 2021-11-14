import Foundation

struct Error: Codable {
    let type: Int
    let title: String
    let details: String?
}
