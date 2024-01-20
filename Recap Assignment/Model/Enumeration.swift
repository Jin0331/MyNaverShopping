//
//  Enumeration.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/18/24.
//

import UIKit

//MARK: -Desgin 관련 enum
enum ImageStyle {
    static let pointColor = UIColor.green
    static let backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    static let textColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
    static let headerFontSize = UIFont.systemFont(ofSize: 17)
    static let normalFontSize = UIFont.systemFont(ofSize: 13)
    static let search = UIImage(systemName: "magnifyingglass")
    static let menu = UIImage(systemName: "list.dash")
    static let remove = UIImage(systemName: "multiply")
    static let emptyImage = UIImage(named: "empty")

}

//MARK: - API request sort 관련
enum RequestSort : String, CaseIterable {
    case sim = "정확도"
    case date = "날짜순"
    case dsc = "가격높은순"
    case asc = "가격낮은순"
    
    var index : Int {
        switch self {
        case .sim :
            return 0
        case .date :
            return 1
        case .asc :
            return 2
        case .dsc :
            return 3
        }
    }
    
    var caseValue : String {
        switch self {
        default:
            return String(describing: self)
        }
    }
}
