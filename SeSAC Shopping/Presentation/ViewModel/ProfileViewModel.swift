//
//  ProfileViewModel.swift
//  SeSAC Shopping
//
//  Created by JinwooLee on 2/24/24.
//

import Foundation

class ProfileViewModel {
    
    //MARK: - 닉네임 조건 Error 표현
    enum ValidateError : Error {
        case lessOrGreaterString
        case isSpecialCharacter
        case isNumber
        
        var message : String {
            get {
                switch self {
                case .lessOrGreaterString:
                    return "2글자 이상 10글자 미만으로 설정해주세요"
                case .isSpecialCharacter:
                    return "닉네임에 @,#,$,%는 포함할 수 없어요"
                case .isNumber:
                    return "닉네임에 숫자는 포함할 수 없어요"
                }
            }
        }
    }
    
}
