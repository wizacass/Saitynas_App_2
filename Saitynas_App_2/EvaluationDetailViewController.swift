import UIKit

class EvaluationDetailViewController: UIViewController {

    @IBOutlet weak var specialistNameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var buttonsView: UIStackView!

    var viewModel: EvaluationViewModel!

    private let dateFormatter = DateFormatter()

    private var isOwner: Bool {
        return viewModel.evaluation.author == DIContainer.shared.jwtUser.email
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        buttonsView.isHidden = !isOwner

        setupView(viewModel.evaluation)
    }

    private func setupView(_ evaluation: Evaluation) {
        specialistNameLabel.text = evaluation.specialist
        ratingLabel.text = "\(evaluation.value)/10"
        commentLabel.text = evaluation.comment
        authorLabel.text = evaluation.author
        dateLabel.text = "Written at: \(evaluation.createdAt.formattedDate)"
    }
}
