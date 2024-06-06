//
//  ProfileViewController.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/21/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileViewController: BaseViewController {
    
    let mainView = ProfileView()
    let viewModel = ProfileViewModel()
    let disposeBag = DisposeBag()

    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationDesign()
        bind()
    }
    
    private func bind() {
            
        //MARK: - Input
        mainView.nicknameTextfield.rx.text.orEmpty
            .bind(to: viewModel.input.inputNickname)
            .disposed(by: disposeBag)
        
        mainView.completeButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                
                owner.viewModel.output.outputStatus
                    .subscribe(with: owner) { owner, value in
                        if value {
                            UserDefaultManager.shared.userState = UserDefaultManager.UserStateCode.old.state
                            owner.viewChangeToMain() // main View로 전환
                        }
                    }.disposed(by: owner.disposeBag)
            })
            .disposed(by: disposeBag)
        
        mainView.profileImageSet.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(ProfileImageViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
        //MARK: - Output
        viewModel.output.outputNicknameValidation
            .asDriver(onErrorJustReturn: "")
            .drive(mainView.statusTextfield.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.outputNicknameValidationColor
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.mainView.statusTextfield.textColor = value ? .green : .red
            })
            .disposed(by: disposeBag)
        
        viewModel.output.outputStatus
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.mainView.completeButton.isEnabled = value
                owner.mainView.completeButton.backgroundColor = value ? ImageStyle.pointColor : .systemGray5
            })
            .disposed(by: disposeBag)
    }
    
    
    
    // 만약, status가 false상태에서 뒤로 돌아갈 경우, 다시 초기화 한다
    override func viewWillDisappear(_ animated: Bool) {
        if !UserDefaultManager.shared.userState {
            UserDefaultManager.shared.profileImage = UserDefaultManager.shared.assetList.randomElement()!
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.profileImage.configureImageSpecific(borderWidth: 4, userDefaultImageName: UserDefaultManager.shared.tempProfileImage)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainView.profileImage.configureCornerRadius()
    }
    
    override func configureView() {
        
        // 처음 화면 설정에서는 랜덤으로 먼저 이미지를 뿌리고, 해당 이미지를 저장한다. 이게 되네 ㅎ 앞에는 get으로 set
        UserDefaultManager.shared.profileImage = UserDefaultManager.shared.profileImage
        UserDefaultManager.shared.tempProfileImage = UserDefaultManager.shared.profileImage
        
        navigationItem.title = UserDefaultManager.shared.userState == UserDefaultManager.UserStateCode.new.state ? "프로필 설정" : "프로필 수정"
        
        hideKeyboardWhenTappedAround()
    }
}
