//
//  UIViewController + Extension.swift
//  SeSAC Shopping
//
//  Created by JinwooLee on 1/28/24.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

extension UIViewController : ResuableProtocol {
    static var identifier: String {
        return String(describing: self)
    }
    var identifier_: String {
        return String(describing: type(of: self))
    }
    
    static let userNotificationCenter = UNUserNotificationCenter.current() // notficiation
    
    func navigationDesign() {
        view.backgroundColor = ImageStyle.backgroundColor
        self.view.backgroundColor = ImageStyle.backgroundColor
        self.navigationController?.navigationBar.barTintColor = ImageStyle.backgroundColor
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ImageStyle.textColor]
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil) // title 부분 수정
        backBarButtonItem.tintColor = ImageStyle.textColor
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    func rootViewChange<T: UIViewController>(rootView : T, storyBoardName : String = "Main") {
        // seceneDelegate window vc rootview
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        print(rootView.identifier_)
        
        let sb = UIStoryboard(name: storyBoardName, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: rootView.identifier_) as! T
        let nav = UINavigationController(rootViewController: vc)
        
        sceneDelegate?.window?.rootViewController = nav
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
    func MainViewChangeCodebase() { // 임시 function
        // seceneDelegate window vc rootview
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        let mainVC = UINavigationController(rootViewController: MainViewController())
        
        // Tabbar controller
        let tabbarController = UITabBarController()
        tabbarController.setViewControllers([mainVC], animated: true)
        tabbarController.configureItemDesing(tabBar: tabbarController.tabBar)
        
        sceneDelegate?.window?.rootViewController = tabbarController
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
    // notification
    func callNotification(seconds: Double, repeat_ : Bool = false) {
        let notificationContent = UNMutableNotificationContent()
        let likeDictionary = UserDefaultManager.shared.like
        let likeCount = likeDictionary.values.filter{$0 == true}.count
        
        notificationContent.title = "\(UserDefaultManager.shared.nickname)님의 좋아요 개수는??"
        notificationContent.body = "벌써 \(likeCount)개의 상품을 좋아하고 계시는군요!"
        notificationContent.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1) // noti가 쌓이면 숫자도 늘어남
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: repeat_)
        let request = UNNotificationRequest(identifier: "Notification",
                                            content: notificationContent,
                                            trigger: trigger)
        
        UIViewController.userNotificationCenter.add(request) { error in
            if let error = error {
                print("Error: ", error)
            }
        }
    }
}
