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
        
        navigationDesign() 
        configureViewDesign()
        
    }

    @IBAction func startButtonClicked(_ sender: UIButton) {
        //TODO: - 프로필 설정으로 가도록 해야됨. 현재는 메인 - 완료
        let sb = UIStoryboard(name: ProfileViewController.identifier, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: ProfileViewController.identifier) as! ProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
