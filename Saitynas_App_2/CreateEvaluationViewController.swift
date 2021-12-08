import UIKit

class CreateEvaluationViewController: UIViewController {
    
    @IBOutlet weak var commentInput: InputField!
    @IBOutlet weak var rolePicker: UIPickerView!
    
    var viewModel: CreateReviewViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rolePicker.delegate = self
        rolePicker.dataSource = self
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        viewModel.sendReview(commentInput.text ?? "") { [weak self] in
            self?.dismiss(animated: true, completion: nil)
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
