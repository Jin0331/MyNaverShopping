//
//  ProfileImageView.swift
//  SeSAC Shopping
//
//  Created by JinwooLee on 1/29/24.
//

import UIKit

class CommonProfileImageView: UIImageView {
  
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
    }
    
    func configureCornerRadius() {
        layer.cornerRadius = layer.frame.width / 2
    }
    
    func configureImageSpecific(borderWidth : CGFloat, userDefaultImageName : String){
        image = UIImage(named: userDefaultImageName)
        layer.borderWidth = borderWidth
    }
    
    func setImage(name : String) {
        image = UIImage(named: name)
    }
    
    
    func configureSelectedBorder(asset : String) {
        image = UIImage(named: asset)
        
        if asset == UserDefaultManager.shared.tempProfileImage {
            layer.borderColor = ImageStyle.pointColor.cgColor
            layer.borderWidth = 3.5
        } else {
            layer.borderWidth = 0
        }
    }
}
