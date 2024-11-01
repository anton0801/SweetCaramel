//
//  VictoryVC.swift
//  Candy_03
//
//  Created by Behruz Norov on 30/10/24.
//

import UIKit

protocol VictoryDelegate: AnyObject {
    func restartGame()
}

class VictoryVC: BaseViewController {
    @IBOutlet weak var diamondLabel: UILabel!
    @IBOutlet weak var coinLabel: UILabel!
    
    
    weak var delegate: VictoryDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        GameManager.shared.showCoinsInLabel(label: coinLabel, diamontLabel: diamondLabel)
    }
    
    @IBAction func menuPressed(_ sender: UIButton) {        NotificationCenter.default.post(name: Notification.Name("PowerShopVCDismissed"), object: nil)
        popToTopViewController()
    }
    
    @IBAction func okeyPressed(_ sender: UIButton) {
        popViewController()
        delegate?.restartGame()
    }
}
