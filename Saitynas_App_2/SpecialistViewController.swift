import UIKit

class SpecialistViewController: UIViewController {

    var specialistId: Int?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var specialityLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!

    private let id = UUID()

    private var viewModel: SpecialistViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let communicator = DIContainer.shared.communicator
        viewModel = SpecialistViewModel(communicator)
        viewModel.subscribe(self)
    }

    override func viewDidAppear(_ animated: Bool) {
        if let specialistId = specialistId {
            viewModel.loadSpecialist(id: specialistId)
        }
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.unsubscribe(self)

        super.viewWillDisappear(animated)
    }
}

extension SpecialistViewController: DataSourceObserverDelegate {
    var observerId: UUID {
        return id
    }

    func onDataSourceUpdated<T>(_ source: T?) {
        guard let source = source as? Specialist else { return }

        nameLabel.text = source.fullName
        specialityLabel.text = source.speciality
        idLabel.text = "\(source.id)"
    }
}
