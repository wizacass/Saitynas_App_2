import Foundation

struct Specialist: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let speciality: String
    let address: String?
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
}
