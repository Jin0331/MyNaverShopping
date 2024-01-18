//
//  UserDefaultManager.swift
//  SeSAC4Network
//
//  Created by JinwooLee on 1/18/24.
//

import Foundation

// Singleton Pattern
class UserDefaultManager {
    
    static let shared = UserDefaultManager()
    
    private init(){  } // 초기화 구문에 대한 접근을 막음. 따라서 다른 인스턴스가 생성되지 못함.
       
    let ud = UserDefaults.standard
    
    enum UDkey : String {
        case search
    }
    
    
    var search : [String] {
        get {
            ud.object(forKey: UDkey.search.rawValue) as? [String] ?? []
        }
        set {
            ud.set(newValue, forKey: UDkey.search.rawValue)
        }
    }
    
    //TODO: - 좋아요는 어떻게하지?????? Array<Dictionary>로 하면될듯???
//    var target : String {
//        get {
//            ud.string(forKey: UDKey.target.rawValue) ?? "ko"
//        }
//        set {
//            ud.set(newValue, forKey: UDKey.target.rawValue)
//        }
//    }

}
