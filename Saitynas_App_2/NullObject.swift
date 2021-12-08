import Foundation

class NullObject: Codable {
    private static let staticInstance = NullObject()

    static var instance: NullObject {
        return staticInstance
    }
}
