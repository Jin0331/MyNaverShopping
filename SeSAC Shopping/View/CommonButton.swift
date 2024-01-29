//
//  CommonButton.swift
//  SeSAC Shopping
//
//  Created by JinwooLee on 1/29/24.
//

import UIKit

class CommonButton : UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureOnboardingButton() {
        setTitle("시작하기", for: .normal)
        setTitleColor(ImageStyle.textColor, for: .normal)
        titleLabel?.font = ImageStyle.headerFontSize
        backgroundColor = ImageStyle.pointColor
        clipsToBounds = true
        layer.cornerRadius = 10
    }
    
    func configureCompleteButton() {
        setTitle("완료", for: .normal)
        setTitleColor(ImageStyle.textColor, for: .normal)
        titleLabel?.font = ImageStyle.headerFontSize
        backgroundColor = ImageStyle.pointColor
        clipsToBounds = true
        layer.cornerRadius = 11
    }
    
    func configureProfileSetButton() {
        setTitle("", for: .normal)
        setImage(UIImage(named: "camera"), for: .normal)
        backgroundColor = .clear
        clipsToBounds = true
        layer.cornerRadius = layer.frame.width / 2
    }
    
    func configureEmptyButton() {
        backgroundColor = .clear
        setTitle("", for: .normal)
    }
    
}

