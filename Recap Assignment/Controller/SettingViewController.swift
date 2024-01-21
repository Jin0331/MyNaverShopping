//
//  SettingViewController.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/20/24.
//

import UIKit

class SettingViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDesign()
    }
}

extension SettingViewController {
    func configureDesign() {
        self.view.backgroundColor = ImageStyle.backgroundColor
        
        self.view.backgroundColor = ImageStyle.backgroundColor
        self.navigationController?.navigationBar.barTintColor = ImageStyle.backgroundColor
        self.navigationItem.title = "설정"
        
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ImageStyle.textColor]
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil) // title 부분 수정
        backBarButtonItem.tintColor = ImageStyle.textColor
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
    }
}
