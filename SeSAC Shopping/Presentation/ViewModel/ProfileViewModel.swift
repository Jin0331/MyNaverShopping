//
//  ProfileViewModel.swift
//  SeSAC Shopping
//
//  Created by JinwooLee on 2/24/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileViewModel {
    
    let disposeBag = DisposeBag()
    let input = Input()
    let output = Output()
    
    struct Input {
        let inputNickname = PublishSubject<String>()
    }
    
    struct Output {
        let outputNicknameValidation = PublishRelay<String>()
        let outputNicknameValidationColor = PublishRelay<Bool>()
        let outputStatus = BehaviorRelay<Bool>(value: false)

    }
    
    init() {
        transform()
    }
    
    
    private func transform() {
        
        // textfield validation
        let validation = input.inputNickname
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
        
        validation
            .subscribe(with: self) { owner, value in
                let validationResult = owner.validateNickname(value)
                owner.output.outputNicknameValidation.accept(validationResult.validationText)
                owner.output.outputNicknameValidationColor.accept(validationResult.validationColor)
                owner.output.outputStatus.accept(validationResult.validationStatus)
                
                UserDefaultManager.shared.nickname = value
                UserDefaultManager.shared.profileImage = UserDefaultManager.shared.tempProfileImage
                UserDefaultManager.shared.tempProfileImage = UserDefaultManager.shared.profileImage
            }
            .disposed(by: disposeBag)
    }
    
    private func validateNickname(_ nickname : String) -> (validationColor:Bool, validationStatus:Bool, validationText:String) {
        
        var validationColor : Bool
        var status : Bool
        var validationText : String = ""
        
        do {
            try validateUserInputError(nickname: nickname)
            validationColor = true
            status = true
            validationText = "사용할 수 있는 닉네임이에요"
        } catch {
            
            validationColor = false
            status = false
            switch error {
            case ValidateError.lessOrGreaterString :
                validationText = ValidateError.lessOrGreaterString.message
            case ValidateError.isSpecialCharacter :
                validationText = ValidateError.isSpecialCharacter.message
            case ValidateError.isNumber :
                validationText = ValidateError.isNumber.message
            default :
                print("뭐지")
            }
        }
        
        return (validationColor, status, validationText)
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
