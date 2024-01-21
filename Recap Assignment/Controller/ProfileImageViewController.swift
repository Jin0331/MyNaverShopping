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
        
        profileCollectionView.collectionViewLayout = configureCellLayout()
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
        
        
        return cell
    }
}


extension ProfileImageViewController {
    func configureCollectionViewDeisgn() {
        
    }
    
    func configureCellLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        let rowCount : Double = 4
        let sectionSpacing : CGFloat = 5
        let itemSpacing : CGFloat = 8
        let width : CGFloat = UIScreen.main.bounds.width - (itemSpacing * (rowCount - 1)) - (sectionSpacing * 2)
        let itemWidth: CGFloat = width / rowCount
        
        // 각 item의 크기 설정 (아래 코드는 정사각형을 그린다는 가정)
        layout.itemSize = CGSize(width: itemWidth - 5 , height: itemWidth + 80)
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
