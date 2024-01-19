//
//  SearchResultCollectionViewCell.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/19/24.
//

import UIKit

class SearchResultCollectionViewCell: UICollectionViewCell {

    @IBOutlet var searchResultImage: UIImageView!
    @IBOutlet var searchResultMallName: UILabel!
    @IBOutlet var searchResultTitle : UILabel!
    @IBOutlet var searchResultPrice: UILabel!
    @IBOutlet var searchResultButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureCellDesign()
    }

}

extension SearchResultCollectionViewCell {
    
    func configureCellDesign() {
        searchResultImage.clipsToBounds = true
        searchResultImage.layer.cornerRadius = 10
        searchResultImage.contentMode = .scaleAspectFill
        
        searchResultButton.clipsToBounds = true
        searchResultButton.backgroundColor = .white
        searchResultButton.tintColor = .black
        
        searchResultMallName.font = ImageStyle.normalFontSize
        searchResultMallName.textColor = ImageStyle.textColor
        
        searchResultTitle.font = ImageStyle.normalFontSize
        searchResultTitle.textColor = ImageStyle.textColor
        
        searchResultPrice.font = ImageStyle.headerFontSize
        searchResultPrice.textColor = ImageStyle.textColor

    }
}
