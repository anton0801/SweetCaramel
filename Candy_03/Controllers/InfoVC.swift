import UIKit

class InfoVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func backPressed(_ sender: UIButton) {
        popViewController()
    }
}
