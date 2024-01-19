//
//  SearchResultCollectionViewCell.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/19/24.
//

import UIKit
import Kingfisher

class SearchResultCollectionViewCell: UICollectionViewCell {

    @IBOutlet var searchResultImage: UIImageView!
    @IBOutlet var searchResultMallName: UILabel!
    @IBOutlet var searchResultTitle : UILabel!
    @IBOutlet var searchResultPrice: UILabel!
    @IBOutlet var searchResultButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
        searchResultTitle.textColor = ImageStyle.textColor
        
        searchResultPrice.font = ImageStyle.headerFontSize
        searchResultPrice.textColor = ImageStyle.textColor
    }
    
    func configureCellData(item : NaverShoppingItem) {
        let imageUrl = URL(string : item.image)
        searchResultImage.kf.setImage(with: imageUrl)
        
        
        //TODO: - title 특수문자 제거, price formatter로 천단위 콤마 추가해야 됨
        searchResultMallName.text = item.mallName
        searchResultTitle.text = item.title
        searchResultPrice.text = item.lprice
        
        
    }
    
    func configureCellLikeButton(item : NaverShoppingItem) {
        
        // setDesign
        searchResultButton.tintColor = .black
        searchResultButton.backgroundColor = .white
        
        searchResultButton.clipsToBounds = true
        searchResultButton.layer.cornerRadius = searchResultButton.layer.frame.width / 2
        
        let buttonImage = UserDefaultManager.shared.like[item.productId] ?? false ? "heart.fill" : "heart"
        
        searchResultButton.setImage(UIImage(systemName: buttonImage), for: .normal)


    }
}
