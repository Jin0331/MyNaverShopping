//
//  SearchResultController.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/19/24.
//

import UIKit
import Alamofire

class SearchResultViewController: BaseViewController {
    
    let mainView = SearchResultView()
    let viewModel = SearchResultViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.searchResultCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationDesign()
        configureView()
        bindData()
        
        viewModel.inputViewDidLoadCallRequestTriger.value = ()
    }
    
    func bindData() {
        viewModel.searchResult.bind { value in
            print(#function, "searchResult 수정됨")
            self.mainView.searchResultCollectionView.reloadData()
            self.mainView.searchResultTotalCount.text = "\(value.totalChange) 개의 검색 결과"
        }
        
        viewModel.start.bind { value in
            // 상단으로 올리기
            if value == 1 {
                self.mainView.searchResultCollectionView.setContentOffset(.zero, animated: false)
            }
        }
    }
    
    override func configureView() {
        super.configureView()
        
        navigationItem.title = "\(self.viewModel.inputKeyword.value)"
        
        mainView.searchResultCollectionView.delegate = self
        mainView.searchResultCollectionView.dataSource = self
        mainView.searchResultCollectionView.prefetchDataSource = self
        
        mainView.searchResultButtonCollection.forEach { bt in bt.addTarget(self, action: #selector(buttonSearchSpecific), for: .touchUpInside)}
        
        // default
        for bt in mainView.searchResultButtonCollection {
            bt.backgroundColor = NaverShoppingAPIManager.RequestSort.sim.caseValue == bt.layer.name ? ImageStyle.pointColor :.clear
        }
    }
    
    @objc func buttonSearchSpecific(sender: UIButton) {
        // 뒷 배경 토글
        for bt in mainView.searchResultButtonCollection {
            bt.backgroundColor = sender.layer.name == bt.layer.name ? ImageStyle.pointColor :.clear
        }
        
        let sortType = sender.layer.name!
        viewModel.inputbuttonSearchSpecificCallRequestTriger.value = NaverAPI.RequestSort(rawValue: sortType)
        
    } // button 누를때, API sort별로 Start 초기화
    
}

//MARK: - collection View 관련
extension SearchResultViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.searchResult.value.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = mainView.searchResultCollectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as! SearchResultCollectionViewCell
        
        cell.configureCellDesign()
        cell.configureCellData(item: viewModel.searchResult.value.items[indexPath.item])
        cell.configureCellLikeButton(item: viewModel.searchResult.value.items[indexPath.item])
        
        //TODO: - cell 내의 button 동작을 위한 함수 구현 - 완료
        cell.searchResultButton.tag = indexPath.item
        cell.searchResultButton.layer.name = viewModel.searchResult.value.items[indexPath.item].productId // Button에 ProductID 전달
        
        cell.searchResultButton.addTarget(self, action: #selector(searchResultButtonTapped), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = SearchResultDetailViewController()
        vc.item = viewModel.searchResult.value.items[indexPath.item]
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //TODO: - 눌렀을 때, UserDefault의 Key값을 기준으로 값 변경, 토글 떄리면 될 듯! - 완료
    @objc func searchResultButtonTapped(sender : UIButton) {
        guard let productID = sender.layer.name else { return }
        
        // 좋아요 토글
        UserDefaultManager.shared.userDefaultButtonUpdate(productID: productID)
        mainView.searchResultCollectionView.reloadData()
    }

}

//MARK: - collection View pagination
extension SearchResultViewController : UICollectionViewDataSourcePrefetching {
    //TODO: - Collection View pagination 적용 - 완료
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        print(#function, "- collection View pagination")
        for item in indexPaths {
            if viewModel.searchResult.value.items.count - 8 == item.item  && viewModel.searchResult.value.items.count < viewModel.searchResult.value.total {
                print(#function, "- collection View pagination")
                
                self.viewModel.start.value += self.viewModel.display.value
                viewModel.inputViewDidLoadCallRequestTriger.value = ()
            }
        }
    }
}
