//
//  ViewController.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/18/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import UserNotifications

class MainViewController: BaseViewController {
    
    var viewModel : MainViewModel!
    let mainView = MainView()
    let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
        self.viewModel = MainViewModel()
    }
    
    //MARK: - App LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        navigationDesign()
        callNotification(seconds: 600, repeat_: true)

    }
    
    private func bind() {
        
        mainView.mainSearchbar.rx
            .searchButtonClicked
            .withLatestFrom(mainView.mainSearchbar.rx.text.orEmpty)
            .bind(with: self, onNext: { owner, value in
                owner.viewModel.input.inputSearchKeyword.onNext(value)
                owner.screenTransition(sendText: value)
            })
            .disposed(by: disposeBag)
                
        mainView.removeButton.rx
            .tap
            .bind(to: viewModel.input.inputRemoveButtonTap)
            .disposed(by: disposeBag)
        
        
        //MARK: - Output
        viewModel.output.outputSearchKeywordList
            .bind(to: mainView.mainTableView.rx.items(cellIdentifier: MainTableViewCell.identifier, cellType: MainTableViewCell.self)) { (row, element, cell) in

                cell.mainCellButton.rx.tap
                    .bind(with: self) { owner, _ in
                        owner.viewModel.input.inputTableRemoveButtonTap.accept(row)
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.mainCellClickedButton.rx.tap
                    .bind(with: self) { owner, _ in
                        owner.screenTransition(sendText: element)
                    }
                    .disposed(by: cell.disposeBag)
                
                
                cell.setCellDate(labelString: element)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.outputSearchKeywordListIsExist
            .bind(with: self) { owner, value in
                owner.viewToggle(flag: value)
            }
            .disposed(by: disposeBag)
        
    }
    
    
    override func configureView() {
        navigationItem.title = "\(UserDefaultManager.shared.nickname)님의 쇼핑"
        hideKeyboardWhenTappedAround()
    }
    
}

//MARK: - codabse UI
extension MainViewController  {
    //MARK: - function
    
    func viewToggle(flag : Bool) {
        mainView.mainTableView.isHidden = flag
        mainView.mainEmptyImage.isHidden = !flag
        mainView.mainEmptyLabel.isHidden = !flag
        mainView.removeButton.isHidden = flag
        mainView.latestLabel.isHidden = flag

    }
    
    func screenTransition(sendText : String) {
        let vc = SearchResultViewController()
        
        vc.viewModel.inputKeyword.value = sendText
        view.endEditing(true)
        navigationController?.pushViewController(vc, animated: true)
    }

}
