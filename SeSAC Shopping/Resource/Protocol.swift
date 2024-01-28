//
//  Protocol.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/18/24.
//

import Foundation

protocol ResuableProtocol {
    static var identifier : String { get }
    var identifier_ : String{ get }
}

protocol ViewSetup {
    func configureHierachy()
    func setupConstraints()
    func configureView()
}
