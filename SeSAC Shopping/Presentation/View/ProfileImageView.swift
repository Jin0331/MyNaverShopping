//
//  ProfileImageView.swift
//  SeSAC Shopping
//
//  Created by JinwooLee on 2/24/24.
//

import UIKit
import SnapKit

class ProfileImageView : BaseView {
    
    let profileImage : CommonProfileImageView = {
        let profileImage = CommonProfileImageView(frame: .zero)
        profileImage.configureImageSpecific(borderWidth: 3.5, userDefaultImageName: UserDefaultManager.shared.tempProfileImage)
     
        return profileImage
    }()
    
    lazy var profileCollectionView : UICollectionView = {
        let profileCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCellLayout())
        profileCollectionView.backgroundColor = ImageStyle.backgroundColor
        profileCollectionView.register(ProfileImageCollectionViewCell.self, forCellWithReuseIdentifier: ProfileImageCollectionViewCell.identifier)
        
        return profileCollectionView
    }()
    
    override func configureHierarchy() {
        [profileImage, profileCollectionView].forEach { item in
            return addSubview(item)
        }
    }
    
    override func configureLayout() {
        profileImage.snp.makeConstraints { make in
            make.height.width.equalTo(150)
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
        
        profileCollectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(profileImage.snp.bottom).offset(20)
        }
    }
    
    private func configureCellLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        let rowCount : Double = 4
        let sectionSpacing : CGFloat = 10
        let itemSpacing : CGFloat = 15
        let width : CGFloat = UIScreen.main.bounds.width - (itemSpacing * (rowCount - 1)) - (sectionSpacing * 2)
        let itemWidth: CGFloat = width / rowCount
        
        // 각 item의 크기 설정 (아래 코드는 정사각형을 그린다는 가정)
        layout.itemSize = CGSize(width: itemWidth , height: itemWidth)
        // 스크롤 방향 설정
        layout.scrollDirection = .vertical
        // Section간 간격 설정
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        // item간 간격 설정
        layout.minimumLineSpacing = itemSpacing        // 최소 줄간 간격 (수직 간격)
        layout.minimumInteritemSpacing = itemSpacing   // 최소 행간 간격 (수평 간격)
        
        return layout
    }
}
