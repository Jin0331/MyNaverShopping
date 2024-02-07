//
//  ProfileViewController.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/21/24.
//

import UIKit

class ProfileViewController: UIViewController, ViewSetup {
    
    let nicknameTextfield : CommonTextField = {
        let nicknameTextfield = CommonTextField()
        nicknameTextfield.profileTextField()
        
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
    
    let completeButton : CommonButton = {
        let completeButton = CommonButton()
        completeButton.configureCompleteButton()
        
        return completeButton
    }()
    
    let profileImageSet : CommonButton = {
        let profileImageSet = CommonButton()
        profileImageSet.configureProfileSetButton()
        
        return profileImageSet
    }()
    
    //TODO: - 코드 정리해야 필.수. VC안에 View 항목이 섞여있어 파악하기 힘듬.
    //MARK: - 닉네임 조건 Error 표현
    enum ValidateError : Error {
        case lessOrGreaterString
        case isSpecialCharacter
        case isNumber
//        case vaild
        
        var message : String {
            get {
                switch self {
                case .lessOrGreaterString:
                    return "2글자 이상 10글자 미만으로 설정해주세요"
                case .isSpecialCharacter:
                    return "닉네임에 @,#,$,%는 포함할 수 없어요"
                case .isNumber:
                    return "닉네임에 숫자는 포함할 수 없어요"
                }
            }
        }
    }
    
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
        super.viewWillAppear(animated)
        profileImage.configureImageSpecific(borderWidth: 4, userDefaultImageName: UserDefaultManager.shared.tempProfileImage)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImage.configureCornerRadius()
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
    }
    
    func configureHierachy() {
        [nicknameTextfield, profileImage, statusTextfield, completeButton, profileImageSet].forEach { item in
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
    
    @objc func checkNickname(sender: UITextField) {
        
        nickname = sender.text!
        
        do {
            try validateUserInputError(nickname: nickname)
            statusTextfield.textColor = ImageStyle.pointColor
            status = true
            statusTextfield.text = "사용할 수 있는 닉네임이에요"
        } catch {
            
            statusTextfield.textColor = .red
            status = false
            
            switch error {
            case ValidateError.lessOrGreaterString :
                statusTextfield.text = ValidateError.lessOrGreaterString.message
            case ValidateError.isSpecialCharacter :
                statusTextfield.text = ValidateError.isSpecialCharacter.message
            case ValidateError.isNumber :
                statusTextfield.text = ValidateError.isNumber.message
            default :
                print("뭐지")
            
            }
        }
    }
    
    func validateUserInputError(nickname : String) throws {
        let specialCharacters = "@#$%"
        let numbers = "0123456789"
        
        switch nickname {
        case _ where nickname.count < 2 || nickname.count >= 10:
            throw ValidateError.lessOrGreaterString
        case _ where nickname.contains(where: { specialCharacters.contains($0) }):
            throw ValidateError.isSpecialCharacter
        case _ where nickname.contains(where: { numbers.contains($0) }):
            throw ValidateError.isNumber
        default:
            print("알 수 없는 에러")
        }
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
        navigationController?.pushViewController(ProfileImageViewController(), animated: true)
    }
}
