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
//TODO: - cell 선택했을 때 상세화면 - 완료
//TODO: - 디자인 - 완료

class SearchResultController: UIViewController, ViewSetup {
    
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
    
    
    var searchKeyword : String = ""
    var searchResult : NaverShopping = NaverShopping(lastBuildDate: "", total: 0, start: 0, display: 0, items: []) {
        didSet {
            print(#function, "searchResult 수정됨")
            searchResultCollectionView.reloadData()
            searchResultTotalCount.text = "\(self.searchResult.totalChange) 개의 검색 결과"
        }
    }
    
    // api request 관련
    var start = 1
    var display = 30
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchResultCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationDesign()
        configureCollectionViewProtocol()
        configureView()
        
        // view가 띄워질 때, API request에서 sim(default)로 반환된다.
        NaverShoppingAPIManager.shared
            .callRequest(text: self.searchKeyword, start: self.start, display: self.display) { value, start in
                self.searchResultUpdate(value: value, start: start)
            }
        
        // default
        for bt in searchResultButtonCollection {
            bt.backgroundColor = NaverShoppingAPIManager.RequestSort.sim.caseValue == bt.layer.name ? ImageStyle.pointColor :.clear
        }
    }
    
    func configureView() {
        navigationItem.title = "\(searchKeyword)"
        searchResultButtonCollection.map { bt in
            bt.addTarget(self, action: #selector(buttonSearchSpecific), for: .touchUpInside)
            return
        }
        
        configureHierachy()
        setupConstraints()
    }
    
    func configureHierachy() {
        [searchResultTotalCount, searchResultCollectionView, buttonStackView].map { item in
            return view.addSubview(item)
        }
        searchResultButtonCollection.map { item in
            return buttonStackView.addArrangedSubview(item)
        }
        
    }
    
    func setupConstraints() {
        searchResultTotalCount.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(25)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(searchResultTotalCount.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(searchResultTotalCount.snp.trailing).inset(40)
        }
        
        searchResultCollectionView.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(17)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    @objc func buttonSearchSpecific(sender: UIButton) {
        // 뒷 배경 토글
        for bt in searchResultButtonCollection {
            bt.backgroundColor = sender.layer.name == bt.layer.name ? ImageStyle.pointColor :.clear
        }
        
        // sort 방식에 따라 값 호출
        NaverShoppingAPIManager.shared
            .callRequest(text: self.searchKeyword, start: self.start, display: self.display,
                         sort: sender.layer.name!) { value, start in
                self.searchResultUpdate(value: value, start: start)
                self.start = 1
            }
        print("button start index = ", start)
    } // button 누를때, API sort별로 Start 초기화
    
}

//MARK: - collection View 관련
extension SearchResultController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func configureCollectionViewProtocol () {
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
        searchResultCollectionView.prefetchDataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResult.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = searchResultCollectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as! SearchResultCollectionViewCell
        
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
        
        let sb = UIStoryboard(name: SearchResultDetailViewController.identifier, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: SearchResultDetailViewController.identifier) as! SearchResultDetailViewController
        
        vc.item = searchResult.items[indexPath.item]
        
        navigationController?.pushViewController(vc, animated: true)
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
    
    //TODO: - 눌렀을 때, UserDefault의 Key값을 기준으로 값 변경, 토글 떄리면 될 듯! - 완료
    @objc func searchResultButtonTapped(sender : UIButton) {
        guard let productID = sender.layer.name else { return }
        
        // 좋아요 토글
        UserDefaultManager.shared.userDefaultButtonUpdate(productID: productID)
        
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
                
                self.start += self.display
                NaverShoppingAPIManager.shared
                    .callRequest(text: searchKeyword, start: self.start, display: self.display) { value, start in
                        self.searchResultUpdate(value: value, start: start)
                    }
            }
            print("pagination start index = ", start)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        
    }
    
}

//MARK: - API request
extension SearchResultController {
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
