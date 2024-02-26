//
//  SearchResultViewModel.swift
//  SeSAC Shopping
//
//  Created by JinwooLee on 2/26/24.
//

import Foundation

class SearchResultViewModel {
    
    var inputKeyword : Observable<String> = Observable("") // 이전 화면에서 값전달 되는 값
    var searchResult : Observable<NaverShoppingModel> = Observable(NaverShoppingModel(lastBuildDate: "", total: 0, start: 0, display: 0, items: []))
    
    var inputViewDidLoadCallRequestTriger : Observable<Void?> = Observable(nil)
    var inputbuttonSearchSpecificCallRequestTriger : Observable<NaverAPI.RequestSort?> = Observable(nil)
    
    var start : Observable<Int> = Observable(1)
    var display : Observable<Int> = Observable(30)
    
    
    init() {
        transform()
    }
    
    func transform() {
        
        inputViewDidLoadCallRequestTriger.bind { _ in
            self.callRequest()
        }
        
        inputbuttonSearchSpecificCallRequestTriger.bind { value in
            
            if let value  {
                self.callRequest(sortType: value)
            }
            
        }
    }
    
    
    
    private func callRequest() {
        DispatchQueue.global().async {
            NaverShoppingAPIManager.shared.callRequestURLSession(api: .shop(query: self.inputKeyword.value, display: String(self.display.value), sort: NaverAPI.RequestSort.sim.caseValue, start: String(self.start.value))) { (item : NaverShoppingModel?, start : Int?, error:NaverAPI.APIError?) in
                
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
    
    private func callRequest(sortType : NaverAPI.RequestSort) {
        DispatchQueue.global().async {
            NaverShoppingAPIManager.shared.callRequestURLSession(api: .shop(query: self.inputKeyword.value, display: String(self.display.value), sort: sortType.caseValue, start: String(self.start.value))) { (item : NaverShoppingModel?, start : Int?, error:NaverAPI.APIError?) in
                
                if error == nil {
                    guard let item = item else { return }
                    guard let start = start else { return }
                    print(#function, start)
                    
                    self.searchResultUpdate(value: item, start: start)
                    self.start.value = 1
                } else {
                    dump(error)
                }
            }
        }
        
    }
    
    private func searchResultUpdate(value: NaverShoppingModel, start : Int){
        if self.start.value == 1 {
            self.searchResult.value = value
        } else {
            self.searchResult.value.items.append(contentsOf: value.items)
        }
        
//        // 상단으로 올리기
//        if self.start.value == 1 {
//            self.mainView.searchResultCollectionView.setContentOffset(.zero, animated: false)
//        }
        
        //TODO: - 기존 값에 새로운 값이 추가되었을 때 비교하여 저장하는 함수 필요 - 구현완료
        UserDefaultManager.shared.userDefaultUpdateForLike(new: searchResult.value.productIdwithLike)
        print(#function)
    }
}
