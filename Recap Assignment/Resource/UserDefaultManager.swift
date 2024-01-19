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
        case like
    }
    
    
    var search : [String] {
        get {
            ud.object(forKey: UDkey.search.rawValue) as? [String] ?? []
        }
        set {
            ud.set(newValue, forKey: UDkey.search.rawValue)
        }
    }
    
    var like : [String:Bool] {
        get {
            ud.object(forKey: UDkey.like.rawValue) as? [String:Bool] ?? [:]
        }
        set {
            ud.set(newValue, forKey: UDkey.like.rawValue)
        }
    }
    
    // function
    func userDefaultUpdateForLike(new : [String:Bool]) {
        let currentValue = ud.object(forKey: UDkey.like.rawValue) as? [String:Bool] ?? [:]
        
        // merge를 할 때, 중복될 경우 현재 값을 보존한다.
        let keepingCurrent = currentValue.merging(new) { (current, _) in current }
        
        ud.setValue(keepingCurrent, forKey: UDkey.like.rawValue)
    }
}
