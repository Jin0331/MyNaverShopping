//
//  Enumeration.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/18/24.
//

import UIKit

//MARK: -Desgin 관련 enum
enum ImageStyle {
    static let pointColor = UIColor.pointcolor
    static let cellColor = UIColor.cellcolor
    static let backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    static let textColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
    
    static let titleFontSize = UIFont.boldSystemFont(ofSize: 40)

    static let headerFontSize = UIFont.boldSystemFont(ofSize: 17)
    static let normalFontSize = UIFont.boldSystemFont(ofSize: 15)
    static let search = UIImage(systemName: "magnifyingglass")
    static let menu = UIImage(systemName: "list.dash")
    static let remove = UIImage(systemName: "multiply")
    static let emptyImage = UIImage(named: "empty")
    

}

//MARK: - Setting Table 관련
enum SettingTable : String, CaseIterable {
    case noti = "공지사항"
    case question = "자주 묻는 질문"
    case dm = "1:1 문의"
    case notiSetting = "알림설정"
    case reset = "처음부터 시작하기"
    
    var index : Int {
        switch self {
        case .noti :
            return 0
        case .question :
            return 1
        case .dm :
            return 2
        case .notiSetting :
            return 3
        case .reset :
            return 4
        }
    }
    
    var caseValue : String {
        switch self {
        default:
            return String(describing: self)
        }
    }
}
