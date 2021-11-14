import Foundation

struct MessageDTO: Codable {
    let meta: MetaDTO
    let data: Message
}

struct Message: Codable {
    let message: String
}
