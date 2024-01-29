//
//  CommonTextField.swift
//  SeSAC Shopping
//
//  Created by JinwooLee on 1/29/24.
//

import UIKit
import TextFieldEffects

class CommonTextField : YoshikoTextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func profileTextField() {
        placeholder = "닉네임을 입력해주세요 :)"
        placeholderFontScale = 1
        placeholderColor = .systemGray2
        borderSize = 1.5
        textAlignment = .center
        backgroundColor = .clear
        textColor = ImageStyle.textColor
    }
}
