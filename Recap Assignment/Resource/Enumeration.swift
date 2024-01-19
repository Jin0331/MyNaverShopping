//
//  Enumeration.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/18/24.
//

import UIKit

//MARK: -Desgin 관련 enum
enum ImageStyle {
    static let pointColor = UIColor(red: 73, green: 220, blue: 146, alpha: 1)
    static let backgroundColor = UIColor(red: 0, green: 0, blue: 146, alpha: 1)
    static let textColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
    static let headerFontSize = UIFont.systemFont(ofSize: 17)
    static let normalFontSize = UIFont.systemFont(ofSize: 13)
    static let search = UIImage(systemName: "magnifyingglass")
    static let menu = UIImage(systemName: "list.dash")
    static let remove = UIImage(systemName: "multiply")
    static let emptyImage = UIImage(named: "empty")
}

//MARK: - API request sort 관련
enum RequestSort : String {
    case sim
    case date
    case asc
    case dsc
}
