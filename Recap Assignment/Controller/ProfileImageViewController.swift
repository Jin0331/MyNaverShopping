//
//  ProfileImageViewController.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/21/24.
//

import UIKit

class ProfileImageViewController: UIViewController {

    @IBOutlet var profileImge: UIImageView!
    @IBOutlet var profileCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationDesign() 
        configureCollectionViewDeisgn()
        profileCollectionView.collectionViewLayout = configureCellLayout()
        configureCollectionViewProtocol()
    }

}

extension ProfileImageViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func configureCollectionViewProtocol () {
        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
        
        let xib = UINib(nibName: ProfileImageCollectionViewCell.identifier, bundle: nil)
        profileCollectionView.register(xib, forCellWithReuseIdentifier: ProfileImageCollectionViewCell.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserDefaultManager.shared.assetList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = profileCollectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCollectionViewCell.identifier, for: indexPath) as! ProfileImageCollectionViewCell
        
        cell.configureProfileImage(asset: UserDefaultManager.shared.assetList[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = profileCollectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCollectionViewCell.identifier, for: indexPath) as! ProfileImageCollectionViewCell
        
        // 선택된 값으로 교체
        UserDefaultManager.shared.tempProfileImage = UserDefaultManager.shared.assetList[indexPath.item]
        print(UserDefaultManager.shared.tempProfileImage)
        profileImge.image = UIImage(named: UserDefaultManager.shared.tempProfileImage)
        
        profileCollectionView.reloadData()
    }
}

