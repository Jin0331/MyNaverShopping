//
//  SceneDelegate.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/18/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        // 코드를 통해 앱 시작 화면 설정
        guard let scene = (scene as? UIWindowScene) else { return }
        
        // User state
        /// User default는 bool을 Optional이 아님
        let userState = UserDefaultManager.shared.userState
        print(userState)
        
        if userState == UserDefaultManager.UserStateCode.new.state {
            window = UIWindow(windowScene: scene)
            
            let sb = UIStoryboard(name: OnboardingViewController.identifier, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: OnboardingViewController.identifier) as! OnboardingViewController
//            let nav = UINavigationController(rootViewController: vc)
            
            window?.rootViewController = vc
            window?.makeKeyAndVisible() /// 해당 과정은 inpo.plist에서 바꾼것을 해당 과정으로 바꾼거임

        } else { // onbaord 아님
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: MainTabbarViewController.identifier) as! MainTabbarViewController
//            let nav = UINavigationController(rootViewController: vc)
            
            window?.rootViewController = vc
            window?.makeKeyAndVisible()
        }
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

