//
//  ProfileImageCollectionViewCell.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/21/24.
//

import UIKit

class ProfileImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet var profileImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}

extension ProfileImageCollectionViewCell {
    func configureProfileImage(asset : String) {
        profileImage.image = UIImage(named: asset)
//        profileImage.layer.name = asset
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = profileImage.layer.frame.width / 2
        
        if asset == UserDefaultManager.shared.profileImage {
            profileImage.layer.borderColor = ImageStyle.pointColor.cgColor
            profileImage.layer.borderWidth = 3.5
        } else {
            profileImage.layer.borderWidth = 0
        }
    }
    
}
