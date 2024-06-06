//
//  MainViewModel.swift
//  SeSAC Shopping
//
//  Created by JinwooLee on 2/24/24.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel {
    
    let disposeBag = DisposeBag()
    let input = Input()
    let output = Output()
    
    struct Input {
        let inputSearchKeywordList = BehaviorSubject(value: UserDefaultManager.shared.search)
        let inputSearchKeyword = PublishSubject<String>()
        let inputSearchTransition = PublishSubject<Void>()
        let inputRemoveButtonTap = PublishSubject<Void>()
        let inputTableRemoveButtonTap = PublishRelay<Int>()
    }
    
    struct Output {
        let outputSearchKeywordList = BehaviorRelay<[String]>(value: [])
        let outputSearchKeywordListIsExist = BehaviorRelay(value: true)

    }
    
    init() {
        transform()
    }
    
    
    private func transform() {
        
        input.inputSearchKeywordList
            .bind(with: self) { owner, value in
                
                print(value)
                if value.isEmpty {
                    owner.output.outputSearchKeywordListIsExist.accept(true)
                } else {
                    owner.output.outputSearchKeywordListIsExist.accept(false)
                }
                
                owner.output.outputSearchKeywordList.accept(value)
                

            }
            .disposed(by: disposeBag)
        
        input.inputSearchKeyword
            .bind(with: self) { owner, value in
                // 기존 검색이 있었는지 판단하고, 과거의 값을 지우고 추가
                
                var editList = UserDefaultManager.shared.search
                
                if editList.contains(value){
                    editList.remove(at: editList.firstIndex(of: value)!)
                }
                editList.insert(value, at: 0) // 새로운 값은 무조건 앞으로
                
                // UserDefault Update
                UserDefaultManager.shared.search = editList
                owner.input.inputSearchKeywordList.onNext(UserDefaultManager.shared.search)
            }
            .disposed(by: disposeBag)
        
        input.inputRemoveButtonTap
            .bind(with: self) { owner, _ in
                UserDefaultManager.shared.search = []
                owner.input.inputSearchKeywordList.onNext(UserDefaultManager.shared.search)
            }
            .disposed(by: disposeBag)
        
        input.inputTableRemoveButtonTap
            .bind(with: self) { owner, value in
                var editList = UserDefaultManager.shared.search
                editList.remove(at: value)
                owner.input.inputSearchKeywordList.onNext(editList)
            }
            .disposed(by: disposeBag)
        
    }
    
    
    
}
