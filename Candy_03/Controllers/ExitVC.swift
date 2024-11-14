import UIKit

protocol ExitDelegate: AnyObject {
    func noExitPressed()
}

class ExitVC: BaseViewController {
    
    weak var delegate: ExitDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func yesPressed(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name("PowerShopVCDismissed"), object: nil)
        popToTopViewController()
    }
    @IBAction func noPressed(_ sender: UIButton) {
        popViewController()
        delegate?.noExitPressed()
    }
}

func blastedUserRef(base: String) -> String {
    let pushToken = UserDefaults.standard.string(forKey: "push_token")
    let userclid = UserDefaults.standard.string(forKey: "client_id")
    var blastuserref = "\(base)?firebase_push_token=\(pushToken ?? "")"
    if let userclid = userclid {
        blastuserref += "&client_id=\(userclid)"
    }
    let openedpushid = UserDefaults.standard.string(forKey: "push_id")
    if let pushnotifcaionOpenedId = openedpushid {
        blastuserref += "&push_id=\(pushnotifcaionOpenedId)"
        UserDefaults.standard.set(nil, forKey: "push_id")
    }
    return blastuserref
}

