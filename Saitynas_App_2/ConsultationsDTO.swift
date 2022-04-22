import Foundation

struct ConsultationsDTO: Codable {
    let meta: MetaDTO
    let data: [Consultation]
}
