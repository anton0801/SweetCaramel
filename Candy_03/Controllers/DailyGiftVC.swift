//
//  DailyGiftVC.swift
//  Candy_03
//
// Created by . on 30/10/24.
//

import UIKit

class DailyGiftVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func takePressed(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name("PowerShopVCDismissed"), object: nil)
        popViewController()
    }
}
