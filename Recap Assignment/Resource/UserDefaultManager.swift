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
    
    enum UDKey : String {
        case source
        case target
    }
    
    let ud = UserDefaults.standard
    
    var source : String {
        get {
            ud.string(forKey: UDKey.source.rawValue) ?? "ko"
        }
        set {
            ud.set(newValue, forKey: UDKey.source.rawValue)
        }
    }
    
    var target : String {
        get {
            ud.string(forKey: UDKey.target.rawValue) ?? "ko"
        }
        set {
            ud.set(newValue, forKey: UDKey.target.rawValue)
        }
    }

}
