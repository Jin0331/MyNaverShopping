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
        UserDefaultManager.shared.profileImage = UserDefaultManager.shared.assetList[indexPath.item]
        print(UserDefaultManager.shared.profileImage)
        profileImge.image = UIImage(named: UserDefaultManager.shared.profileImage)
        
        profileCollectionView.reloadData()
    }
}


extension ProfileImageViewController {
    func configureCollectionViewDeisgn() {
        //navigation
        if UserDefaultManager.shared.userState == UserDefaultManager.UserStateCode.new.state {
            navigationItem.title = "프로필 설정"
        } else {
            navigationItem.title = "프로필 수정"
        }
        self.view.backgroundColor = ImageStyle.backgroundColor
        self.navigationController?.navigationBar.barTintColor = ImageStyle.backgroundColor
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ImageStyle.textColor]
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil) // title 부분 수정
        backBarButtonItem.tintColor = ImageStyle.textColor
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        // collectionView
        profileCollectionView.backgroundColor = ImageStyle.backgroundColor
        
        // main profile Image
        profileImge.image = UIImage(named: UserDefaultManager.shared.profileImage)
        profileImge.layer.cornerRadius = profileImge.layer.frame.width / 2
        profileImge.layer.borderColor = ImageStyle.pointColor.cgColor
        profileImge.layer.borderWidth = 2.5
    
    }
    
    func configureCellLayout() -> UICollectionViewFlowLayout {
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
