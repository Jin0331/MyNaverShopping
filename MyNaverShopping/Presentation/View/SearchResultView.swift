//
//  SearchResultView.swift
//  SeSAC Shopping
//
//  Created by JinwooLee on 2/26/24.
//

import UIKit
import SnapKit

class SearchResultView : BaseView {
    
    lazy var searchResultTotalCount : UILabel = {
        let searchResultTotalCount = UILabel()
        searchResultTotalCount.textColor = ImageStyle.pointColor
        searchResultTotalCount.font = ImageStyle.headerFontSize
        
        return searchResultTotalCount
    }()
    
    let searchResultButtonCollection : [CommonButton] = {
        let searchResultButtonCollection = [CommonButton(),CommonButton(),CommonButton(),CommonButton()]
        let requestSort = NaverShoppingAPIManager.RequestSort.allCases
        for value in requestSort {
            searchResultButtonCollection[value.index].configureSearchResultButton(title: value.rawValue, layerName: value.caseValue)
        }
        
        return searchResultButtonCollection
    }()
    
    lazy var searchResultCollectionView : UICollectionView = {
        let searchResultCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCellLayout())
        searchResultCollectionView.backgroundColor = .clear
        //TODO: - cell file codebase로 수정하면, register 추가
        searchResultCollectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
        
        return searchResultCollectionView
    }()
    
    let buttonStackView : UIStackView = {
        let buttonStackView = UIStackView()
        buttonStackView.axis = .horizontal
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 6
        
        return buttonStackView
    }()
    
    override func configureHierarchy() {
        [searchResultTotalCount, searchResultCollectionView, buttonStackView].forEach { item in
            return addSubview(item)
        }
        searchResultButtonCollection.forEach { item in
            return buttonStackView.addArrangedSubview(item)
        }
        
    }
    
    override func configureLayout() {
        searchResultTotalCount.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(30)
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(10)
            make.height.equalTo(25)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(searchResultTotalCount.snp.bottom).offset(20)
            make.leading.equalTo(safeAreaLayoutGuide)
            make.trailing.equalTo(searchResultTotalCount.snp.trailing).inset(40)
        }
        
        searchResultCollectionView.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(17)
            make.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
        }
        
    }
    
    private func configureCellLayout() -> UICollectionViewFlowLayout {
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
