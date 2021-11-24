import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var rolePicker: UIPickerView!

    private var viewModel: SignupViewModel!

    private let id = UUID()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = SignupViewModel(DIContainer.shared.communicator)
        viewModel.subscribe(self)
        viewModel.loadRoles()

        rolePicker.delegate = self
        rolePicker.dataSource = self
    }

    @IBAction func signupButtonPressed(_ sender: UIButton) {
        guard
            let email = emailInput.text,
            let password = passwordInput.text
        else { return }

        viewModel.signup(email, password)
    }
}

// MARK: - Role picker Data Source
extension SignupViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.roles.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.roles[row].name
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.selectedRoleId = row
    }
}

extension SignupViewController: DataSourceObserverDelegate {
    var observerId: UUID {
        return id
    }

    func onDataSourceUpdated<T>(_ source: T?) {
        DispatchQueue.main.async(execute: rolePicker.reloadAllComponents)
    }
}
