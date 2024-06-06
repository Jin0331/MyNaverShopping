//
//  MainView.swift
//  SeSAC Shopping
//
//  Created by JinwooLee on 2/24/24.
//

import UIKit
import RxSwift
import RxCocoa

class MainView : BaseView {
    //MARK: - UI
    let mainSearchbar : UISearchBar = {
        let mainSearchbar = UISearchBar()
        
        mainSearchbar.searchBarStyle = .minimal
        mainSearchbar.barStyle = .black
        mainSearchbar.tintColor = ImageStyle.textColor
        mainSearchbar.placeholder = "브랜드, 상품, 프로필, 태그 등"
        
        return mainSearchbar
    }()
    let latestLabel : UILabel = {
        let latestLabel = UILabel()
        latestLabel.text = "최근 검색"
        latestLabel.textColor = ImageStyle.textColor
        latestLabel.font = ImageStyle.normalFontSize
        
        return latestLabel
    }()
    let mainEmptyImage : UIImageView = {
        let mainEmptyImage = UIImageView()
        mainEmptyImage.image = ImageStyle.emptyImage
        mainEmptyImage.contentMode = .scaleAspectFit
        
        return mainEmptyImage
    }()
    let mainEmptyLabel : UILabel = {
       let mainEmptyLabel = UILabel()
        mainEmptyLabel.text = "최근 검색어가 없어요!"
        mainEmptyLabel.textAlignment = .center
        mainEmptyLabel.font = ImageStyle.headerFontSize
        mainEmptyLabel.textColor = ImageStyle.textColor
        
        return mainEmptyLabel
    }()
    let removeButton : UIButton = {
        let removeButton = UIButton()
        removeButton.setTitle("모두 지우기", for: .normal)
        removeButton.setTitleColor(ImageStyle.pointColor, for: .normal)
        removeButton.titleLabel?.font = ImageStyle.normalFontSize
        removeButton.titleLabel?.textAlignment = .right
        
        return removeButton
    }()
    let mainTableView : UITableView = {
        let mainTableView = UITableView()
        mainTableView.backgroundColor = .clear
        mainTableView.separatorStyle = .none
        mainTableView.rowHeight = 50
        mainTableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        
        return mainTableView
    }()
    
    override func configureHierarchy() {
        [mainSearchbar, latestLabel, removeButton, mainTableView, mainEmptyImage, mainEmptyLabel].forEach { item in
            return addSubview(item)
        }
        
    }
    
    override func configureLayout() {
        mainSearchbar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(5)
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(5)
        }
        
        latestLabel.snp.makeConstraints { make in
            make.top.equalTo(mainSearchbar.snp.bottom).offset(10)
            make.leading.equalTo(mainSearchbar.snp.leading)
            make.width.equalTo(60)
        }
        
        removeButton.snp.makeConstraints { make in
            make.top.equalTo(latestLabel.snp.top)
            make.leading.equalTo(mainSearchbar.snp.leading).offset(310)
            make.trailing.equalTo(mainSearchbar.snp.trailing)
        }
        
        mainTableView.snp.makeConstraints { make in
            make.top.equalTo(latestLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        mainEmptyImage.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(safeAreaLayoutGuide)
            make.width.height.equalTo(300)
        }
        
        mainEmptyLabel.snp.makeConstraints { make in
            make.top.equalTo(mainEmptyImage.snp.bottom).offset(10)
            make.centerX.equalTo(mainEmptyImage)
        }
    }
}
