//
//  ProfileViewController.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/21/24.
//

import UIKit
import TextFieldEffects

class ProfileViewController: UIViewController {

    @IBOutlet var nicknameTextfield: UITextField!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var statusTextfield: UILabel!
    @IBOutlet var completeButton: UIButton!
    @IBOutlet var profileImageSet: UIButton!
    
    var status : Bool = false
    var nickname : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationDesign() 
        configureViewDesign()
        
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
        configureViewDesign()
        
    }
    
    @IBAction func checkNickname(_ sender: UITextField) {
        
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
    @IBAction func completeButton(_ sender: UIButton) {
        if status {
            UserDefaultManager.shared.nickname = nickname
            UserDefaultManager.shared.profileImage = UserDefaultManager.shared.tempProfileImage
            UserDefaultManager.shared.tempProfileImage = UserDefaultManager.shared.profileImage
            UserDefaultManager.shared.userState = UserDefaultManager.UserStateCode.old.state
            
            
            //TODO: - 해당부분은 재사용 되는데, 간소화방법이 있을까
            rootViewChange(rootView: MainTabbarViewController())
        } else {
            print("아무일도 발생하지 않는다...!")
        }
    }
    
    @IBAction func profileChange(_ sender: UIButton) {
        // 화면 전환
        let sb = UIStoryboard(name: ProfileImageViewController.identifier, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: ProfileImageViewController.identifier)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func keyboardHide(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
