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
    
    var status : Bool = false
    let specialCharacters = "@#$%"
    let numbers = "0123456789"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewDesign()
        
    }
    @IBAction func checkNickname(_ sender: UITextField) {
        
        let nickname = sender.text!
        let statusMessage: String
        
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
    @IBAction func keyboardHide(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension ProfileViewController {
    func configureViewDesign() {
        //navigation
        if UserDefaultManager.shared.userState == UserDefaultManager.UserStateCode.new.state {
            navigationItem.title = "프로필 설정"
        }
        self.view.backgroundColor = ImageStyle.backgroundColor
        self.navigationController?.navigationBar.barTintColor = ImageStyle.backgroundColor
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ImageStyle.textColor]
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil) // title 부분 수정
        backBarButtonItem.tintColor = ImageStyle.textColor
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        //image
        profileImage.contentMode = .scaleAspectFill
        profileImage.image = UIImage(named: UserDefaultManager.shared.profileImage)
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = profileImage.layer.frame.width / 2
        profileImage.layer.borderWidth = 4
        profileImage.layer.borderColor = ImageStyle.pointColor.cgColor
        
        // textfield
        nicknameTextfield.placeholder = "닉네임을 입력해주세요 :)"
        nicknameTextfield.textAlignment = .center
        nicknameTextfield.backgroundColor = .clear
        nicknameTextfield.textColor = ImageStyle.textColor
        
        // status label
        statusTextfield.backgroundColor = .clear
        statusTextfield.font = ImageStyle.normalFontSize

    }
}
