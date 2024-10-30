//
//  ExchangeVC.swift
//  Candy_03
//
//  Created by Behruz Norov on 30/10/24.
//

import UIKit

class ExchangeVC: BaseViewController {
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var diamondLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func plusPressed(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "ExchangeVC") as! ExchangeVC
//        vc.modalPresentationStyle = .overCurrentContext
//        present(vc, animated: true)
    }
    @IBAction func backPressed(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name("PowerShopVCDismissed"), object: nil)
        dismiss(animated: true)
    }
    @IBAction func infoPressed(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "InfoVC") as! InfoVC
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true)
    }
    @IBAction func purchaseBtnPressed(_ sender: UIButton) {
    }
}
