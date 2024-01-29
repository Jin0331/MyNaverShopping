//
//  ProfileViewController.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/21/24.
//

import UIKit
import TextFieldEffects

class ProfileViewController: UIViewController, ViewSetup {
    
    let nicknameTextfield : YoshikoTextField = {
        let nicknameTextfield = YoshikoTextField()
        nicknameTextfield.placeholder = "닉네임을 입력해주세요 :)"
        nicknameTextfield.placeholderFontScale = 1
        nicknameTextfield.placeholderColor = .systemGray2
        nicknameTextfield.borderSize = 1.5
        nicknameTextfield.textAlignment = .center
        nicknameTextfield.backgroundColor = .clear
        nicknameTextfield.textColor = ImageStyle.textColor
        
        return nicknameTextfield
    }()
    
    let profileImage : ProfileImageView = {
        let profileImage = ProfileImageView(frame: .zero)
        profileImage.configureImageSpecific(borderWidth: 4, userDefaultImageName: UserDefaultManager.shared.tempProfileImage)
        
        return profileImage
    }()
    
    let statusTextfield : UILabel = {
        let statusTextfield = UILabel()
        statusTextfield.backgroundColor = .clear
        statusTextfield.font = ImageStyle.normalFontSize
        
        return statusTextfield
    }()
    
    let completeButton : UIButton = {
        let completeButton = UIButton()
        completeButton.setTitle("완료", for: .normal)
        completeButton.setTitleColor(ImageStyle.textColor, for: .normal)
        completeButton.titleLabel?.font = ImageStyle.headerFontSize
        completeButton.backgroundColor = ImageStyle.pointColor
        completeButton.clipsToBounds = true
        completeButton.layer.cornerRadius = 11
        
        return completeButton
    }()
    
    let profileImageSet : UIButton = {
        let profileImageSet = UIButton()
        profileImageSet.setImage(UIImage(named: "camera"), for: .normal)
        profileImageSet.setTitle("", for: .normal)
        profileImageSet.backgroundColor = .clear
        profileImageSet.clipsToBounds = true
        profileImageSet.layer.cornerRadius = profileImageSet.layer.frame.width / 2
        
        return profileImageSet
    }()
    
    var status : Bool = false
    
    var nickname : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationDesign()
        configureView()
        
        // 처음 화면 설정에서는 랜덤으로 먼저 이미지를 뿌리고, 해당 이미지를 저장한다. 이게 되네 ㅎ 앞에는 get으로 set
        UserDefaultManager.shared.profileImage = UserDefaultManager.shared.profileImage
        UserDefaultManager.shared.tempProfileImage = UserDefaultManager.shared.profileImage
    }
    
    // 만약, status가 false상태에서 뒤로 돌아갈 경우, 다시 초기화 한다
    override func viewWillDisappear(_ animated: Bool) {
        if !UserDefaultManager.shared.userState {
            UserDefaultManager.shared.profileImage = UserDefaultManager.shared.assetList.randomElement()!
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        profileImage.layer.cornerRadius = profileImage.layer.frame.width / 2
    }
    
    func configureView() {
        
        if UserDefaultManager.shared.userState == UserDefaultManager.UserStateCode.new.state {
            navigationItem.title = "프로필 설정"
        } else {
            navigationItem.title = "프로필 수정"
        }
        
        nicknameTextfield.addTarget(self, action: #selector(checkNickname), for: .editingChanged)
        
        completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
        
        profileImageSet.addTarget(self, action: #selector(profileChange), for: .touchUpInside)
        
        hideKeyboardWhenTappedAround()
        
        configureHierachy()
        setupConstraints()
        configureView()
    }
    
    func configureHierachy() {
        [nicknameTextfield, profileImage, statusTextfield, completeButton, profileImageSet].map { item in
            return view.addSubview(item)
        }
    }
    
    func setupConstraints() {
        profileImage.snp.makeConstraints { make in
            make.width.height.equalTo(90)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        profileImageSet.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.bottom.trailing.equalTo(profileImage)
        }
        
        nicknameTextfield.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(30)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(60)
            make.height.equalTo(50)
        }
        
        statusTextfield.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalTo(nicknameTextfield.snp.bottom).offset(10)
            make.leading.trailing.equalTo(nicknameTextfield).inset(10)
        }
        
        completeButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(statusTextfield.snp.bottom).offset(40)
            make.leading.trailing.equalTo(nicknameTextfield)
        }
    }
    
//    func configureView() {
//        
//    }
    
    @objc func checkNickname(sender: UITextField) {

        let specialCharacters = "@#$%"
        let numbers = "0123456789"
        let statusMessage: String
        nickname = sender.text!
        
        switch nickname {
        case _ where nickname.count < 2 || nickname.count >= 10:
            statusMessage = TextfieldCheck.numberCount.rawValue
        case _ where nickname.contains(where: { specialCharacters.contains($0) }):
            statusMessage = TextfieldCheck.specialChr.rawValue
        case _ where nickname.contains(where: { numbers.contains($0) }):
            statusMessage = TextfieldCheck.containNum.rawValue
        default:
            statusMessage = TextfieldCheck.vaild.rawValue
        }
        
        statusTextfield.textColor = statusMessage == TextfieldCheck.vaild.rawValue ? ImageStyle.pointColor : .red
        status = statusMessage == TextfieldCheck.vaild.rawValue ? true : false
        statusTextfield.text = statusMessage
        
        print(status)
    }
    
    @objc func completeButtonClicked(sender: UIButton) {
        if status {
            UserDefaultManager.shared.nickname = nickname
            UserDefaultManager.shared.profileImage = UserDefaultManager.shared.tempProfileImage
            UserDefaultManager.shared.tempProfileImage = UserDefaultManager.shared.profileImage
            UserDefaultManager.shared.userState = UserDefaultManager.UserStateCode.old.state
            
            
            viewChangeToMain() // main View로 전환
        } else {
            print("아무일도 발생하지 않는다...!")
        }
    }
    
    @objc func profileChange(sender: UIButton) {
        // 화면 전환
        let sb = UIStoryboard(name: ProfileImageViewController.identifier, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: ProfileImageViewController.identifier)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
