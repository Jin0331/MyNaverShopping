//
//  ViewController.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/18/24.
//

import UIKit
import SnapKit
import UserNotifications

class MainViewController: BaseViewController {
    
    let mainView = MainView()
    let viewModel = MainViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    //MARK: - App LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationDesign()
        callNotification(seconds: 600, repeat_: true)
        
        viewModel.inputSearchKeywordList.bind { _ in
            self.viewToggle()
            self.mainView.mainTableView.reloadData()
        }
    }
    
    override func configureView() {
        navigationItem.title = "\(UserDefaultManager.shared.nickname)님의 새싹쇼핑"
        
        viewToggle()
        hideKeyboardWhenTappedAround()
        
        mainView.mainTableView.delegate = self
        mainView.mainTableView.dataSource = self
        mainView.mainSearchbar.delegate = self

        mainView.removeButton.addTarget(self, action: #selector(searchKeywordRemove), for: .touchUpInside)
    }
    
}

//MARK: - codabse UI
extension MainViewController  {
    //MARK: - function
    
    func viewToggle() {
        mainView.mainTableView.isHidden = viewModel.inputSearchKeywordListBool
        mainView.mainEmptyImage.isHidden = !viewModel.inputSearchKeywordListBool
        mainView.mainEmptyLabel.isHidden = !viewModel.inputSearchKeywordListBool
        
        mainView.removeButton.isHidden = viewModel.inputSearchKeywordListBool
        mainView.latestLabel.isHidden = viewModel.inputSearchKeywordListBool

    }
    
    func screenTransition(sendText : String) {
        let vc = SearchResultViewController()
        
        vc.searchKeyword = sendText
        view.endEditing(true)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func searchKeywordRemove(sender : UIButton) {
        viewModel.inputSearchKeywordList.value = []
        UserDefaultManager.shared.search = []
    }

}

//MARK: - Extension
extension MainViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.inputSearchKeywordListCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as! MainTableViewCell
        
        // cell 내부의 Button 실행 -> cell remove!
        cell.mainCellButton.tag = indexPath.row
        cell.mainCellButton.addTarget(self, action: #selector(mainCellButtonTapped), for: .touchUpInside)
        
        // 화면전환
        cell.mainCellClickedButton.tag = indexPath.row
        cell.mainCellClickedButton.addTarget(self, action: #selector(mainCellButtonTappedTransition), for: .touchUpInside)
        
        // cell의 label 데이터 나타내기
        cell.setCellDate(labelString: viewModel.cellForRowAt(indexPath))
        
        return cell
    }
    
    // cell button action fuction
    //TODO: - 검색 결과 전달되어야 함 - 완료
    @objc func mainCellButtonTapped(sender : UIButton) {
        print("\(sender.tag) 버튼이 눌러졌고, 삭제")
        viewModel.inputSearchKeywordList.value.remove(at: sender.tag)
        
        // UserDefault Update
        //TODO: - 동일한 값이 들어왔을 떄 중복제거 필요함 - 완료
        UserDefaultManager.shared.search = viewModel.inputSearchKeywordList.value
    }
    
    @objc func mainCellButtonTappedTransition(sender : UIButton) {
        print("\(sender.tag) 버튼이 눌러졌고, 화면전환")
        screenTransition(sendText: viewModel.inputSearchKeywordList.value[sender.tag])
    }
    
}

extension MainViewController : UISearchBarDelegate {
    //TODO: - Whitespace, lowercase, 중복제거 - 완료
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let addText = searchBar.text else { return }
        
        // 기존 검색이 있었는지 판단하고, 과거의 값을 지우고 추가
        if viewModel.inputSearchKeywordList.value.contains(addText){
            viewModel.inputSearchKeywordList.value.remove(at: viewModel.inputSearchKeywordList.value.firstIndex(of: addText)!)
        }
        viewModel.inputSearchKeywordList.value.insert(addText, at: 0) // 새로운 값은 무조건 앞으로
        // UserDefault Update
        UserDefaultManager.shared.search = viewModel.inputSearchKeywordList.value
        
        // 화면 전환 -> 검색 결과 화면(Push)
        screenTransition(sendText: addText)
    }
}
