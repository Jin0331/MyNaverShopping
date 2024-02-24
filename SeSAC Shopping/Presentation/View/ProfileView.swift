//
//  ProfileView.swift
//  SeSAC Shopping
//
//  Created by JinwooLee on 2/24/24.
//

import UIKit
import SnapKit

class ProfileView : BaseView {
    
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
    
    override func configureHierarchy() {
        [nicknameTextfield, profileImage, statusTextfield, completeButton, profileImageSet].forEach { item in
            return addSubview(item)
        }
    }
    
    override func configureLayout() {
        profileImage.snp.makeConstraints { make in
            make.width.height.equalTo(90)
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
        
        profileImageSet.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.bottom.trailing.equalTo(profileImage)
        }
        
        nicknameTextfield.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(30)
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(60)
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
    
}


