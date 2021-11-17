import Foundation

protocol ObserverDelegate: AnyObject {
    var observerId: UUID { get }
}
