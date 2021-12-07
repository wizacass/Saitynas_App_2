import UIKit

class EvaluationsTableViewController: UITableViewController {

    private let sectionInfo: [(header: String, footer: String)] = [
        ("My Evaluations", ""),
        ("All Evaluations", "Total rating: ")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionInfo.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(.evaluationCell, for: indexPath)

        cell.textLabel?.text = "10/10"
        cell.detailTextLabel?.text = "Zjbs"

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionInfo[section].header
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        var footer = sectionInfo[section].footer

        if section == 1 {
            footer += "x/10"
        }

        return footer
    }
}
