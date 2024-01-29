//
//  ProfileImageCollectionViewCell.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/21/24.
//

import UIKit

class ProfileImageCollectionViewCell: UICollectionViewCell, ViewSetup{
    
    let profileImage : ProfileImageView = {
        let profileImage = ProfileImageView(frame: .zero)
        
        return profileImage
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImage.layer.cornerRadius = frame.width / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func configureView() {
        configureHierachy()
        setupConstraints()
    }
    
    func configureHierachy() {
        contentView.addSubview(profileImage)
    }
    
    func setupConstraints() {
        profileImage.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.centerX.centerY.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
}
