import UIKit
import SnapKit

class MainGameVC: BaseViewController {
    @IBOutlet weak var powerButton: UIButton!
    @IBOutlet weak var numberOfPowerLabel: UILabel!
    @IBOutlet weak var diamondLabel: UILabel!
    @IBOutlet weak var heartsLabel: UILabel!
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var levelLabelBack: UIImageView!
    @IBOutlet weak var selectedCardsStack: UIStackView!
    @IBOutlet weak var gameSceneBackImage: UIImageView!
    @IBOutlet weak var gameSceneView: UIView!
    @IBOutlet weak var playerProgress: UIProgressView!
    @IBOutlet weak var firstEnemyLife: UIProgressView!
    @IBOutlet weak var secondEnemyLife: UIProgressView!
    @IBOutlet var enemiyImages: [UIImageView]!
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet var backTableImages: [UIImageView]!
    @IBOutlet var powerImageViewOutlets: [UIImageView]!
    @IBOutlet weak var attackBtn: UIButton!
    @IBOutlet var gameButtons: [UIButton]!
    lazy var imageToDrop = UIImageView()
    var timer: Timer?
    var levelNumber: Int?
    var timeInterval: TimeInterval = 5.0
    var elapsedTime: TimeInterval = 0
    var imagesToSet: [Int] = [0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3]
    var gameImageIndex = 0
    var imagesOfStack: [UIImage] = []
    var score = 0
    var hearts = 3
    let keys = ["sugarSlowdown", "blastCandy", "sweetMultiplier"]
    var scoreToAddition = 1
    var isSecondPower = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
        allFunctionsTrigger()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: Notification.Name("PowerShopVCDismissed"), object: nil)
    }
    
    func allFunctionsTrigger() {
        attackBtn.isUserInteractionEnabled = false
        timeInterval = 6.0
        elapsedTime = 0
        gameImageIndex = 0
        hearts = 3
        score = 0
        scoreToAddition = 1
        isSecondPower = false
        imagesOfStack = []
        startAnimation()
        showAllDetails()
    }
    
    func showAllDetails() {
        GameManager.shared.showCoinsInLabel(label: coinLabel, diamontLabel: diamondLabel)
        heartsLabel.text = "X \(hearts)"
        levelLabel.text = "LEVEL \(levelNumber!)"
        numberOfPowerLabel.text = "\(GameManager.shared.getValue(key: keys[GameManager.shared.getValue(key: "currentPower") as! Int]) as! Int)"
        powerButton.setBackgroundImage(UIImage(named: keys[GameManager.shared.getValue(key: "currentPower") as! Int]), for: .normal)
        if let levelNumber = levelNumber {
            switch levelNumber {
            case 1...3:
                levelLabelBack.image = UIImage(named: "levelTable1")
                gameSceneBackImage.image = UIImage(named: "gameField0")
                for enemyImage in enemiyImages {
                    enemyImage.image = UIImage(named: "enemy0")
                }
            case 4...6:
                levelLabelBack.image = UIImage(named: "levelTable2")
                gameSceneBackImage.image = UIImage(named: "gameField1")
                for enemyImage in enemiyImages {
                    enemyImage.image = UIImage(named: "enemy1")
                }
            case 7...9:
                levelLabelBack.image = UIImage(named: "levelTable3")
                gameSceneBackImage.image = UIImage(named: "gameField2")
                for enemyImage in enemiyImages {
                    enemyImage.image = UIImage(named: "enemy2")
                }
            default:
                levelLabelBack.image = UIImage(named: "levelTable4")
                gameSceneBackImage.image = UIImage(named: "gameField3")
                for enemyImage in enemiyImages {
                    enemyImage.image = UIImage(named: "enemy3")
                }
            }
        }
    }
    
    func setupRandomImages() {
        imagesToSet.shuffle()
        for (index, btn) in powerImageViewOutlets.enumerated() {
            if index < imagesToSet.count {
                btn.image = UIImage(named: "powerIcon\(imagesToSet[index])")
            } else {
            }
        }
    }

    
    func setupImageView() {
        let width = Int.random(in: 0...(Int(gameSceneView.frame.width) - 30))
        gameImageIndex = imagesToSet.randomElement()!
        imageToDrop.image = UIImage(named: "powerIcon\(gameImageIndex)")
        imageToDrop.contentMode = .scaleAspectFit
        gameSceneView.addSubview(imageToDrop)
        imageToDrop.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.top.equalToSuperview()
            make.left.equalTo(width)
        }
    }
    
    func startAnimation() {
        stopAnimation()
        setupRandomImages()
        restart()
        imageToDrop.snp.updateConstraints { make in
            make.left.equalTo(Int.random(in: 0...(Int(gameSceneView.frame.width) - 30)))
        }
        attackBtn.isUserInteractionEnabled = false
        gameImageIndex = imagesToSet.randomElement()!
        imageToDrop.image = UIImage(named: "powerIcon\(gameImageIndex)")
        imageToDrop.contentMode = .scaleAspectFit
        elapsedTime = 0
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateAnimation), userInfo: nil, repeats: true)
    }
    func stopAnimation() {
        timer?.invalidate()
        timer = nil
    }
    func resumeAnimation() {
        elapsedTime = 0
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateAnimation), userInfo: nil, repeats: true)
        }
    }
    
    @objc func updateAnimation() {
        elapsedTime += 0.01
        let progress = min(elapsedTime / timeInterval, 1.0)
        let heightOfView = gameSceneView.frame.height - 30.0
        imageToDrop.snp.updateConstraints { make in
            make.top.equalToSuperview().inset(heightOfView * progress)
        }
        if progress >= 1.0 {
            hearts -= 1
            defineHearts()
            startAnimation()
        }
    }
    
    @IBAction func homeButton(_ sender: UIButton) {
        stopAnimation()
        let vc = storyboard?.instantiateViewController(withIdentifier: "ExitVC") as! ExitVC
        vc.delegate = self
        push(vc: vc)
    }
    @IBAction func powerPressed(_ sender: UIButton) {
        let powerIndex = GameManager.shared.getValue(key: "currentPower") as! Int
        if GameManager.shared.getValue(key: keys[powerIndex]) as! Int > 0 {
            GameManager.shared.decreaseGivenPrize(key: keys[powerIndex])
            switch powerIndex {
            case 0:
                hearts += 1
            case 1:
                secondEnemyLife.progress = 0
                isSecondPower = true
                scoreToAddition = 2
            default:
                scoreToAddition = 2
            }
            showAllDetails()
        }
        
    }
    @IBAction func attackPressed(_ sender: UIButton) {
        if let firstImage = imagesOfStack.first, imagesOfStack.allSatisfy({ $0 == firstImage }) {
            if firstImage == imageToDrop.image {
                score += scoreToAddition
                firstEnemyLife.progress = Float(5 + levelNumber! - score) / Float(5 + levelNumber!)
                if isSecondPower {
                    secondEnemyLife.progress = 0
                } else {
                    secondEnemyLife.progress = Float(5 + levelNumber! - score) / Float(5 + levelNumber!)
                }
                timeInterval -= 0.17
                restart()
                startAnimation()
                if score >= (5 + levelNumber!) {
                    stopAnimation()
                    GameManager.shared.increasePowers(coinsToAdd: 30, key: "coin")
                    let vc = storyboard?.instantiateViewController(withIdentifier: "VictoryVC") as! VictoryVC
                    vc.delegate = self
                    push(vc: vc)
                }
            } else {
                hearts -= 1
                defineHearts()
            }
        } else {
            hearts -= 1
            defineHearts()
        }
            
    }
    
    func defineHearts() {
        playerProgress.progress = Float(hearts) / 3.0
        heartsLabel.text = "X \(hearts)"
        if hearts == 0 {
            stopAnimation()
            GameManager.shared.minusPower(coinsToMinus: 30, key: "lighting")
            let vc = storyboard?.instantiateViewController(withIdentifier: "LoseVC") as! LoseVC
            vc.delegate = self
            push(vc: vc)
        } else {
            startAnimation()
        }
    }
    
    func restart() {
        imagesOfStack = []
        for image in backTableImages {
            image.image = UIImage(named: "unselectedTable")
        }
        removeAllComponentsFromStackView()
    }
    
    @IBAction func powerSelectedButtons(_ sender: UIButton) {
        for backTableImage in backTableImages {
            if backTableImage.tag == sender.tag {
                backTableImage.image = UIImage(named: "selectedTable")
            }
        }
        
        for img in powerImageViewOutlets {
            if sender.tag == img.tag {
                imagesOfStack.append(img.image!)
                let imageView = UIImageView(image: img.image)
                imageView.contentMode = .scaleAspectFit
                selectedCardsStack.addArrangedSubview(imageView)
            }
        }
        
        if imagesOfStack.count == 4 {
            attackBtn.isUserInteractionEnabled = true
            for gameButton in gameButtons {
                gameButton.isUserInteractionEnabled = false
            }
        }
    }
    func removeAllComponentsFromStackView() {
        for view in selectedCardsStack.arrangedSubviews {
            view.removeFromSuperview()
            selectedCardsStack.removeArrangedSubview(view)
        }
        for btn in gameButtons {
            btn.isUserInteractionEnabled = true
        }
    }
}
extension MainGameVC: VictoryDelegate {
    func restartGame() {
        allFunctionsTrigger()
    }
}
extension MainGameVC: LoseDelegate {
    func restartGamee() {
        allFunctionsTrigger()
    }
}
extension MainGameVC: ExitDelegate{
    func noExitPressed() {
        allFunctionsTrigger()
    }
}

