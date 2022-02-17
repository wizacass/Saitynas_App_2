import UIKit

// swiftlint:disable type_name
class SpecialistEvaluationsNavigationViewController: UINavigationController {
// swiftlint:enable type_name

    override func viewDidLoad() {
        super.viewDidLoad()

        if let viewController =
            storyboard?.instantiateViewController(.evaluaionsTableViewController) as? EvaluationsTableViewController {
            viewController.viewModel = EvaluationsTableViewModel(DIContainer.shared.communicator)

            viewControllers.append(viewController)
        }
    }
}
