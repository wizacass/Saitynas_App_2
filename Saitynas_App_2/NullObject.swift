import Foundation

class NullObject {
    private static let staticInstance = NullObject()

    static var instance: NullObject {
        return staticInstance
    }
}
