//
//  MainTableViewCell.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/18/24.
//

import UIKit

class MainTableViewCell: UITableViewCell{
    let mainCellLabel : UILabel = {
       let mainCellLabel = UILabel()
        mainCellLabel.textColor = ImageStyle.textColor
        mainCellLabel.font = ImageStyle.normalFontSize
        
        return mainCellLabel
    }()
    
    let mainCellImageView : UIImageView = {
       let mainCellImageView = UIImageView()
        mainCellImageView.image = ImageStyle.search
        mainCellImageView.tintColor = ImageStyle.textColor

        return mainCellImageView
    }()
    
    let mainCellButton : UIButton = {
        let mainCellButton = UIButton()
        mainCellButton.setTitle("", for: .normal)
        mainCellButton.tintColor = ImageStyle.textColor
        mainCellButton.setImage(ImageStyle.remove, for: .normal)

        return mainCellButton
    }()
    
    let mainCellClickedButton : UIButton = {
        let mainCellClickedButton = UIButton()
        mainCellClickedButton.setTitle("", for: .normal)
        
        return mainCellClickedButton
    }()
    
    
    // 코드로 구성할 때 실행되는 초기화 구문으로, awakeFromNib에서 작성되는 코드도 함꼐 작성
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierachy() {
        [mainCellLabel, mainCellImageView, mainCellButton, mainCellClickedButton].forEach { item in
            return contentView.addSubview(item)
        }
    }
    
    func setupConstraints() {
        mainCellImageView.snp.makeConstraints { make in
            make.top.equalTo(self.contentView).inset(10)
            make.leading.equalTo(self.contentView).inset(20)
            make.width.height.equalTo(20)
        }
        mainCellLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(mainCellImageView)
            make.leading.equalTo(mainCellImageView.snp.trailing).offset(20)
            make.trailing.equalTo(mainCellButton.snp.leading).inset(10)
        }
        mainCellButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(mainCellImageView)
            make.trailing.equalTo(self.contentView).inset(15)
            make.width.height.equalTo(20)
        }
        mainCellClickedButton.snp.makeConstraints { make in
            make.top.bottom.leading.equalTo(mainCellLabel)
            make.trailing.equalTo(mainCellLabel.snp.trailing).inset(10)
        }
    }
    
    func configureView() {
        self.backgroundColor = .clear
        
        configureHierachy()
        setupConstraints()
    }
}


extension MainTableViewCell {
    func setCellDate(labelString : String) {
        mainCellLabel.text = labelString
    }
}
