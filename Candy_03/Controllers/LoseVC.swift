import UIKit
protocol LoseDelegate: AnyObject {
    func restartGamee()
}
class LoseVC: BaseViewController {
    @IBOutlet weak var diamondLabel: UILabel!
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var lightingsLabel: UILabel!
    @IBOutlet weak var lightings: UILabel!
    
    
    weak var delegate: LoseDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        GameManager.shared.showCoinsInLabel(label: coinLabel, diamontLabel: diamondLabel)
    }
    
    func showLightings() {
        lightingsLabel.text = "\(GameManager.shared.getValue(key: "lighting") as! Int)/100"
    }

    @IBAction func menuPressed(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name("PowerShopVCDismissed"), object: nil)
        popToTopViewController()
    }
    @IBAction func tryAgainPressed(_ sender: UIButton) {
        if GameManager.shared.getValue(key: "lighting") as! Int >= 30 {
            popViewController()
            delegate?.restartGamee()
        } else {
            NotificationCenter.default.post(name: Notification.Name("PowerShopVCDismissed"), object: nil)
            popToTopViewController()
            showAlertMessage(title: "Insufficient Coins", message: "You don't have enough coins to retry game")
        }
    }
}
