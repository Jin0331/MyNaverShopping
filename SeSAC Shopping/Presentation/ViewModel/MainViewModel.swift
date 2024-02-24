//
//  MainViewModel.swift
//  SeSAC Shopping
//
//  Created by JinwooLee on 2/24/24.
//

import Foundation

class MainViewModel {
    
    var inputSearchKeywordList = Observable(UserDefaultManager.shared.search)
    
    var inputSearchKeywordListCount : Int {
        return inputSearchKeywordList.value.count
    }
    
    var inputSearchKeywordListBool : Bool {
        return inputSearchKeywordListCount == 0 ? true : false
    }
    
    
    func cellForRowAt(_ indexPath : IndexPath) -> String {
        return self.inputSearchKeywordList.value[indexPath.row]
    }
}
