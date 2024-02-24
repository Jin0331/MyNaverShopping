//
//  SearchResultCollectionViewCell.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/19/24.
//

import UIKit
import Kingfisher

class SearchResultCollectionViewCell: UICollectionViewCell {

    let searchResultImage = UIImageView()
    let searchResultMallName = UILabel()
    let searchResultTitle = UILabel()
    let searchResultPrice = UILabel()
    let searchResultButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //TODO: - 여기는 해결책은 좀 찾아봐야 할 것 같음.. contents View의 frame은 가져올 수 있지만, UI의 frame은 현 시점에서 가져올 수 없다.
        searchResultButton.layer.cornerRadius = 35 / 2
    }
    
    func configureView() {
        configureHierachy()
        setupConstraints()
    }
    
    func configureHierachy() {
        [searchResultImage,searchResultMallName,
         searchResultTitle,searchResultPrice,
         searchResultButton].forEach { item in
            return contentView.addSubview(item)
        }
    }
    
    func setupConstraints() {
        searchResultImage.snp.makeConstraints { make in
            make.height.equalTo(170)
            make.top.leading.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(5)
        }
        
        searchResultMallName.snp.makeConstraints { make in
            make.top.equalTo(searchResultImage.snp.bottom).offset(5)
            make.leading.trailing.equalTo(searchResultImage)
        }
        
        searchResultTitle.snp.makeConstraints { make in
            make.top.equalTo(searchResultMallName.snp.bottom).offset(3)
            make.leading.trailing.equalTo(searchResultMallName)
            make.height.equalTo(40)
        }
        
        searchResultPrice.snp.makeConstraints { make in
            make.top.equalTo(searchResultTitle.snp.bottom).offset(3)
            make.leading.trailing.equalTo(searchResultTitle)
        }
        
        searchResultButton.snp.makeConstraints { make in
            make.height.width.equalTo(35)
            make.trailing.bottom.equalTo(searchResultImage).inset(20)
        }
        
    }
    
    
}

extension SearchResultCollectionViewCell {
    
    func configureCellDesign() {
        searchResultImage.clipsToBounds = true
        searchResultImage.layer.cornerRadius = 15
        searchResultImage.contentMode = .scaleAspectFill
                
        searchResultMallName.font = ImageStyle.normalFontSize
        searchResultMallName.textColor = ImageStyle.textColor
        
        searchResultTitle.font = ImageStyle.normalFontSize
        searchResultTitle.numberOfLines = 2
        searchResultTitle.textColor = ImageStyle.textColor
        
        searchResultPrice.font = ImageStyle.headerFontSize
        searchResultPrice.textColor = ImageStyle.textColor
    }
    
    func configureCellData(item : NaverShoppingItem) {
        let imageUrl = URL(string : item.image)
        searchResultImage.kf.setImage(with: imageUrl)
        
        //TODO: - title 특수문자 제거- 완료
        //TODO: - price formatter로 천단위 콤마 추가해야 됨
        searchResultMallName.text = item.mallName
        searchResultTitle.text = item.title.replacingOccurrences(of: "<[^>]+>|&quot;",
                                                                 with: "",
                                                                 options: .regularExpression,
                                                                 range: nil)
        guard let lp = item.lpriceChange else {return}
        searchResultPrice.text = lp
        
        
    }
    
    func configureCellLikeButton(item : NaverShoppingItem) {
        
        // setDesign
        searchResultButton.tintColor = .black
        searchResultButton.backgroundColor = .white
        
        searchResultButton.clipsToBounds = true
//        searchResultButton.layer.cornerRadius = searchResultButton.layer.frame.width / 2
        
        let buttonImage = UserDefaultManager.shared.like[item.productId] ?? false ? "heart.fill" : "heart"
        
        searchResultButton.setImage(UIImage(systemName: buttonImage), for: .normal)


    }
}
