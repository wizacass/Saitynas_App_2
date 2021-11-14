import Foundation

struct MessageDto: Codable {
    let meta: Meta
    let data: Message
}

struct Message: Codable {
    let message: String
}
