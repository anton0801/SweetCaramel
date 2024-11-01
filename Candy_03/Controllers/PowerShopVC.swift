//
//  PowerShopVC.swift
//  Candy_03
//
//  Created by Behruz Norov on 30/10/24.
//

import UIKit

class PowerShopVC: BaseViewController {
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var diamondLabel: UILabel!
    @IBOutlet var xButtonOutlets: [UIButton]!
    @IBOutlet var amountLabels: [UILabel]!
    
    let keys = ["sugarSlowdown", "blastCandy", "sweetMultiplier"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showDataFromUD()
    }
    
    func showDataFromUD() {
        for power in amountLabels {
            power.text = "X\(GameManager.shared.getValue(key: keys[power.tag]) as! Int)"
        }
        for btn in xButtonOutlets {
            if btn.tag == GameManager.shared.getValue(key: "currentPower") as! Int {
                btn.setImage(UIImage(named: "selectedPower"), for: .normal)
            } else {
                btn.setImage(UIImage(named: "unselectedPower"), for: .normal)
            }
        }
        GameManager.shared.showCoinsInLabel(label: coinLabel, diamontLabel: diamondLabel)
    }
    
    @IBAction func buyByCoinBtnsPressed(_ sender: UIButton) {
        if GameManager.shared.getValue(key: "coin") as! Int >= 30 {
            GameManager.shared.minusPower(coinsToMinus: 30, key: "coin")
            GameManager.shared.increaseGivenPrize(key: keys[sender.tag])
        }
        showDataFromUD()
    }
    
    @IBAction func buyByDiamondsPressed(_ sender: UIButton) {
        if GameManager.shared.getValue(key: "diamond") as! Int >= 1 {
            GameManager.shared.minusPower(coinsToMinus: 1, key: "diamond")
            GameManager.shared.increaseGivenPrize(key: keys[sender.tag])
        }
        showDataFromUD()
    }
    
    @IBAction func xPressed(_ sender: UIButton) {
        GameManager.shared.updateValue(forKey: "currentPower", value: sender.tag)
        showDataFromUD()
    }
    
    @IBAction func infoPressed(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "InfoVC") as! InfoVC
        vc.modalPresentationStyle = .overCurrentContext
        push(vc: vc)
    }
    @IBAction func backPressed(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name("PowerShopVCDismissed"), object: nil)
        popViewController()
    }
}
