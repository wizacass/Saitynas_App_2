import UIKit

class CreateEvaluationViewController: ViewWithKeyboardBase {
    
    @IBOutlet weak var commentInput: InputField!
    @IBOutlet weak var rolePicker: UIPickerView!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    var viewModel: ReviewViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad(bottomConstraint)
        
        rolePicker.delegate = self
        rolePicker.dataSource = self

        if let viewModel = viewModel as? EditReviewViewModel {
            commentInput.text = viewModel.evaluation.comment
        }
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        switch viewModel {
        case let viewModel as CreateReviewViewModel:
            viewModel.sendReview(commentInput.text ?? "") { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
        case let viewModel as EditReviewViewModel:
            viewModel.editReview(commentInput.text ?? "") { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
        default:
            return
        }
    }
}

// MARK: - Role picker Data Source
extension CreateEvaluationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.reviews.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(viewModel.reviews[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.selectedIndex = row
    }
}
