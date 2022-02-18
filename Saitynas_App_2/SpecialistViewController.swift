import UIKit

class SpecialistViewController: UIViewController {

    var specialistId: Int?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var specialityLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!

    private let id = UUID()

    private var viewModel: SpecialistViewModel!
    private weak var communicator: Communicator!

    override func viewDidLoad() {
        super.viewDidLoad()

        communicator = DIContainer.shared.communicator
        viewModel = SpecialistViewModel(communicator)
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.subscribe(self)

        if let specialistId = specialistId {
            viewModel.loadSpecialist(id: specialistId)
        }

        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        viewModel.unsubscribe(self)

        super.viewWillDisappear(animated)
    }

    @IBAction func evaluationsButtonPressed(_ sender: UIButton) {
        if let viewController = storyboard?.instantiateViewController(.evaluaionsTableViewController)
            as? EvaluationsTableViewController {
            viewController.viewModel = EvaluationsTableViewModel(communicator, specialistId ?? 0)

            navigationController?.pushViewController(viewController, animated: true)
        }
    }

    @IBAction func createEvaluationButtonPressed(_ sender: UIButton) {
        if let viewController = storyboard?.instantiateViewController(.createEvaluationViewController)
            as? CreateEvaluationViewController {
            viewController.viewModel = CreateReviewViewModel(communicator, specialistId ?? 0)

            present(viewController, animated: true, completion: nil)
        }
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
        ratingLabel.text = "Reviews"
    }
}
