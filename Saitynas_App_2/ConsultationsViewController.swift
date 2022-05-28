import UIKit

class ConsultationsViewController: UIViewController {

    @IBOutlet weak var activeSpecialistsCountLabel: UILabel!

    @IBOutlet weak var specialityToggle: UISegmentedControl!
    @IBOutlet weak var specialityPicker: UIPickerView!

    private var viewModel: ConsultationsViewModel!
    private var consultationsService: ConsultationsService?
    private var communicator: Communicator?

    private var totalSpecialistsCount: Int? {
        didSet { updateSpecialistsCountLabel() }
    }

    private let id = UUID()

    override func viewDidLoad() {
        super.viewDidLoad()

        specialityPicker.disable()

        initialize()
    }

    private func initialize() {
        let c = DIContainer.shared

        viewModel = ConsultationsViewModel(c.communicator)
        consultationsService = c.consultationsService
        communicator = c.communicator

        specialityPicker.delegate = self
        specialityPicker.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.subscribe(self)
        viewModel.loadRoles()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        communicator?.getOnlineSpecialistsCount(onSuccess: { [weak self] dto in
            guard let count = dto?.data.count else { return }

            self?.totalSpecialistsCount = count
        }, onError: { error in
            print("Error in retrieving active specialists count: \(error?.title ?? "FATAL ERROR")")
        })
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

        updateSpecialistsCountLabel()
    }

    @IBAction func searchButtonPressed(_ sender: PrimaryButton) {
        var specialityId: Int?

        if specialityToggle.selectedSegmentIndex != 0 {
            specialityId = viewModel.activeSpeciality.id
        }

        consultationsService?.requestConsultation(specialityId, onSuccess: handleConsultationRequested)
    }

    private func handleConsultationRequested() {
        guard let viewController = storyboard?.instantiateViewController(.consultationSearchViewController) else {
            return
        }

        navigationController?.pushViewController(viewController, animated: true)
    }

    private func updateSpecialistsCountLabel() {
        var text: String

        if specialityToggle.selectedSegmentIndex == 0 {
            text = "Total available specialists: \(totalSpecialistsCount ?? 0)"
        } else {
            let speciality = viewModel.activeSpeciality
            text = "Available \(speciality.name) specialists: \(speciality.activeSpecialists)"
        }

        activeSpecialistsCountLabel.text = text
    }
}

// MARK: - Speciality picker Data Source
extension ConsultationsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.specialities.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.specialities[row].name
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.selectedSpecialityIndex = row
        updateSpecialistsCountLabel()
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
