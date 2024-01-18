//
//  Extension.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/18/24.
//

import UIKit

extension UIViewController : ResuableProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell : ResuableProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}
