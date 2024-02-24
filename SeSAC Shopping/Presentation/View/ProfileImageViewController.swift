//
//  ProfileImageViewController.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/21/24.
//

import UIKit

class ProfileImageViewController: UIViewController {
    
    let profileImage : ProfileImageView = {
        let profileImage = ProfileImageView(frame: .zero)
        profileImage.configureImageSpecific(borderWidth: 3.5, userDefaultImageName: UserDefaultManager.shared.tempProfileImage)
     
        return profileImage
    }()
    
    lazy var profileCollectionView : UICollectionView = {
        let profileCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCellLayout())
        profileCollectionView.backgroundColor = ImageStyle.backgroundColor
        profileCollectionView.register(ProfileImageCollectionViewCell.self, forCellWithReuseIdentifier: ProfileImageCollectionViewCell.identifier)
        
        return profileCollectionView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationDesign() 
        configureCollectionViewProtocol()
        configureView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImage.configureCornerRadius()
    }
    
    func configureView() {
        if UserDefaultManager.shared.userState == UserDefaultManager.UserStateCode.new.state {
            navigationItem.title = "프로필 설정"
        } else {
            navigationItem.title = "프로필 수정"
        }
        
        configureHierachy()
        setupConstraints()
    }
    
    func configureHierachy() {
        [profileImage, profileCollectionView].forEach { item in
            return view.addSubview(item)
        }
    }
    
    func setupConstraints() {
        profileImage.snp.makeConstraints { make in
            make.height.width.equalTo(150)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        profileCollectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(profileImage.snp.bottom).offset(20)
        }
    }

}

extension ProfileImageViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func configureCollectionViewProtocol () {
        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserDefaultManager.shared.assetList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = profileCollectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCollectionViewCell.identifier, for: indexPath) as! ProfileImageCollectionViewCell
        
        cell.profileImage.configureSelectedBorder(asset: UserDefaultManager.shared.assetList[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 선택된 값으로 교체
        UserDefaultManager.shared.tempProfileImage = UserDefaultManager.shared.assetList[indexPath.item]
        print(UserDefaultManager.shared.tempProfileImage)
        profileImage.setImage(name: UserDefaultManager.shared.tempProfileImage)
        
        profileCollectionView.reloadData()
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

