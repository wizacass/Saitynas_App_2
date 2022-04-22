import UIKit

class ConsultationsTableViewCell: UITableViewCell {

    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var startedAtLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!

    private let timeFormatter = TimeFormatter()

    var consultation: Consultation? {
        didSet {
            patientNameLabel.text = consultation?.patientName
            startedAtLabel.text = "Consultation began: \(consultation?.startDate.formattedDateTime ?? "")"
            durationLabel.text = "Duration: \(timeFormatter.formatTime(seconds: consultation?.duration))"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
