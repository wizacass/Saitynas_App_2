import UIKit

class EvaluationDetailViewController: UIViewController {

    @IBOutlet weak var specialistNameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var buttonsView: UIStackView!

    var viewModel: EvaluationViewModel!

    weak var evaluationsViewController: EvaluationsTableViewController?

    private var communicator: Communicator!

    private let dateFormatter = DateFormatter()

    private var isOwner: Bool {
        return viewModel.evaluation.author == DIContainer.shared.jwtUser.email
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        buttonsView.isHidden = !isOwner
        communicator = DIContainer.shared.communicator

        setupView(viewModel.evaluation)
    }

    @IBAction func editButtonPressed(_ sender: UIButton) {
    }

    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(
            title: "Are you sure?",
            message: "Your evaluation will be deleted permanently",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: deleteEvalaution))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    private func deleteEvalaution(_ action: UIAlertAction) {
        let id = viewModel.evaluation.id
        communicator.deleteEvaluation(id, onSuccess: handleDeletedEvaluation, onError: { _ in })
    }

    private func handleDeletedEvaluation(_ obj: NullObject?) {
        evaluationsViewController?.viewWillAppear(true)
        dismiss(animated: true, completion: nil)
    }

    private func setupView(_ evaluation: Evaluation) {
        specialistNameLabel.text = evaluation.specialist
        ratingLabel.text = "\(evaluation.value)/10"
        commentLabel.text = evaluation.comment
        authorLabel.text = evaluation.author
        dateLabel.text = "Written at: \(evaluation.createdAt.formattedDate)"
    }
}
