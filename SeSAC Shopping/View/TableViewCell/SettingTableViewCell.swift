//
//  SettingTableViewCell.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/21/24.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet var settingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

extension SettingTableViewCell {
    func configureDesign(item : SettingTable) {
        settingLabel.textColor = ImageStyle.textColor
        settingLabel.font = ImageStyle.normalFontSize
        settingLabel.text = item.rawValue
    }
}
