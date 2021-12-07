import Foundation

struct EvaluationsDTO: Codable {
    let meta: MetaDTO
    let data: [Evaluation]
}
