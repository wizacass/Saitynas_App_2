import Foundation

struct Patient: Codable {
    let firstName: String
    let lastName: String
    let birthDate: String
    let city: String

    init(_ firstName: String, _ lastName: String, _ birthDate: Date, _ city: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        self.firstName = firstName
        self.lastName = lastName
        self.birthDate = formatter.string(from: birthDate)
        self.city = city
    }
}
