import UIKit

class ConsultationSearchViewController: UIViewController {
    
    @IBOutlet weak var spinnerImage: UIImageView!
    
    private var consultationsService: ConsultationsService?
    
    private let id = UUID()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
    }
    
    private func initialize() {
        let c = DIContainer.shared
        
        consultationsService = c.consultationsService
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        animateSpinner()
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        consultationsService?.subscribe(self)
    }
    
    private func animateSpinner() {
        UIView.animateKeyframes(withDuration: 2, delay: 0, options: [.calculationModeCubicPaced, .repeat]) {
            for i in 0 ..< 4 {
                UIView.addKeyframe(withRelativeStartTime: 0.25 * Double(i), relativeDuration: 0.25) { [weak self] in
                    let angle = CGFloat.pi / 2 * CGFloat(i + 1)
                    self?.spinnerImage.transform = CGAffineTransform(rotationAngle: angle)
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        consultationsService?.unsubscribe(self)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        consultationsService?.cancelConsultation { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

extension ConsultationSearchViewController: DataSourceObserverDelegate {
    var observerId: UUID {
        return id
    }
    
    func onDataSourceUpdated<T>(_ source: T?) {
        navigationController?.popViewController(animated: false)
    }
}
