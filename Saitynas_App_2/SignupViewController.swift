import UIKit

class SignupViewController: AccessControllerBase {

    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var rolePicker: UIPickerView!

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    private var viewModel: SignupViewModel!

    private let id = UUID()

    override func viewDidLoad() {
        super.viewDidLoad(bottomConstraint)

        initialize()
    }

    private func initialize() {
        let c = DIContainer.shared

        viewModel = SignupViewModel(c.communicator, c.authenticationManager)
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

        viewModel.signup(email, password) { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
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
        viewModel.selectedRoleIndex = row
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
