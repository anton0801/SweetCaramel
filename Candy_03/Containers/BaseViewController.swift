//
//  BaseViewController.swift
//  Cooking
//
// Created by . on 25/09/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    var activityIndicator: UIActivityIndicatorView?
    var tap = UITapGestureRecognizer()
    
    let main = UIStoryboard(name: "Main", bundle: nil)
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.delegate = self
        self.hideKeyboardWhenTappedAround()
        hideNavBar()
        setTransculantNavBar()
    }
    
    func setCustomNavBar() {
        let backButtonImage = UIImage(named: "backArrow")
        
        // Create a UIBarButtonItem with the custom image
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonTapped))
        
        // Assign the custom back button as the left bar button item
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func backButtonTapped() {
        popViewController()
    }
    
    func push(vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushSettings() {
        let vc = main.instantiateViewController(withIdentifier: "SettingsVC")
        push(vc: vc)
    }
    
    func hasDatePassed(_ date: Date) -> Bool {
        let currentDate = Date()
        return date < currentDate
    }
    
//    func demonstrateTabBar(){
//        let tabBarVC = TabBarVC()
//        
//        tabBarVC.modalPresentationStyle = .fullScreen
//        
//        present(tabBarVC, animated: true)
//    }
    
    func setupGradientText(to view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 184/255, green: 229/255, blue: 247/255, alpha: 0.3).cgColor,
            UIColor(red: 63/255, green: 171/255, blue: 209/255, alpha: 0.3).cgColor
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = view.bounds
        gradientLayer.cornerRadius = 1
        view.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    func setupGradientLabel(to label: UIButton) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 4/255, green: 136/255, blue: 66/255, alpha: 1).cgColor,
            UIColor(red: 39/255, green: 231/255, blue: 134/255, alpha: 1).cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = label.bounds
        
        let renderer = UIGraphicsImageRenderer(size: label.bounds.size)
        let gradientImage = renderer.image { ctx in
            gradientLayer.render(in: ctx.cgContext)
        }
        return gradientImage
    }
    
    func borderGradientt(to view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(red: 0/255, green: 255/255, blue: 87/255, alpha: 1).cgColor,
            UIColor(red: 0/255, green: 193/255, blue: 205/255, alpha: 1).cgColor,
            UIColor(red: 0/255, green: 109/255, blue: 188/255, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 2
        shapeLayer.path = UIBezierPath(roundedRect: view.bounds, cornerRadius: view.layer.cornerRadius).cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        
        gradientLayer.mask = shapeLayer
        
        view.layer.addSublayer(gradientLayer)
    }
    
    func setNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = MyColors.background.color
        appearance.titleTextAttributes = [.foregroundColor: MyColors.black.color]
        appearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = MyColors.black.color
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    @objc func leftButtonTapped() {
        popViewController()
    }
    
    func pushWithOverlayEffect(_ viewController: UIViewController) {
        // Create a fade transition
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .fade
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        
        // Push the view controller
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    func setTransculantNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor: MyColors.white.color]
        navigationController?.navigationBar.tintColor = MyColors.white.color
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Poppins-Light", size: 13)]
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(leftButtonTapped))
               // Assign it to the navigation item's leftBarButtonItem
               self.navigationItem.leftBarButtonItem = leftButton
        UINavigationBar.appearance().titleTextAttributes = attributes
        UINavigationBar.appearance().standardAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationItem.compactAppearance = appearance
        navigationController?.navigationBar.titleTextAttributes = attributes
        
    }

    func pushToShop() {
        let vc = main.instantiateViewController(withIdentifier: "ShopVC")
        push(vc: vc)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    open func hideKeyboardWhenTappedAround() {
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func refresh(sender:UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.7) {
            
            sender.endRefreshing()
        }
    }
    
    
    @objc open func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func popToTopViewController() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func hideTabBar() {
        tabBarController?.tabBar.isHidden = true
    }
    
    func showTabBar() {
        tabBarController?.tabBar.isHidden = false
    }
    
    func hideNavBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func showNavBar() {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setNavigationTint() {
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    func setNavigationBackButton() {
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    func setCategoryNav() {
        let logoImage = UIBarButtonItem(image:UIImage(named: "rules"), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = logoImage
    }
    
}

extension BaseViewController {
    func showAlertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in}
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func showAlertLocation(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Перейти", style: .default) { _ in
            if let url = URL(string: "App-prefs:root=Privacy&path=LOCATION") {
                UIApplication.shared.open(url,options: [:],completionHandler: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

//MARK: - Custom alert
extension BaseViewController {
    func setupVisualEffectView() {
        view.addSubview(visualEffectView)
        visualEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        visualEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        visualEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        visualEffectView.alpha = 0
    }
    
    func setAlert(alertView: UIView) {
        view.addSubview(alertView)
        alertView.center = view.center
    }
    
    func animateIn(alertView: UIView) {
        view.addSubview(alertView)
        alertView.center = view.center
        alertView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        alertView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.alpha = 1
            alertView.alpha = 1
            alertView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut(alertView: UIView) {
        UIView.animate(withDuration: 0.4,
                       animations: {
            self.visualEffectView.alpha = 0
            alertView.alpha = 0
            alertView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        }) { (_) in
            alertView.removeFromSuperview()
        }
    }
}


extension BaseViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // Don't handle button taps
        return !(touch.view is UIButton)
    }
}
extension BaseViewController {
    func checkCustomSlider(to button: UIButton) -> Bool {
        if button.currentImage == UIImage(named: "switchOn"){
            button.setImage(UIImage(named: "switchOff"), for: .normal)
            return true
        } else {
            button.setImage(UIImage(named: "switchOn"), for: .normal)
            return false
        }
    }
    
}
