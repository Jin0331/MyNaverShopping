//
//  SearchResultController.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/19/24.
//

import UIKit
import Alamofire

class SearchResultController: UIViewController {
    @IBOutlet var searchResultTotalCount: UILabel!
    //TODO: - Enum으로 case 정해야할 듯. 만약 안되면, button 별로 IBOutlet 연결해서 따로 진행해야 함
    @IBOutlet var searchResultButtonCollection: [UIButton]!
    @IBOutlet var searchResultCollectionView: UICollectionView!
    
    //TODO: -
    var searchKeyword : String = ""
    var searchResult : NaverShopping = NaverShopping(lastBuildDate: "", total: 0, start: 0, display: 0, items: []) {
        didSet {
            print(#function, "searchResult 수정됨")
            searchResultCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDesgin()
        configureCollectionViewProtocol()
        searchResultCollectionView.collectionViewLayout = configureCellLayout()
        
        callRequest(text: searchKeyword) { value in
            self.searchResult = value
        }
        
    }
}

extension SearchResultController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func configureCollectionViewProtocol () {
        
        let xib = UINib(nibName: SearchResultCollectionViewCell.identifier, bundle: nil)
        searchResultCollectionView.register(xib, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
        
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResult.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = searchResultCollectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as! SearchResultCollectionViewCell
        
        cell.configureCellDesign()
        cell.configureCellData(item: searchResult.items[indexPath.item])
        
        return cell
        
    }
    
    
}

extension SearchResultController {
    func configureDesgin() {
        navigationItem.title = "\(searchKeyword)"
        navigationItem.rightBarButtonItem?.title = nil
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

extension SearchResultController {
    //completaionHandler : @escaping (NaverShopping) -> ()
    func callRequest(text : String, completaionHandler : @escaping (NaverShopping) -> ()) {
        
        let query = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(query)&display=30"
        
        let header : HTTPHeaders = [
            "X-Naver-Client-Id" : API.naverClientId,
            "X-Naver-Client-Secret": API.naverClientSecret]
        
        AF.request(url, method: .get, headers: header)
            .responseDecodable(of: NaverShopping.self) { response in
                switch response.result {
                case .success(let success) :
                    print("조회 성공")
                    completaionHandler(success)
                    
                case .failure(let failure) :
                    print(#function)
                    dump(failure)
                }
            }
    }
}
