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
    var searchKeyword : String = ""
    var searchResult : NaverShoppingModel = NaverShoppingModel(lastBuildDate: "", total: 0, start: 0, display: 0, items: []) {
        didSet {
            print(#function, "searchResult 수정됨")
            mainView.searchResultCollectionView.reloadData()
            mainView.searchResultTotalCount.text = "\(self.searchResult.totalChange) 개의 검색 결과"
        }
    }
    
    // api request 관련
    var start = 1
    var display = 30
    
    
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
        configureCollectionViewProtocol()
        configureView()
        
        DispatchQueue.global().async {
            NaverShoppingAPIManager.shared.callRequestURLSession(api: .shop(query: self.searchKeyword, display: String(self.display), sort: NaverAPI.RequestSort.sim.caseValue, start: String(self.start))) { (item : NaverShoppingModel?, start : Int?, error:NaverAPI.APIError?) in
                
                if error == nil {
                    guard let item = item else { return }
                    guard let start = start else { return }
                    
                    print(#function, start)
                    self.searchResultUpdate(value: item, start: start)
                } else {
                    dump(error)
                }
            }
        }
        
        // default
        for bt in mainView.searchResultButtonCollection {
            bt.backgroundColor = NaverShoppingAPIManager.RequestSort.sim.caseValue == bt.layer.name ? ImageStyle.pointColor :.clear
        }
    }
    
    override func configureView() {
        super.configureView()
        navigationItem.title = "\(searchKeyword)"
        mainView.searchResultButtonCollection.forEach { bt in
            bt.addTarget(self, action: #selector(buttonSearchSpecific), for: .touchUpInside)
            return
        }
    }
    
    @objc func buttonSearchSpecific(sender: UIButton) {
        // 뒷 배경 토글
        for bt in mainView.searchResultButtonCollection {
            bt.backgroundColor = sender.layer.name == bt.layer.name ? ImageStyle.pointColor :.clear
        }
        
        let sortType = sender.layer.name!
        DispatchQueue.global().async {
            NaverShoppingAPIManager.shared.callRequestURLSession(api: .shop(query: self.searchKeyword, display: String(self.display), sort: sortType, start: String(self.start))) { (item : NaverShoppingModel?, start : Int?, error:NaverAPI.APIError?) in
                
                if error == nil {
                    guard let item = item else { return }
                    guard let start = start else { return }
                    print(#function, start)
                    
                    self.searchResultUpdate(value: item, start: start)
                    self.start = 1
                } else {
                    dump(error)
                }
            }
        }
        print("button start index = ", start)
    } // button 누를때, API sort별로 Start 초기화
    
}

//MARK: - collection View 관련
extension SearchResultViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func configureCollectionViewProtocol () {
        mainView.searchResultCollectionView.delegate = self
        mainView.searchResultCollectionView.dataSource = self
        mainView.searchResultCollectionView.prefetchDataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResult.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = mainView.searchResultCollectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as! SearchResultCollectionViewCell
        
        cell.backgroundColor = .clear
        cell.configureCellDesign()
        cell.configureCellData(item: searchResult.items[indexPath.item])
        cell.configureCellLikeButton(item: searchResult.items[indexPath.item])
        
        //TODO: - cell 내의 button 동작을 위한 함수 구현 - 완료
        cell.searchResultButton.tag = indexPath.item
        cell.searchResultButton.layer.name = searchResult.items[indexPath.item].productId // Button에 ProductID 전달
        
        cell.searchResultButton.addTarget(self, action: #selector(searchResultButtonTapped), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = SearchResultDetailViewController()
        vc.item = searchResult.items[indexPath.item]
        
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
            if searchResult.items.count - 8 == item.item  && searchResult.items.count < searchResult.total {
                print(#function, "- collection View pagination")
                
                self.start += self.display
                DispatchQueue.global().async {
                    NaverShoppingAPIManager.shared.callRequestURLSession(api: .shop(query: self.searchKeyword, display: String(self.display), sort: NaverAPI.RequestSort.sim.caseValue, start: String(self.start))) { (item : NaverShoppingModel?, start : Int?, error:NaverAPI.APIError?) in
                        
                        if error == nil {
                            guard let item = item else { return }
                            guard let start = start else { return }
                            
                            print(#function, start)
                            self.searchResultUpdate(value: item, start: start)
                        } else {
                            dump(error)
                        }
                    }
                }
            }
            print("pagination start index = ", start)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        
    }
    
}

//MARK: - API request
extension SearchResultViewController {
    // completion 내부에서 실행되는 함수
    func searchResultUpdate(value: NaverShoppingModel, start : Int){
        if start == 1 {
            self.searchResult = value
        } else {
            self.searchResult.items.append(contentsOf: value.items)
        }
        
        // 상단으로 올리기
        if start == 1 {
            self.mainView.searchResultCollectionView.setContentOffset(.zero, animated: false)
        }
        
        //TODO: - 기존 값에 새로운 값이 추가되었을 때 비교하여 저장하는 함수 필요 - 구현완료
        UserDefaultManager.shared.userDefaultUpdateForLike(new: self.searchResult.productIdwithLike)
        print(#function)
    }
}
