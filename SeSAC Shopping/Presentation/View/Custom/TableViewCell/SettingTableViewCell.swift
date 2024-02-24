//
//  SettingTableViewCell.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/21/24.
//

import UIKit
import SnapKit

class SettingTableViewCell: UITableViewCell {
    
    let settingLabel : UILabel = {
        let settingLabel = UILabel()
        settingLabel.textColor = ImageStyle.textColor
        settingLabel.font = ImageStyle.normalFontSize
        
        return settingLabel
    }()
    
    // 코드로 구성할 때 실행되는 초기화 구문으로, awakeFromNib에서 작성되는 코드도 함꼐 작성
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func configureView() {
        configureHierachy()
        setupConstraints()
    }
    
    func configureHierachy() {
        contentView.addSubview(settingLabel)
    }
    
    func setupConstraints() {
        settingLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(13)
        }
    }
}

extension SettingTableViewCell {
    func configureCell(item : SettingTable) {
        settingLabel.text = item.rawValue
    }
}
