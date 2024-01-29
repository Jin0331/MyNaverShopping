//
//  ProfileImageView.swift
//  SeSAC Shopping
//
//  Created by JinwooLee on 1/29/24.
//

import UIKit

class ProfileImageView: UIImageView {

    let profileImage : UIImageView = {
       let profileImage = UIImageView()
    
        return profileImage
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        configureImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureProfileImage(asset : String) {
        profileImage.image = UIImage(named: asset)
//        profileImage.layer.name = asset
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = profileImage.layer.frame.width / 2
        
        if asset == UserDefaultManager.shared.tempProfileImage {
            profileImage.layer.borderColor = ImageStyle.pointColor.cgColor
            profileImage.layer.borderWidth = 3.5
        } else {
            profileImage.layer.borderWidth = 0
        }
    }
}

