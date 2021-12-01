import UIKit

class WorkplaceTableViewController: UITableViewController {

    private var viewModel: WorkplaceTableViewModel!

    private let id = UUID()

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }

    private func initialize() {
        let communicator = DIContainer.shared.communicator
        viewModel = WorkplaceTableViewModel(communicator)
        viewModel.subscribe(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        viewModel.unsubscribe(self)

        super.viewWillDisappear(animated)
    }
}

// MARK: - Table view data source
extension WorkplaceTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(.workplaceCell, for: indexPath)
        let workplace = viewModel.getWorkplace(at: indexPath.row)

        cell.textLabel?.text = workplace.address
        cell.detailTextLabel?.text = workplace.city

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let workplaceId = viewModel.getWorkplace(at: indexPath.row).id
//        if let viewController = storyboard?.instantiateViewController(.specialistDetailViewController) as? SpecialistViewController {
//            viewController.specialistId = specialistId
//            navigationController?.pushViewController(viewController, animated: true)
//        }
    }
}

// MARK: - Data source observer
extension WorkplaceTableViewController: DataSourceObserverDelegate {
    func onDataSourceUpdated<T>(_ source: T?) {
        DispatchQueue.main.async(execute: tableView.reloadData)
    }

    var observerId: UUID {
        return id
    }
}
