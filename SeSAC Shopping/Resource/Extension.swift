//
//  Extension.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/18/24.
//

import UIKit

extension UITableViewCell : ResuableProtocol {
    static var identifier: String {
        return String(describing: self)
    }
    var identifier_: String {
        return String(describing: type(of: self))
    }
}

extension UICollectionViewCell : ResuableProtocol {
    static var identifier: String {
        return String(describing: self)
    }
    var identifier_: String {
        return String(describing: type(of: self))
    }
}

//MARK: - search Result design
extension SearchResultController {
    //TODO: - 숫자 콤마 적용해야됨 - 완료
    func configureDesgin() {
        // navgiation
        self.navigationItem.title = "\(searchKeyword)"
        searchResultCollectionView.backgroundColor = .clear
        searchResultTotalCount.text = "\(searchResult.totalChange) 개의 검색 결과"
        searchResultTotalCount.textColor = ImageStyle.pointColor
        searchResultTotalCount.font = ImageStyle.headerFontSize
        
        //TODO: - Enum으로 case 정해야할 듯. 만약 안되면, button 별로 IBOutlet 연결해서 따로 진행해야 함 - 완료
        //TODO: - button의 name에 실행될 기능 추가 - 완료
        let requestSort = NaverShoppingAPIManager.RequestSort.allCases
        for value in requestSort {
            searchResultButtonCollection[value.index].setTitle(value.rawValue, for: .normal)
            searchResultButtonCollection[value.index].layer.name = value.caseValue
            searchResultButtonCollection[value.index].setTitleColor(ImageStyle.textColor, for: .normal)
            searchResultButtonCollection[value.index].titleLabel?.font = ImageStyle.normalFontSize
            searchResultButtonCollection[value.index].layer.borderWidth = 1
            searchResultButtonCollection[value.index].layer.borderColor = ImageStyle.textColor.cgColor
            searchResultButtonCollection[value.index].clipsToBounds = true
            searchResultButtonCollection[value.index].layer.cornerRadius = 10
        }
    }
    
    func configureCellLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        let rowCount : Double = 2
        let sectionSpacing : CGFloat = 5
        let itemSpacing : CGFloat = 8
        let width : CGFloat = UIScreen.main.bounds.width - (itemSpacing * (rowCount - 1)) - (sectionSpacing * 2)
        let itemWidth: CGFloat = width / rowCount
        
        // 각 item의 크기 설정 (아래 코드는 정사각형을 그린다는 가정)
        layout.itemSize = CGSize(width: itemWidth - 5 , height: itemWidth + 80)
        // 스크롤 방향 설정
        layout.scrollDirection = .vertical
        // Section간 간격 설정
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        // item간 간격 설정
        layout.minimumLineSpacing = itemSpacing        // 최소 줄간 간격 (수직 간격)
        layout.minimumInteritemSpacing = itemSpacing   // 최소 행간 간격 (수평 간격)
        
        return layout
    }
}
