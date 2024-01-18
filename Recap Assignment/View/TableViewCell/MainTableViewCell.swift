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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureCellDesign()
    }
    
}

extension MainTableViewCell {
    func configureCellDesign () {
        mainCellImageView.image = ImageStyle.search
        mainCellImageView.tintColor = ImageStyle.pointColor
        mainCellButton.setTitle("", for: .normal)
        mainCellButton.tintColor = ImageStyle.pointColor
        mainCellButton.setImage(ImageStyle.remove, for: .normal)
        mainCellLabel.textColor = ImageStyle.textColor
        mainCellLabel.font = ImageStyle.normalFontSize
    }
    
    func setCellDate(labelString : String) {
        mainCellLabel.text = labelString
    }
}
