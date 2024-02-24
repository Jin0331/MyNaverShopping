//
//  ProfileViewController.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/21/24.
//

import UIKit

class ProfileViewController: BaseViewController {
    
    let mainView = ProfileView()
    var status : Bool = false
    var nickname : String = ""

    override func loadView() {
        self.view = mainView
    }
    
    
    //TODO: - 코드 정리해야 필.수. VC안에 View 항목이 섞여있어 파악하기 힘듬.
    //MARK: - 닉네임 조건 Error 표현
    enum ValidateError : Error {
        case lessOrGreaterString
        case isSpecialCharacter
        case isNumber
        
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
        mainView.profileImage.configureImageSpecific(borderWidth: 4, userDefaultImageName: UserDefaultManager.shared.tempProfileImage)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainView.profileImage.configureCornerRadius()
    }
    
    override func configureView() {
        
        if UserDefaultManager.shared.userState == UserDefaultManager.UserStateCode.new.state {
            navigationItem.title = "프로필 설정"
        } else {
            navigationItem.title = "프로필 수정"
        }
        
        mainView.nicknameTextfield.addTarget(self, action: #selector(checkNickname), for: .editingChanged)
        mainView.completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
        mainView.profileImageSet.addTarget(self, action: #selector(profileChange), for: .touchUpInside)
        hideKeyboardWhenTappedAround()
    }
    

    
    @objc func checkNickname(sender: UITextField) {
        
        nickname = sender.text!
        
        do {
            try validateUserInputError(nickname: nickname)
            mainView.statusTextfield.textColor = ImageStyle.pointColor
            status = true
            mainView.statusTextfield.text = "사용할 수 있는 닉네임이에요"
        } catch {
            
            mainView.statusTextfield.textColor = .red
            status = false
            
            switch error {
            case ValidateError.lessOrGreaterString :
                mainView.statusTextfield.text = ValidateError.lessOrGreaterString.message
            case ValidateError.isSpecialCharacter :
                mainView.statusTextfield.text = ValidateError.isSpecialCharacter.message
            case ValidateError.isNumber :
                mainView.statusTextfield.text = ValidateError.isNumber.message
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
