//
//  OnboardingViewController.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/21/24.
//

import UIKit
import SnapKit

class OnboardingViewController: UIViewController{
    
    //MARK: - UI
    let titleImage : UIImageView = {
        let titleImage = UIImageView()
        titleImage.image = #imageLiteral(resourceName: "title")
        titleImage.contentMode = .scaleAspectFit
        
        return titleImage
    }()
    
    let mainImage : UIImageView = {
        let mainImage = UIImageView()
        mainImage.image = #imageLiteral(resourceName: "onboarding")
        mainImage.contentMode = .scaleAspectFill
        
        return mainImage
    }()
    
    let startButton : CommonButton = {
        let startButton = CommonButton()
        startButton.configureOnboardingButton()
        
        return startButton
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationDesign() 
        configureView()
    }
    
    func configureView() {
        view.backgroundColor = ImageStyle.backgroundColor
        
        startButton.addTarget(self, action: #selector(startButonClicked), for: .touchUpInside)
        
        configureHierachy()
        setupConstraints()
    }
    
    func configureHierachy() {
        [titleImage, mainImage, startButton].forEach { item in
            return view.addSubview(item)
        }
        
    }
    
    func setupConstraints() {
        titleImage.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.height.equalTo(200)
            make.width.equalTo(300)
        }
        
        mainImage.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
            make.width.height.equalTo(300)
        }
        
        startButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.top.equalTo(mainImage.snp.bottom).offset(50)
            make.height.equalTo(50)
        }
        
    }
    
    @objc func startButonClicked(_ sender: UIButton) {
        //TODO: - 프로필 설정으로 가도록 해야됨. 현재는 메인 - 완료
        let vc = ProfileViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
