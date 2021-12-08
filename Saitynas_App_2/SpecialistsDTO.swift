import Foundation

struct SpecialistsDTO: Codable {
    let meta: MetaDTO
    let data: [Specialist]
}
