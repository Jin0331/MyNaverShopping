//
//  ViewController.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/18/24.
//

import UIKit
import SnapKit
import UserNotifications

class MainViewController: UIViewController {
    
    var searchKeywordList : [String] = UserDefaultManager.shared.search {
        didSet {
            print(#function)
            setEmptyUI() // emptyUI
            mainTableView.reloadData()
        }
    }
    
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
        
        mainTableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        
        return mainTableView
    }()
    
    //MARK: - App LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationDesign()
        configureTableViewProtocol()
        configureSearchBarProtocol()
        configureView()
        
        setEmptyUI() // emptyUI
        configureTableViewDesign()
        hideKeyboardWhenTappedAround()
        
        //TODO: - 좋아요 개수의 노티 - 완료
        callNotification(seconds: 600, repeat_: true)
    }
    
}

//MARK: - codabse UI
extension MainViewController {
    //MARK: - function
    func configureView() {
        view.backgroundColor = ImageStyle.backgroundColor
        navigationItem.title = "\(UserDefaultManager.shared.nickname)님의 새싹쇼핑"
        
        removeButton.addTarget(self, action: #selector(searchKeywordRemove), for: .touchUpInside)
        
        print(#function)
        configureHierachy()
        setupConstraints()
    }
    
    func configureHierachy() {
        [mainSearchbar, latestLabel, removeButton, mainTableView, mainEmptyImage, mainEmptyLabel].map { item in
            return view.addSubview(item)
        }
        
    }
    
    func setupConstraints() {
        mainSearchbar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(5)
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
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        mainEmptyImage.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view.safeAreaLayoutGuide)
            make.width.height.equalTo(300)
        }
        
        mainEmptyLabel.snp.makeConstraints { make in
            make.top.equalTo(mainEmptyImage.snp.bottom).offset(10)
            make.centerX.equalTo(mainEmptyImage)
        }
    }
    
    func setEmptyUI() {
        mainTableView.isHidden = searchKeywordList.count == 0 ? true : false
        mainEmptyImage.isHidden = searchKeywordList.count == 0 ? false : true
        mainEmptyLabel.isHidden = searchKeywordList.count == 0 ? false : true
    }
    
    func screenTransition(sendText : String) {
        let sb = UIStoryboard(name: SearchResultController.identifier, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: SearchResultController.identifier) as! SearchResultController
        
        vc.searchKeyword = sendText
        view.endEditing(true)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func searchKeywordRemove(sender : UIButton) {
        searchKeywordList = []
        UserDefaultManager.shared.search = []
        mainTableView.reloadData()
    }

}

//MARK: - Extension
extension MainViewController : UITableViewDelegate, UITableViewDataSource {
    func configureTableViewProtocol() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
    }
    
    func configureTableViewDesign() {
        mainTableView.separatorStyle = .none
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchKeywordList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as! MainTableViewCell
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        // cell 내부의 Button 실행 -> cell remove!
        cell.mainCellButton.tag = indexPath.row
        cell.mainCellButton.addTarget(self, action: #selector(mainCellButtonTapped), for: .touchUpInside)
        
        // 화면전환
        cell.mainCellClickedButton.tag = indexPath.row
        cell.mainCellClickedButton.addTarget(self, action: #selector(mainCellButtonTappedTransition), for: .touchUpInside)
        
        // cell의 label 데이터 나타내기
        cell.setCellDate(labelString: searchKeywordList[indexPath.row])
        
        return cell
    }
    
    // cell button action fuction
    //TODO: - 검색 결과 전달되어야 함 - 완료
    @objc func mainCellButtonTapped(sender : UIButton) {
        print("\(sender.tag) 버튼이 눌러졌고, 삭제")
        searchKeywordList.remove(at: sender.tag)
        
        // UserDefault Update
        //TODO: - 동일한 값이 들어왔을 떄 중복제거 필요함 - 완료
        UserDefaultManager.shared.search = searchKeywordList
    }
    
    @objc func mainCellButtonTappedTransition(sender : UIButton) {
        print("\(sender.tag) 버튼이 눌러졌고, 화면전환")
        screenTransition(sendText: searchKeywordList[sender.tag])
    }
    
}

extension MainViewController : UISearchBarDelegate {
    func configureSearchBarProtocol() {
        mainSearchbar.delegate = self
    }
    
    //TODO: - Whitespace, lowercase, 중복제거 - 완료
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let addText = searchBar.text else { return }
        
        // 기존 검색이 있었는지 판단하고, 과거의 값을 지우고 추가
        if searchKeywordList.contains(addText){
            searchKeywordList.remove(at: searchKeywordList.firstIndex(of: addText)!)
        }
        searchKeywordList.insert(addText, at: 0) // 새로운 값은 무조건 앞으로
        // UserDefault Update
        UserDefaultManager.shared.search = searchKeywordList
        
        // 화면 전환 -> 검색 결과 화면(Push)
        screenTransition(sendText: addText)
    }
}
