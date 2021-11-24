import Foundation

struct EnumListDTO: Codable {
    let meta: MetaDTO
    let data: [EnumDTO]
}
