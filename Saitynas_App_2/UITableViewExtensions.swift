import UIKit

extension UITableView {
    func dequeueReusableCell(_ identifier: CellIdentifier, for indexPath: IndexPath) -> UITableViewCell {
        let rawIdentifier = identifier.rawValue
        return self.dequeueReusableCell(withIdentifier: rawIdentifier, for: indexPath)
    }
}
