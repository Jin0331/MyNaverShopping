//
//  ProfileViewController.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/21/24.
//

import UIKit

class ProfileViewController: BaseViewController {
    
    let mainView = ProfileView()
    let viewModel = ProfileViewModel()

    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationDesign()
        
        viewModel.outputNicknameValidation.bind { [weak self] value in
            self?.mainView.statusTextfield.text = value
        }
        
        viewModel.outputNicknameValidationColor.bind { [weak self] value in
            self?.mainView.statusTextfield.textColor = value ? .green : .red
        }
        
    }
    
    // 만약, status가 false상태에서 뒤로 돌아갈 경우, 다시 초기화 한다
    override func viewWillDisappear(_ animated: Bool) {
        if !UserDefaultManager.shared.userState {
            UserDefaultManager.shared.profileImage = UserDefaultManager.shared.assetList.randomElement()!
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.profileImage.configureImageSpecific(borderWidth: 4, userDefaultImageName: UserDefaultManager.shared.tempProfileImage)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainView.profileImage.configureCornerRadius()
    }
    
    override func configureView() {
        
        // 처음 화면 설정에서는 랜덤으로 먼저 이미지를 뿌리고, 해당 이미지를 저장한다. 이게 되네 ㅎ 앞에는 get으로 set
        UserDefaultManager.shared.profileImage = UserDefaultManager.shared.profileImage
        UserDefaultManager.shared.tempProfileImage = UserDefaultManager.shared.profileImage
        
        navigationItem.title = UserDefaultManager.shared.userState == UserDefaultManager.UserStateCode.new.state ? "프로필 설정" : "프로필 수정"
        
        mainView.nicknameTextfield.addTarget(self, action: #selector(checkNickname), for: .editingChanged)
        mainView.completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
        mainView.profileImageSet.addTarget(self, action: #selector(profileChange), for: .touchUpInside)
        hideKeyboardWhenTappedAround()
    }
    
    @objc func checkNickname(sender: UITextField) {
        viewModel.inputNickname.value = sender.text!
    }
    
    @objc func completeButtonClicked(sender: UIButton) {
        if viewModel.outputStatus.value {
            UserDefaultManager.shared.userState = UserDefaultManager.UserStateCode.old.state
            viewChangeToMain() // main View로 전환
        } else {
            print("아무일도 발생하지 않는다...!")
        }
    }
    
    @objc func profileChange(sender: UIButton) {
        // 화면 전환
        navigationController?.pushViewController(ProfileImageViewController(), animated: true)
    }
}
