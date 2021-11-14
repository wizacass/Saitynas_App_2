import Foundation

class SpecialistTableViewModel {

    var count: Int {
        return specialists.count
    }

    private var specialists: [Specialist] = []

    init() {
        specialists.append(Specialist(id: 1, firstName: "John", lastName: "Smith", speciality: "Doctor", address: nil))
        specialists.append(Specialist(id: 2, firstName: "Good", lastName: "Doktor", speciality: "GP", address: nil))
    }

    func getSpecialist(at index: Int) -> Specialist {
        return specialists[index]
    }

}
