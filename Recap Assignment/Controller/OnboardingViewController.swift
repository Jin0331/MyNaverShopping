//
//  OnboardingViewController.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/21/24.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var mainImage: UIImageView!
    @IBOutlet var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "SeSAC\nShopping"
        titleLabel.textAlignment = .center
        titleLabel.font = ImageStyle.titleFontSize
        titleLabel.textColor = ImageStyle.pointColor
        
    }

    @IBAction func startButtonClicked(_ sender: UIButton) {
        
        UserDefaults.standard.set(true, forKey: "UserState")
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "mainTabBarController") as! UITabBarController
        
        
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: false)
        
    }
}
