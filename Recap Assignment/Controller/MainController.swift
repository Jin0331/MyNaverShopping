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
    @IBOutlet var latestLabel: UILabel!
    @IBOutlet var removeButton: UIButton!
    
    var searchKeywordList : [String] = UserDefaultManager.shared.search {
        didSet {
            print(#function)
            //            print(searchKeywordList)
            setEmptyUI() // emptyUI
            mainTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationDesign()
        configureTableViewProtocol()
        configureSearchBarProtocol()
        
        setEmptyUI() // emptyUI
        configureTableViewDesign()
        configureDesign()
        
    }
    
    @IBAction func searchKeywordRemove(_ sender: UIButton) {
        searchKeywordList = []
        UserDefaultManager.shared.search = []
        mainTableView.reloadData()
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
        
        cell.backgroundColor = .clear
        //        cell.selectionStyle = .none // 선택 삭제
        
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
        //TODO: - 동일한 값이 들어왔을 떄 중복제거 필요함
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


