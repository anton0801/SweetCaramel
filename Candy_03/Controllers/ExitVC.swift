//
//  ExitVC.swift
//  Candy_03
//
//  Created by Behruz Norov on 30/10/24.
//

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
