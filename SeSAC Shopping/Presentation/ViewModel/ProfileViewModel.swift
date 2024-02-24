//
//  ProfileViewModel.swift
//  SeSAC Shopping
//
//  Created by JinwooLee on 2/24/24.
//

import Foundation

class ProfileViewModel {
    
    let inputNickname = Observable("")
    let outputNicknameValidation = Observable("")
    let outputNicknameValidationColor = Observable(false)
    let outputStatus = Observable(false)
    
    init() {
        
        inputNickname.bind { [weak self] value in
            self?.validateNickname(value)
        }
        
        outputStatus.bind { [self] _ in
            UserDefaultManager.shared.nickname = self.inputNickname.value
            UserDefaultManager.shared.profileImage = UserDefaultManager.shared.tempProfileImage
            UserDefaultManager.shared.tempProfileImage = UserDefaultManager.shared.profileImage
            UserDefaultManager.shared.userState = UserDefaultManager.UserStateCode.old.state
        }
    }
    
    
    private func validateNickname(_ nickname : String) {
        do {
            try validateUserInputError(nickname: nickname)
            outputNicknameValidationColor.value = true
            outputStatus.value = true
            outputNicknameValidation.value = "사용할 수 있는 닉네임이에요"
        } catch {
            
            outputNicknameValidationColor.value = false
            outputStatus.value = false
            
            switch error {
            case ValidateError.lessOrGreaterString :
                outputNicknameValidation.value = ValidateError.lessOrGreaterString.message
            case ValidateError.isSpecialCharacter :
                outputNicknameValidation.value = ValidateError.isSpecialCharacter.message
            case ValidateError.isNumber :
                outputNicknameValidation.value = ValidateError.isNumber.message
            default :
                print("뭐지")
            
            }
        }
    }
    
   
    
    private func validateUserInputError(nickname : String) throws {
        let specialCharacters = "@#$%"
        let numbers = "0123456789"
        
        switch nickname {
        case _ where nickname.count < 2 || nickname.count >= 10:
            throw ValidateError.lessOrGreaterString
        case _ where nickname.contains(where: { specialCharacters.contains($0) }):
            throw ValidateError.isSpecialCharacter
        case _ where nickname.contains(where: { numbers.contains($0) }):
            throw ValidateError.isNumber
        default:
            print("")
        }
    }
    
}

//MARK: - 해당 뷰의 Error 관리 enum
extension ProfileViewModel {
    //MARK: - 닉네임 조건 Error 표현
    private enum ValidateError : Error {
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
