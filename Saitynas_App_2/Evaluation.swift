import Foundation

struct Evaluation: Codable {
    let id: Int?
    let specialist: String
    let author: String
    let createdAt: String
    let value: Int
    let comment: String?
    let specialistId: Int
    let consultationId: String?
}
