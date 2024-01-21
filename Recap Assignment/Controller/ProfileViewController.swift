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
    var nickname : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewDesign()
        
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
            UserDefaultManager.shared.userState = UserDefaultManager.UserStateCode.old.state
            
            //TODO: - 해당부분은 재사용 되는데, 간소화방법이 있을까
            // seceneDelegate window vc rootview
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let sceneDelegate = windowScene?.delegate as? SceneDelegate
            
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: MainTabbarViewController.identifier) as! MainTabbarViewController
            
            sceneDelegate?.window?.rootViewController = vc
            sceneDelegate?.window?.makeKeyAndVisible()
        } else {
            print("아무일도 발생하지 않는다...!")
        }
    }
    
    
    @IBAction func keyboardHide(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
