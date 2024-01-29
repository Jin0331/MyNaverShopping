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
        configureImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureImage() {
        contentMode = .scaleAspectFill
        layer.borderColor = ImageStyle.pointColor.cgColor
        clipsToBounds = true
        layer.cornerRadius = profileImage.layer.frame.width / 2
    }
    
    func configureImageSpecific(borderWidth : CGFloat, userDefaultImageName : String){
        
        layer.borderWidth = borderWidth
        image = UIImage(named: userDefaultImageName)
    }
    
    func configureSelectedBorder(asset : String) {
        if asset == UserDefaultManager.shared.tempProfileImage {
            profileImage.layer.borderColor = ImageStyle.pointColor.cgColor
            profileImage.layer.borderWidth = 3.5
        } else {
            profileImage.layer.borderWidth = 0
        }
    }
}
