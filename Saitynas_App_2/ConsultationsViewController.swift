import UIKit

class ConsultationsViewController: UIViewController {

    @IBOutlet weak var specialityToggle: UISegmentedControl!
    @IBOutlet weak var specialityPicker: UIPickerView!

    private var viewModel: ConsultationsViewModel!

    private let id = UUID()

    override func viewDidLoad() {
        super.viewDidLoad()

        specialityPicker.disable()

        initialize()
    }

    private func initialize() {
        let c = DIContainer.shared

        viewModel = ConsultationsViewModel(c.communicator)

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

    @IBAction func specialityToggleChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            specialityPicker.disable()
        } else {
            specialityPicker.enable()
        }
    }

    @IBAction func searchButtonPressed(_ sender: PrimaryButton) {
        let specialist = specialityToggle.selectedSegmentIndex == 0 ?
            "any specialist" :
            viewModel.speciality[viewModel.selectedSpecialityIndex].name

        print("Searching for \(specialist)")
    }
}

// MARK: - Speciality picker Data Source
extension ConsultationsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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

extension ConsultationsViewController: DataSourceObserverDelegate {
    var observerId: UUID {
        return id
    }

    func onDataSourceUpdated<T>(_ source: T?) {
        DispatchQueue.main.async(execute: specialityPicker.reloadAllComponents)
    }
}
