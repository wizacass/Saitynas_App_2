import UIKit

class CreateEvaluationViewController: UIViewController {
    
    @IBOutlet weak var rolePicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rolePicker.delegate = self
        rolePicker.dataSource = self
    }
    
}

// MARK: - Role picker Data Source
extension CreateEvaluationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }
    
    //    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    //        viewModel.selectedRoleIndex = row
    //    }
}
