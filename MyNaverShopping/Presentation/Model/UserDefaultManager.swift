//
//  UserDefaultManager.swift
//  SeSAC4Network
//
//  Created by JinwooLee on 1/18/24.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

class UserDefaultManager {
    static let shared = UserDefaultManager()
    
    private init() { }
    
    let assetList = (1...14).map { "profile\($0)" }
    
    enum UDKey: String {
        case userState
        case profileImage
        case tempProfileImage
        case nickname
        case search
        case like
    }
    
    enum UserStateCode {
        case new
        case old
        
        var state: Bool {
            switch self {
            case .new:
                return false
            case .old:
                return true
            }
        }
    }
    
    @UserDefault(key: UDKey.userState.rawValue, defaultValue: UserStateCode.old.state)
    var userState: Bool
    
    @UserDefault(key: UDKey.profileImage.rawValue, defaultValue: "")
    var profileImage: String
    
    @UserDefault(key: UDKey.tempProfileImage.rawValue, defaultValue: "")
    var tempProfileImage: String
    
    @UserDefault(key: UDKey.nickname.rawValue, defaultValue: "")
    var nickname: String
    
    @UserDefault(key: UDKey.search.rawValue, defaultValue: [])
    var search: [String]
    
    @UserDefault(key: UDKey.like.rawValue, defaultValue: [:])
    var like: [String: Bool]
    
    func userDefaultUpdateForLike(new: [String: Bool]) {
        let currentValue = like
        let keepingCurrent = currentValue.merging(new) { current, _ in current }
        like = keepingCurrent
    }
    
    func userDefaultButtonUpdate(productID: String) {
        var currentValue = like
        currentValue[productID]?.toggle()
        like = currentValue
    }
}
