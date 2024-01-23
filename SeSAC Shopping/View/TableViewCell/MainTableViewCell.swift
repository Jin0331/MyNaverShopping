//
//  MainTableViewCell.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/18/24.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet var mainCellImageView: UIImageView!
    @IBOutlet var mainCellLabel: UILabel!
    @IBOutlet var mainCellButton: UIButton!
    @IBOutlet var mainCellClickedButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureCellDesign()
    }
    
}

extension MainTableViewCell {
    func configureCellDesign () {
        mainCellImageView.image = ImageStyle.search
        mainCellImageView.tintColor = ImageStyle.textColor
        mainCellButton.setTitle("", for: .normal)
        mainCellButton.tintColor = ImageStyle.textColor
        mainCellButton.setImage(ImageStyle.remove, for: .normal)
        mainCellClickedButton.setTitle("", for: .normal)
        mainCellLabel.textColor = ImageStyle.textColor
        mainCellLabel.font = ImageStyle.normalFontSize
    }
    
    func setCellDate(labelString : String) {
        mainCellLabel.text = labelString
    }
}
