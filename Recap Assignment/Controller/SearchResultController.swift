//
//  SearchResultController.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/19/24.
//

import UIKit
import Alamofire

//TODO: - 좋아요 버튼 눌렀을 때, button이미지의 변화와 Userdefault에 업데이트 필요함 - 완료
//TODO: - pagination - 완료
//TODO: - button 별 sort request - 완료
//TODO: - cell 선택했을 때 상세화면
//TODO: - 디자인

class SearchResultController: UIViewController {
    @IBOutlet var searchResultTotalCount: UILabel!
    @IBOutlet var searchResultButtonCollection: [UIButton]!
    @IBOutlet var searchResultCollectionView: UICollectionView!
    
    var searchKeyword : String = ""
    var searchResult : NaverShopping = NaverShopping(lastBuildDate: "", total: 0, start: 0, display: 0, items: []) {
        didSet {
            print(#function, "searchResult 수정됨")
            searchResultCollectionView.reloadData()
            configureDesgin()
        }
    }
    
    // api request 관련
    var start = 1
    var display = 30
    
    override func viewWillAppear(_ animated: Bool) {
        searchResultCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDesgin()
        configureCollectionViewProtocol()
        searchResultCollectionView.collectionViewLayout = configureCellLayout()
        
        // view가 띄워질 때, API request에서 sim(default)로 반환된다.
        callRequest(text: searchKeyword) { value, start  in
            self.searchResultUpdate(value: value, start: start)
        }
    }
    
    @IBAction func buttonSearchSpecific(_ sender: UIButton) {
        callRequest(text: searchKeyword, sort: sender.layer.name!) { value, start  in
            print(start)
            self.searchResultUpdate(value: value, start: start)
        }
    }
    
}

//MARK: - collection View 관련
extension SearchResultController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func configureCollectionViewProtocol () {
        
        let xib = UINib(nibName: SearchResultCollectionViewCell.identifier, bundle: nil)
        searchResultCollectionView.register(xib, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
        
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
        searchResultCollectionView.prefetchDataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResult.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = searchResultCollectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as! SearchResultCollectionViewCell
        
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
        
        let sb = UIStoryboard(name: SearchResultDetailViewController.identifier, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: SearchResultDetailViewController.identifier) as! SearchResultDetailViewController

        vc.item = searchResult.items[indexPath.item]
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //TODO: - 눌렀을 때, UserDefault의 Key값을 기준으로 값 변경, 토글 떄리면 될 듯! - 완료
    @objc func searchResultButtonTapped(sender : UIButton) {
        guard let productID = sender.layer.name else { return }
        
        // 좋아요 토글
        UserDefaultManager.shared.userDefaultButtonUpdate(productID: productID)
        //        print(UserDefaultManager.shared.like[productID])
        
        searchResultCollectionView.reloadData()
    }
    
}

//MARK: - collection View pagination
extension SearchResultController : UICollectionViewDataSourcePrefetching {
    //TODO: - Collection View pagination 적용 - 완료
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        print(#function, "- collection View pagination")
        for item in indexPaths {
            if searchResult.items.count - 8 == item.item  && searchResult.items.count < searchResult.total {
                print(#function, "- collection View pagination")
                
                start += display
                callRequest(text: searchKeyword) { value, start in
                    self.searchResultUpdate(value: value, start: start)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        
    }
    
}

//MARK: - normal function
extension SearchResultController {
    //TODO: - 숫자 콤마 적용해야됨
    func configureDesgin() {
        // navgiation
        self.navigationItem.title = "\(searchKeyword)"
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil) // title 부분 수정
        backBarButtonItem.tintColor = ImageStyle.pointColor
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        
        searchResultTotalCount.text = "\(searchResult.total) 개의 검색 결과"
        
        //TODO: - Enum으로 case 정해야할 듯. 만약 안되면, button 별로 IBOutlet 연결해서 따로 진행해야 함 - 완료
        //TODO: - button의 name에 실행될 기능 추가 - 완료
        let requestSort = RequestSort.allCases
        for value in requestSort {
            searchResultButtonCollection[value.index].setTitle(value.rawValue, for: .normal)
            searchResultButtonCollection[value.index].layer.name = value.caseValue
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

//MARK: - API request
extension SearchResultController {
    //completaionHandler : @escaping (NaverShopping) -> ()
    func callRequest(text : String, sort : String = RequestSort.sim.caseValue, completaionHandler : @escaping (NaverShopping, Int) -> ()) {
        
        let query = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(query)&display=\(self.display)&sort=\(sort)&start=\(self.start)"
        
        let header : HTTPHeaders = [
            "X-Naver-Client-Id" : API.naverClientId,
            "X-Naver-Client-Secret": API.naverClientSecret]
        
        AF.request(url, method: .get, headers: header)
            .responseDecodable(of: NaverShopping.self) { response in
                switch response.result {
                case .success(let success) :
                    print("조회 성공")
                    
                    completaionHandler(success, self.start)
                    
                case .failure(let failure) :
                    print(#function)
                    dump(failure)
                }
            }
    }
    
    // completion 내부에서 실행되는 함수
    func searchResultUpdate(value: NaverShopping, start : Int){
        if start == 1 {
            self.searchResult = value
        } else {
            self.searchResult.items.append(contentsOf: value.items)
        }
        
        // 상단으로 올리기
        if start == 1 {
            self.searchResultCollectionView.setContentOffset(.zero, animated: false)
        }
        
        //TODO: - 기존 값에 새로운 값이 추가되었을 때 비교하여 저장하는 함수 필요 - 구현완료
        UserDefaultManager.shared.userDefaultUpdateForLike(new: self.searchResult.productIdwithLike)
        print(#function)
    }
}
