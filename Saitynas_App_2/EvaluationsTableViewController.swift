import UIKit

class EvaluationsTableViewController: UITableViewController {

    var viewModel: EvaluationsTableViewModel!

    private var email: String!

    private let id = UUID()

    private let sectionInfo: [(header: String, footer: String)] = [
        ("All Evaluations", "Total rating: "),
        ("My Evaluations", "")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        email = DIContainer.shared.jwtUser.email
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.subscribe(self)
        viewModel.loadSpecialistEvaluations()

        super.viewWillAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        viewModel.unsubscribe(self)

        super.viewDidDisappear(animated)
    }
}

// MARK: - Table view data source
extension EvaluationsTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        var count = sectionInfo.count

        if viewModel.getFilteredEvaluations(email).count == 0 {
            count -= 1
        }

        return count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.count
        case 1:
            return viewModel.getFilteredEvaluations(email).count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(.evaluationCell, for: indexPath)

        if let evaluation = getEvaluation(indexPath) {
            cell.textLabel?.text = evaluation.author
            cell.detailTextLabel?.text = evaluation.comment
            cell.imageView?.image = UIImage.init(systemName: "\(evaluation.value).circle")
        }

        return cell
    }

    private func getEvaluation(_ indexPath: IndexPath) -> Evaluation? {
        let index = indexPath.row

        switch indexPath.section {
        case 0:
            return viewModel.getEvaluation(at: index)
        case 1:
            return viewModel.getFilteredEvaluations(email)[index]
        default:
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionInfo[section].header
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        var footer = sectionInfo[section].footer

        if section == 0 {
            footer += "\(viewModel.averageRating)/10"
        }

        return footer
    }
}

extension EvaluationsTableViewController: DataSourceObserverDelegate {
    func onDataSourceUpdated<T>(_ source: T?) {
        DispatchQueue.main.async(execute: tableView.reloadData)
    }

    var observerId: UUID {
        return id
    }
}
