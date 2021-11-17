import UIKit

class SpecialistTableViewController: UITableViewController {
    
    private var viewModel: SpecialistTableViewModel!
    
    private let id = UUID()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
    }
    
    private func initialize() {
        let communicator = DIContainer.shared.communicator
        viewModel = SpecialistTableViewModel(communicator)
        viewModel.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.unsubscribe(self)
        
        super.viewWillDisappear(animated)
    }
}

// MARK: - Table view data source
extension SpecialistTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "specialistCell", for: indexPath)
        let specialist = viewModel.getSpecialist(at: indexPath.row)
        
        cell.textLabel?.text = specialist.fullName
        cell.detailTextLabel?.text = specialist.speciality
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let specialistId = viewModel.getSpecialist(at: indexPath.row).id
        if let viewController = storyboard?.instantiateViewController(.specialistDetailViewController) as? SpecialistViewController {
            viewController.specialistId = specialistId
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

// MARK: - Data source observer
extension SpecialistTableViewController: DataSourceObserverDelegate {
    func onDataSourceUpdated<T>(_ source: T?) {
        DispatchQueue.main.async(execute: tableView.reloadData)
    }
    
    var observerId: UUID {
        return id
    }
}
