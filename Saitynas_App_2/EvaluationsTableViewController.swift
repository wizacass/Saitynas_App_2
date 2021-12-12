import UIKit

class EvaluationsTableViewController: UITableViewController {

    var viewModel: EvaluationsTableViewModel!

    private var email: String!

    private let id = UUID()

    private let sectionInfo: [(header: String, footer: String)] = [
        ("All Evaluations", "Total rating: "),
        ("My Evaluations", "")
    ]

    private let evaluationColors = [
        UIColor.fromColorCode(.badEval),
        UIColor.fromColorCode(.mehEval),
        UIColor.fromColorCode(.normalEval),
        UIColor.fromColorCode(.goodEval),
        UIColor.fromColorCode(.awesomeEval)
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
            cell.imageView?.tintColor = selectEvaluationImageColor(evaluation.value)
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

    private func selectEvaluationImageColor(_ rating: Int) -> UIColor? {
        switch rating {
        case 0...3:
            return evaluationColors[0]
        case 4...7:
            return evaluationColors[2]
        case 8...10:
            return evaluationColors[3]
        default:
            return evaluationColors[4]
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let evaluation = getEvaluation(indexPath) else { return }
        if let viewController =
            storyboard?.instantiateViewController(.evaluationDetailViewController) as? EvaluationDetailViewController {
            viewController.viewModel = EvaluationViewModel(evaluation)
            viewController.evaluationsViewController = self

            present(viewController, animated: true, completion: nil)
        }
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
