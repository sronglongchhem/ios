import UIKit
import Utils

class DummyLabelCell: BaseTableViewCell<String> {

    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func configure(with text: String) {
        label.text = text
    }
}
