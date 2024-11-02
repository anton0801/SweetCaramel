//
//  ViewController.swift
//  Candy_03
//
// Created by . on 30/10/24.
//

import UIKit

struct LevelBackUIData {
    let backImage: String
    let centerButtonName: String
    let levelBackTableImage: String
    
    static func fetchBackData() -> [LevelBackUIData] {
        [
            LevelBackUIData(backImage: "firstBack", centerButtonName: "centerImageLevel1", levelBackTableImage: "levelTable1"),
            LevelBackUIData(backImage: "secondBack", centerButtonName: "centerImageLevel2", levelBackTableImage: "levelTable2"),
            LevelBackUIData(backImage: "thirdBack", centerButtonName: "centerImageLevel3", levelBackTableImage: "levelTable3"),
            LevelBackUIData(backImage: "fourthBack", centerButtonName: "centerImageLevel4", levelBackTableImage: "levelTable4")
        ]
    }
}

class InitialVC: BaseViewController {
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var battleButton: UIButton!
    @IBOutlet weak var lightingsLabel: UILabel!
    @IBOutlet weak var rewardBtn: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var levelNumberLabel: UILabel!
    @IBOutlet weak var coinsLabel: UILabel!
    @IBOutlet weak var diamondsLabel: UILabel!
    @IBOutlet weak var levelNumberBackImage: UIImageView!
    
    var index = 1
    let rewardInterval: TimeInterval = 24 * 60 * 60
    var rewardTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkRewardStatus()
        NotificationCenter.default.addObserver(self, selector: #selector(handlePowerShopVCDismissed), name: Notification.Name("PowerShopVCDismissed"), object: nil)
    }
    
    func defineBack() {
        let data = LevelBackUIData.fetchBackData()
        levelNumberLabel.text = "LEVEL \(index)"
        switch index {
        case 1...3 :
            backImage.image = UIImage(named: data[0].backImage)
            levelNumberBackImage.image = UIImage(named: data[0].levelBackTableImage)
            battleButton.setImage(UIImage(named: data[0].centerButtonName), for: .normal)
        case 4...6 :
            backImage.image = UIImage(named: data[1].backImage)
            levelNumberBackImage.image = UIImage(named: data[1].levelBackTableImage)
            battleButton.setImage(UIImage(named: data[1].centerButtonName), for: .normal)
        case 7...9 :
            backImage.image = UIImage(named: data[2].backImage)
            levelNumberBackImage.image = UIImage(named: data[2].levelBackTableImage)
            battleButton.setImage(UIImage(named: data[2].centerButtonName), for: .normal)
        case 10...12 :
            backImage.image = UIImage(named: data[3].backImage)
            levelNumberBackImage.image = UIImage(named: data[3].levelBackTableImage)
            battleButton.setImage(UIImage(named: data[3].centerButtonName), for: .normal)
        default:
            break
        }
    }
    
    @objc func handlePowerShopVCDismissed() {
        GameManager.shared.showCoinsInLabel(label: coinsLabel, diamontLabel: diamondsLabel)
        let lightings = GameManager.shared.getValue(key: "lighting") as! Int
        lightingsLabel.text = "\(lightings)/100"
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        defineBack()
        startRewardTimer()
        rewardBtn.isUserInteractionEnabled = true
        GameManager.shared.showCoinsInLabel(label: coinsLabel, diamontLabel: diamondsLabel)
        let lightings = GameManager.shared.getValue(key: "lighting") as! Int
        lightingsLabel.text = "\(lightings)/100"
    }
    
    func disableRewardButton() {
        rewardBtn.isEnabled = false
        rewardBtn.setImage(UIImage(named: "dailyDisabled"), for: .normal)
        startRewardTimer()
    }
    
    func enableRewardButton() {
        rewardBtn.isEnabled = true
        rewardBtn.setImage(UIImage(named: "dailyEnabled"), for: .normal)
        timerLabel.text = "DAILY"
        rewardTimer?.invalidate()
    }
    
    func checkRewardStatus() {
        let lastRewardTime = UserDefaults.standard.object(forKey: "lastRewardTime") as? Date ?? Date.distantPast
        let currentTime = Date()
        
        if currentTime.timeIntervalSince(lastRewardTime) >= rewardInterval {
            enableRewardButton()
        } else {
            disableRewardButton()
        }
    }
    
    func startRewardTimer() {
        rewardTimer?.invalidate()
        rewardTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimerLabel()
        }
    }
    func updateTimerLabel() {
        let lastRewardTime = UserDefaults.standard.object(forKey: "lastRewardTime") as? Date ?? Date.distantPast
        let currentTime = Date()
        let timeSinceLastReward = currentTime.timeIntervalSince(lastRewardTime)
        
        if timeSinceLastReward >= rewardInterval {
            enableRewardButton()
        } else {
            let remainingTime = rewardInterval - timeSinceLastReward
            timerLabel.text = self.formatTime(remainingTime)
        }
    }
    
    func formatTime(_ interval: TimeInterval) -> String {
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        return String(format: "%02d:%02d", hours, minutes)
    }
    
    @IBAction func rightPressed(_ sender: UIButton) {
        if index < 12 {
            index += 1
            defineBack()
        }
    }
    @IBAction func leftPressed(_ sender: UIButton) {
        if index > 1 {
            index -= 1
            defineBack()
        }
    }
    @IBAction func dailyPrizePressed(_ sender: UIButton) {
        let lastRewardTime = UserDefaults.standard.object(forKey: "lastRewardTime") as? Date ?? Date.distantPast
        let currentTime = Date()
        
        if currentTime.timeIntervalSince(lastRewardTime) >= rewardInterval {
            print("Coins are successfully taken for today")
            // It will change later on
            UserDefaults.standard.set(Date(), forKey: "lastRewardTime")
            GameManager.shared.increasePowers(coinsToAdd: 25, key: "coin")
            GameManager.shared.increasePowers(coinsToAdd: 2, key: "diamond")
            GameManager.shared.increasePowers(coinsToAdd: 30, key: "lighting")
            disableRewardButton()
            let vc = storyboard?.instantiateViewController(withIdentifier: "DailyGiftVC") as! DailyGiftVC
            vc.modalPresentationStyle = .overCurrentContext
            push(vc: vc)
            GameManager.shared.showCoinsInLabel(label: coinsLabel, diamontLabel: diamondsLabel)
        } else {
            // Reward is unavailable
            print("Reward already claimed, wait until the next 24-hour window.")
        }
    }
    @IBAction func soundPressed(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "soundDisabled") {
            sender.setImage(UIImage(named: "soundEnabled"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "soundDisabled"), for: .normal)
        }
    }
    @IBAction func musicPressed(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "musicDisabled") {
            sender.setImage(UIImage(named: "musicEnabled"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "musicDisabled"), for: .normal)
        }
    }
    @IBAction func menuPressed(_ sender: UIButton) {
        
    }
    @IBAction func shopPressed(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PowerShopVC") as! PowerShopVC
        vc.modalPresentationStyle = .overCurrentContext
        push(vc: vc)
    }
    @IBAction func levelsPressed(_ sender: UIButton) {
        print("Levels got pressed")
    }
    @IBAction func battleButtonPressed(_ sender: UIButton) {
        if GameManager.shared.getValue(key: "lighting") as! Int >= 30 {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MainGameVC") as! MainGameVC
        vc.levelNumber = index
        push(vc: vc)
        } else {
            showAlertMessage(title: "Insufficient Coins", message: "You don't have enough coins to retry game")
        }
    }
}

