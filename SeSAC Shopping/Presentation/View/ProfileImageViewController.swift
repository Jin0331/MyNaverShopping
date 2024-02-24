//
//  ProfileImageViewController.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/21/24.
//

import UIKit

class ProfileImageViewController: BaseViewController {
    
    let mainView = ProfileImageView()
    
    override func loadView() {
        self.view = mainView
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationDesign()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainView.profileImage.configureCornerRadius()
    }
    
    override func configureView() {
        navigationItem.title = UserDefaultManager.shared.userState == UserDefaultManager.UserStateCode.new.state ? "프로필 설정" : "프로필 수정"
        
        mainView.profileCollectionView.delegate = self
        mainView.profileCollectionView.dataSource = self

    }
}

extension ProfileImageViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserDefaultManager.shared.assetList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = mainView.profileCollectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCollectionViewCell.identifier, for: indexPath) as! ProfileImageCollectionViewCell
        
        cell.profileImage.configureSelectedBorder(asset: UserDefaultManager.shared.assetList[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(#function)
        
        // 선택된 값으로 교체
        UserDefaultManager.shared.tempProfileImage = UserDefaultManager.shared.assetList[indexPath.item]
        mainView.profileImage.setImage(name: UserDefaultManager.shared.tempProfileImage)
        
        mainView.profileCollectionView.reloadData()
    }
    

}

