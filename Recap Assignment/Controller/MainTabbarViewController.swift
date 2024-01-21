//
//  MainTabbarViewController.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/20/24.
//

import UIKit

class MainTabbarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDesign()
    }
    
}

extension MainTabbarViewController {
    func configureDesign() {
        tabBar.tintColor = ImageStyle.pointColor
        tabBar.barTintColor = ImageStyle.backgroundColor
        
        tabBar.items?[0].title = "검색"
        tabBar.items?[0].setTitleTextAttributes([.font: ImageStyle.normalFontSize], for: .normal)
        tabBar.items?[0].image = UIImage(systemName: "magnifyingglass")
        
        tabBar.items?[1].title = "설정"
        tabBar.items?[1].setTitleTextAttributes([.font: ImageStyle.normalFontSize], for: .normal)
        tabBar.items?[1].image = UIImage(systemName: "person")
    }
}
