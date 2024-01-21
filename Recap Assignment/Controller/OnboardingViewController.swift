//
//  OnboardingViewController.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/21/24.
//

import UIKit

//TODO: - 글씨폰트???

class OnboardingViewController: UIViewController {
    
    @IBOutlet var titleImage: UIImageView!
    @IBOutlet var mainImage: UIImageView!
    @IBOutlet var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ImageStyle.backgroundColor
        
        //image
        titleImage.image = #imageLiteral(resourceName: "sesacShopping")
        titleImage.contentMode = .scaleAspectFit
        mainImage.image = #imageLiteral(resourceName: "onboarding")
        mainImage.contentMode = .scaleAspectFill
        
        //button
        startButton.setTitle("시작하기", for: .normal)
        startButton.setTitleColor(ImageStyle.textColor, for: .normal)
        startButton.titleLabel?.font = ImageStyle.headerFontSize
        startButton.backgroundColor = ImageStyle.pointColor
        startButton.clipsToBounds = true
        startButton.layer.cornerRadius = 10
        
    }

    @IBAction func startButtonClicked(_ sender: UIButton) {
        
        UserDefaults.standard.set(true, forKey: "UserState")
        
        
        //TODO: - 프로필 설정으로 가도록 해야됨. 현재는 메인
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: MainTabbarViewController.identifier) as! MainTabbarViewController
        
        
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: false)
        
    }
}
