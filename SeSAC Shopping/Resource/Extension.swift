//
//  Extension.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/18/24.
//

import UIKit

extension UITableViewCell : ResuableProtocol {
    static var identifier: String {
        return String(describing: self)
    }
    var identifier_: String {
        return String(describing: type(of: self))
    }
}

extension UICollectionViewCell : ResuableProtocol {
    static var identifier: String {
        return String(describing: self)
    }
    var identifier_: String {
        return String(describing: type(of: self))
    }
}
