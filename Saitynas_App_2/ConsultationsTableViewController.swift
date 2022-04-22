import UIKit

class ConsultationsTableViewController: UITableViewController {

    var viewModel: ConsultationsTableViewModel!

    private let id = UUID()

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }

    private func initialize() {
        let communicator = DIContainer.shared.communicator

        if viewModel == nil {
            viewModel = ConsultationsTableViewModel(communicator)
        }

        viewModel.subscribe(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.loadSpecialists()

        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        viewModel.unsubscribe(self)

        super.viewWillDisappear(animated)
    }
}

// MARK: - Table view data source
extension ConsultationsTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(.consultationCell, for: indexPath) as? ConsultationsTableViewCell
        let consultation = viewModel.getConsultation(at: indexPath.row)

        cell?.consultation = consultation

        return cell!
    }
}

// MARK: - Data source observer
extension ConsultationsTableViewController: DataSourceObserverDelegate {
    func onDataSourceUpdated<T>(_ source: T?) {
        DispatchQueue.main.async(execute: tableView.reloadData)
    }

    var observerId: UUID {
        return id
    }
}
