import Foundation

struct WorkplacesDTO: Codable {
    let meta: MetaDTO
    let data: [Workplace]
}
