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
        searchResultMallName.font = ImageStyle.normalFontSize
        searchResultMallName.textColor = ImageStyle.textColor
    }
}
