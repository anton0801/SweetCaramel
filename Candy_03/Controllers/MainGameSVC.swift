import UIKit
import WebKit

class MainGameSVC: BaseViewController {
    
    private var maingameSceneV: WKWebView!
    private var mainGameAdditionalScene: [WKWebView] = []
    
    var containerView: UIView!
    var stackView: UIStackView!
    var backGameScene: UIButton!
    var restartSceneGame: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = URL(string: UserDefaults.standard.string(forKey: "response_client") ?? "")!
        maingameSceneV = WKWebView(frame: self.view.bounds, configuration: sceneConfig())
        maingameSceneV.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        maingameSceneV.allowsBackForwardNavigationGestures = true
        maingameSceneV.uiDelegate = self
        maingameSceneV.navigationDelegate = self
        self.view.addSubview(maingameSceneV)
        if let gameDataAvailableSavedData = extractingGameSavedData().data {
            for (_, gameDAtaLevelersData) in gameDataAvailableSavedData {
                for (_, levelDataAvailable) in gameDAtaLevelersData {
                    let levelCompromitted = levelDataAvailable as? [HTTPCookiePropertyKey: AnyObject]
                    if let levelDaanjsSDat = levelCompromitted,
                       let levelResultConfiguredData = HTTPCookie(properties: levelDaanjsSDat) {
                        maingameSceneV.configuration.websiteDataStore.httpCookieStore.setCookie(levelResultConfiguredData)
                    }
                }
            }
        }
        maingameSceneV.load(URLRequest(url: ref))
        createNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.all, andRotateTo: .portrait)
    }
    
    func backSceneGame() {
        if !mainGameAdditionalScene.isEmpty {
            ndjsafnksad()
        } else if maingameSceneV.canGoBack {
            maingameSceneV.goBack()
        }
    }
    
    func restartrestart() {
        maingameSceneV.reload()
    }
    
    private func createNavigationBar() {
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 60) // Высота контейнера 60
        ])
        
        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        backGameScene = UIButton(type: .system)
        backGameScene.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backGameScene.translatesAutoresizingMaskIntoConstraints = false
        
        restartSceneGame = UIButton(type: .system)
        restartSceneGame.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        restartSceneGame.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(backGameScene)
        stackView.addArrangedSubview(restartSceneGame)
        
        containerView.isHidden = true
        
        backGameScene.addTarget(self, action: #selector(leftButtonPressed), for: .touchUpInside)
        restartSceneGame.addTarget(self, action: #selector(rightButtonPressed), for: .touchUpInside)
    }
    
    @objc func leftButtonPressed() {
        backSceneGame()
    }
    
    @objc func rightButtonPressed() {
        restartrestart()
    }
    
    func extractingGameSavedData() -> GameDatalevel {
        let dictGameDataLevel = UserDefaults.standard.dictionary(forKey: "game_saved_data") as? [String: [String: [HTTPCookiePropertyKey: AnyObject]]]
        return GameDatalevel(data: dictGameDataLevel)
    }
    
    func ndjsafnksad() {
        mainGameAdditionalScene.forEach { $0.removeFromSuperview() }
        containerView.isHidden = true
        mainGameAdditionalScene.removeAll()
        maingameSceneV.load(URLRequest(url: URL(string: UserDefaults.standard.string(forKey: "response_client") ?? "")!))
    }
    
    private func setUpConfigForNewSceneWinwow(window: WKWebView) {
        window.navigationDelegate = self
        window.translatesAutoresizingMaskIntoConstraints = false
        window.allowsBackForwardNavigationGestures = true
        window.scrollView.isScrollEnabled = true
        window.uiDelegate = self
        NSLayoutConstraint.activate([
            window.topAnchor.constraint(equalTo: maingameSceneV.topAnchor),
            window.bottomAnchor.constraint(equalTo: maingameSceneV.bottomAnchor),
            window.leadingAnchor.constraint(equalTo: maingameSceneV.leadingAnchor),
            window.trailingAnchor.constraint(equalTo: maingameSceneV.trailingAnchor)
        ])
    }
}
                             
extension MainGameSVC: WKNavigationDelegate, WKUIDelegate {
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let sdnsajkdafad = navigationAction.request.url, ["tg://", "somethins://", "viber://", "whatsapp://"].contains(where: sdnsajkdafad.absoluteString.hasPrefix) {
            UIApplication.shared.open(sdnsajkdafad, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    func sceneConfig() -> WKWebViewConfiguration {
        
        let dnajskndjsakd = WKWebpagePreferences()
        dnajskndjsakd.allowsContentJavaScript = true
        let dnsajkdnaskd = WKPreferences()
        dnsajkdnaskd.javaScriptCanOpenWindowsAutomatically = true
        dnsajkdnaskd.javaScriptEnabled = true
        
        let nfsajkbhdafas = WKWebViewConfiguration()
        nfsajkbhdafas.allowsInlineMediaPlayback = true
        nfsajkbhdafas.defaultWebpagePreferences = dnajskndjsakd
        
        nfsajkbhdafas.preferences = dnsajkdnaskd
        nfsajkbhdafas.requiresUserActionForMediaPlayback = false
        return nfsajkbhdafas
    }
    
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { ndjsakdnkasd in
            var njkfsabhdfsna = [String: [String: HTTPCookie]]()
            for njksabhdfsan in ndjsakdnkasd {
                var fgdcvashbjfg = njkfsabhdfsna[njksabhdfsan.domain] ?? [:]
                fgdcvashbjfg[njksabhdfsan.name] = njksabhdfsan
                njkfsabhdfsna[njksabhdfsan.domain] = fgdcvashbjfg
            }
            var ndsjadnajskd = [String: [String: AnyObject]]()
            
            for (mkfnjasdkafajhbsd, nakjsdbhfnkaj) in njkfsabhdfsna {
                var dbdsjahbdjahsd = [String: AnyObject]()
                for (nkjadbhasfn, nkjsadbhfna) in nakjsdbhfnkaj {
                    dbdsjahbdjahsd[nkjadbhasfn] = nkjsadbhfna.properties as AnyObject
                }
                ndsjadnajskd[mkfnjasdkafajhbsd] = dbdsjahbdjahsd
            }
            
            UserDefaults.standard.set(ndsjadnajskd, forKey: "game_saved_data")
        }
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        if navigationAction.targetFrame == nil {
            let nsjdabhjfsa = WKWebView(frame: .zero, configuration: configuration)
            maingameSceneV.addSubview(nsjdabhjfsa)
            setUpConfigForNewSceneWinwow(window: nsjdabhjfsa)
            containerView.isHidden = false
            if navigationAction.request.url?.absoluteString == "about:blank" ||
                navigationAction.request.url?.absoluteString.isEmpty == true {
            } else {
                nsjdabhjfsa.load(navigationAction.request)
            }
            mainGameAdditionalScene.append(nsjdabhjfsa)
            return nsjdabhjfsa
        }
        containerView.isHidden = true
        return nil
    }
    
}

extension Notification.Name {
    static let backDeddy = Notification.Name("runner_back")
    static let reloadDeddys = Notification.Name("reload_runner")
}

struct GameDatalevel {
    var data: [String: [String: [HTTPCookiePropertyKey: AnyObject]]]?
}
