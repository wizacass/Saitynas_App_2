import UIKit

class SpecialistEvaluationsNavigationViewController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()

        if let viewController =
            storyboard?.instantiateViewController(.evaluaionsTableViewController) as? EvaluationsTableViewController {
            viewController.viewModel = EvaluationsTableViewModel(DIContainer.shared.communicator)

            viewControllers.append(viewController)
        }
    }
}
