import UIKit

class EvaluationDetailViewController: UIViewController {

    @IBOutlet weak var specialistNameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var buttonsView: UIStackView!

    var viewModel: EvaluationViewModel!

    weak var previousViewController: UIViewController?

    private var communicator: Communicator!

    private let dateFormatter = DateFormatter()
    private let id = UUID()

    private var isOwner: Bool {
        return viewModel.evaluation.author == DIContainer.shared.jwtUser.email
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        buttonsView.isHidden = !isOwner
        communicator = DIContainer.shared.communicator
    }

    override func viewWillAppear(_ animated: Bool) {
        setupView(viewModel.evaluation)

        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        previousViewController?.viewWillAppear(true)

        super.viewWillDisappear(animated)
    }

    @IBAction func editButtonPressed(_ sender: UIButton) {
        if let viewController =
            storyboard?.instantiateViewController(.createEvaluationViewController) as? CreateEvaluationViewController {
            let evaluationViewModel = EditReviewViewModel(communicator, viewModel.evaluation)
            evaluationViewModel.subscribe(self)

            viewController.viewModel = evaluationViewModel

            present(viewController, animated: true, completion: nil)
        }
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

extension EvaluationDetailViewController: DataSourceObserverDelegate {
    var observerId: UUID {
        return id
    }

    func onDataSourceUpdated<T>(_ source: T?) {
        guard let evaluation = source as? Evaluation else { return }

        viewModel.evaluation = evaluation
        setupView(evaluation)
    }
}
