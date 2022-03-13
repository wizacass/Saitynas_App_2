import UIKit

class SpecialistInfoViewController: AccessControllerBase {

    @IBOutlet weak var firstNameTextField: InputField!
    @IBOutlet weak var lastNameTextField: InputField!
    @IBOutlet weak var cityTextField: InputField!
    @IBOutlet weak var specialityPicker: UIPickerView!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    private var viewModel: SpecialistInfoViewModel!

    private var authenticationManager: AuthenticationManager?

    private let id = UUID()

    override func viewDidLoad() {
        super.viewDidLoad(bottomConstraint)

        initialize()
    }

    private func initialize() {
        let c = DIContainer.shared

        authenticationManager = c.authenticationManager

        viewModel = SpecialistInfoViewModel(c.communicator, c.preferences)

        specialityPicker.delegate = self
        specialityPicker.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.subscribe(self)
        viewModel.loadRoles()
    }

    override func viewWillDisappear(_ animated: Bool) {
        viewModel.unsubscribe(self)

        super.viewWillDisappear(animated)
    }

    @IBAction func submitButtonPressed(_ sender: PrimaryButton) {
        guard
            let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let city = cityTextField.text
        else { return }

        viewModel.createPatient(
            firstName, lastName, city,
            onSuccess: handleSpecialistCreated,
            onError: handleError
        )
    }

    private func handleSpecialistCreated() {
        if let viewController = storyboard?.instantiateViewController(.specialistTabBarViewController) {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }

    @IBAction func laterButtonPressed(_ sender: UIButton) {
        authenticationManager?.logout()
    }
}

// MARK: - Role picker Data Source
extension SpecialistInfoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.speciality.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.speciality[row].name
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.selectedSpecialityIndex = row
    }
}

extension SpecialistInfoViewController: DataSourceObserverDelegate {
    var observerId: UUID {
        return id
    }

    func onDataSourceUpdated<T>(_ source: T?) {
        DispatchQueue.main.async(execute: specialityPicker.reloadAllComponents)
    }
}
