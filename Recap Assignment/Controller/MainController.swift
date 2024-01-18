//
//  ViewController.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/18/24.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var mainSearchbar: UISearchBar!
    @IBOutlet var mainTableView: UITableView!
    @IBOutlet var mainEmptyImage: UIImageView!
    @IBOutlet var mainEmptyLabel: UILabel!
    
    var searchKeywordList : [String] = UserDefaultManager.shared.search {
        didSet {
            print(#function)
            print(searchKeywordList)
            setEmptyUI() // emptyUI
            mainTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableViewProtocol()
        configureSearchBarProtocol()
        
        setEmptyUI() // emptyUI
        configureTableViewDesign()
        configureDesign()
        
    }
    @IBAction func keyboardHide(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

//MARK: - Extension
extension MainViewController : UITableViewDelegate, UITableViewDataSource {
    func configureTableViewProtocol() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        let xib = UINib(nibName: MainTableViewCell.identifier, bundle: nil)
        mainTableView.register(xib, forCellReuseIdentifier: MainTableViewCell.identifier)
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
        
        cell.selectionStyle = .none // 선택 삭제
        
        // cell 내부의 Button 실행 -> cell remove!
        cell.mainCellButton.tag = indexPath.row
        cell.mainCellButton.addTarget(self, action: #selector(mainCellButtonTapped), for: .touchUpInside)
        
        // cell의 label 데이터 나타내기
        cell.setCellDate(labelString: searchKeywordList[indexPath.row])
        
        return cell
    }
    
    // cell button action fuction
    //TODO: - 검색 결과 전달되어야 함
    @objc func mainCellButtonTapped(sender : UIButton) {
        print("\(sender.tag) 버튼이 눌러졌고, 삭제가 될까")
        searchKeywordList.remove(at: sender.tag)
        
        // UserDefault Update
        UserDefaultManager.shared.search = searchKeywordList
    }
    
    //TODO: - Cell 클릭했을 때, 해당 검색어를 전달받는 검색 결과화면 나타나야 됨.
    //TODO: - 값전달은 아직 안 함
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        screenTransition()
    }
    
}

extension MainViewController : UISearchBarDelegate {
    func configureSearchBarProtocol() {
        mainSearchbar.delegate = self
    }
    
    //TODO: - Whitespace, lowercase, 중복제거
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let addText = searchBar.text else { return}
        searchKeywordList.insert(addText, at: 0) // 새로운 값은 무조건 앞으로
        
        // UserDefault Update
        UserDefaultManager.shared.search = searchKeywordList
        
        // 화면 전환 -> 검색 결과 화면(Push)
        screenTransition()
    }
}

// 일반 function
extension MainViewController {
    func configureDesign() {
        mainSearchbar.searchBarStyle = .minimal
        mainSearchbar.placeholder = "브랜드, 상품, 프로필, 태그 등"
        mainEmptyImage.image = ImageStyle.emptyImage
        mainEmptyImage.contentMode = .scaleAspectFit
        mainEmptyLabel.text = "최근 검색어가 없어요!"
        mainEmptyLabel.textAlignment = .center
        mainEmptyLabel.font = ImageStyle.headerFontSize
        mainEmptyLabel.textColor = ImageStyle.textColor
    }
    
    func setEmptyUI() {
        mainTableView.isHidden = searchKeywordList.count == 0 ? true : false
        mainEmptyImage.isHidden = searchKeywordList.count == 0 ? false : true
        mainEmptyLabel.isHidden = searchKeywordList.count == 0 ? false : true
    }
    
    func screenTransition() {
        let sb = UIStoryboard(name: SearchResultController.identifier, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: SearchResultController.identifier) as! SearchResultController
        
        navigationController?.pushViewController(vc, animated: true)
    }
}


