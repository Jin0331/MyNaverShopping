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
    
    func navigationDesign() {
        view.backgroundColor = ImageStyle.backgroundColor
        self.view.backgroundColor = ImageStyle.backgroundColor
        self.navigationController?.navigationBar.barTintColor = ImageStyle.backgroundColor
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ImageStyle.textColor]
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil) // title 부분 수정
        backBarButtonItem.tintColor = ImageStyle.textColor
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
}

extension UITableViewCell : ResuableProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell : ResuableProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}


// 참고 -> https://kkh0977.tistory.com/1366
extension String {
    // [정규식 수행 실시 : 사용 방법 : let changeData = strData.matchString(_string: strData)]
    func matchString (_string : String) -> String { // 문자열 변경 실시
        let strArr = Array(_string) // 문자열 한글자씩 확인을 위해 배열에 담는다
        
        let pattern = "^[ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9]$" // 정규식 : 한글, 영어, 숫자만 허용 (공백, 특수문자 제거)
        //let pattern = "^[ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9\\s]$" // 정규식 : 한글, 영어, 숫자, 공백만 허용 (특수문자 제거)
        
        // 문자열 길이가 한개 이상인 경우만 패턴 검사 수행
        var resultString = ""
        if strArr.count > 0 {
            if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
                var index = 0
                while index < strArr.count { // string 문자 하나 마다 개별 정규식 체크
                    let checkString = regex.matches(in: String(strArr[index]), options: [], range: NSRange(location: 0, length: 1))
                    if checkString.count == 0 {
                        index += 1 // 정규식 패턴 외의 문자가 포함된 경우
                    }
                    else { // 정규식 포함 패턴의 문자
                        resultString += String(strArr[index]) // 리턴 문자열에 추가
                        index += 1
                    }
                }
            }
            return resultString
        }
        else {
            return _string // 원본 문자 다시 리턴
        }
    }
}

//MARK: - main View design
extension MainViewController {
    func configureDesign() {
        navigationItem.title = "\(UserDefaultManager.shared.nickname)님의 새싹쇼핑"
        mainTableView.backgroundColor = .clear
        mainSearchbar.searchBarStyle = .minimal
        mainSearchbar.barStyle = .black
        mainSearchbar.tintColor = ImageStyle.textColor
        mainSearchbar.placeholder = "브랜드, 상품, 프로필, 태그 등"
        
        mainEmptyImage.image = ImageStyle.emptyImage
        mainEmptyImage.contentMode = .scaleAspectFit
        
        mainEmptyLabel.text = "최근 검색어가 없어요!"
        mainEmptyLabel.textAlignment = .center
        mainEmptyLabel.font = ImageStyle.headerFontSize
        mainEmptyLabel.textColor = ImageStyle.textColor
        
        latestLabel.text = "최근 검색"
        latestLabel.textColor = ImageStyle.textColor
        latestLabel.font = ImageStyle.normalFontSize
        
        removeButton.setTitle("모두 지우기", for: .normal)
        removeButton.setTitleColor(ImageStyle.pointColor, for: .normal)
        removeButton.titleLabel?.font = ImageStyle.normalFontSize
        removeButton.titleLabel?.textAlignment = .right
    }
    
    func setEmptyUI() {
        mainTableView.isHidden = searchKeywordList.count == 0 ? true : false
        mainEmptyImage.isHidden = searchKeywordList.count == 0 ? false : true
        mainEmptyLabel.isHidden = searchKeywordList.count == 0 ? false : true
    }
    
    // 화면 전환
    //TODO: - 데이터 전달 - 완료
    func screenTransition(sendText : String) {
        let sb = UIStoryboard(name: SearchResultController.identifier, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: SearchResultController.identifier) as! SearchResultController
        
        vc.searchKeyword = sendText
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - search Result design
extension SearchResultController {
    //TODO: - 숫자 콤마 적용해야됨 - 완료
    func configureDesgin() {
        // navgiation
        self.navigationItem.title = "\(searchKeyword)"
        searchResultCollectionView.backgroundColor = .clear
        searchResultTotalCount.text = "\(searchResult.totalChange) 개의 검색 결과"
        searchResultTotalCount.textColor = ImageStyle.pointColor
        searchResultTotalCount.font = ImageStyle.headerFontSize
        
        //TODO: - Enum으로 case 정해야할 듯. 만약 안되면, button 별로 IBOutlet 연결해서 따로 진행해야 함 - 완료
        //TODO: - button의 name에 실행될 기능 추가 - 완료
        let requestSort = NaverShoppingAPIManager.RequestSort.allCases
        for value in requestSort {
            searchResultButtonCollection[value.index].setTitle(value.rawValue, for: .normal)
            searchResultButtonCollection[value.index].layer.name = value.caseValue
            searchResultButtonCollection[value.index].setTitleColor(ImageStyle.textColor, for: .normal)
            searchResultButtonCollection[value.index].titleLabel?.font = ImageStyle.normalFontSize
            searchResultButtonCollection[value.index].layer.borderWidth = 1
            searchResultButtonCollection[value.index].layer.borderColor = ImageStyle.textColor.cgColor
            searchResultButtonCollection[value.index].clipsToBounds = true
            searchResultButtonCollection[value.index].layer.cornerRadius = 10
        }
    }
    
    func configureCellLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        let rowCount : Double = 2
        let sectionSpacing : CGFloat = 5
        let itemSpacing : CGFloat = 8
        let width : CGFloat = UIScreen.main.bounds.width - (itemSpacing * (rowCount - 1)) - (sectionSpacing * 2)
        let itemWidth: CGFloat = width / rowCount
        
        // 각 item의 크기 설정 (아래 코드는 정사각형을 그린다는 가정)
        layout.itemSize = CGSize(width: itemWidth - 5 , height: itemWidth + 80)
        // 스크롤 방향 설정
        layout.scrollDirection = .vertical
        // Section간 간격 설정
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        // item간 간격 설정
        layout.minimumLineSpacing = itemSpacing        // 최소 줄간 간격 (수직 간격)
        layout.minimumInteritemSpacing = itemSpacing   // 최소 행간 간격 (수평 간격)
        
        return layout
    }
}

//MARK: - Setting View design
extension SettingViewController {
    func configureDesign() {
        //navigation
        self.navigationItem.title = "설정"
        settingTable.backgroundColor = .clear
        
        // top item
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 10
        backgroundView.backgroundColor = ImageStyle.cellColor
        
        profileImage.image = UIImage(named: UserDefaultManager.shared.profileImage)
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = profileImage.layer.frame.width / 2
        profileImage.layer.borderWidth = 2.5
        profileImage.layer.borderColor = ImageStyle.pointColor.cgColor
        
        nicknameLabel.font = ImageStyle.headerFontSize
        nicknameLabel.textColor = ImageStyle.textColor
        
        likeLabel.font = ImageStyle.normalFontSize
        likeLabel.textColor = ImageStyle.textColor
        
        // button
        profileSetButton.backgroundColor = .clear
        profileSetButton.setTitle("", for: .normal)
    }
}

//MARK: - Onboarding view desing
extension OnboardingViewController {
    func configureViewDesign(){
        //image
        titleImage.image = #imageLiteral(resourceName: "sesacShopping")
        titleImage.contentMode = .scaleAspectFit
        
        mainImage.image = #imageLiteral(resourceName: "onboarding")
        mainImage.contentMode = .scaleAspectFill
        
        //button
        startButton.setTitle("시작하기", for: .normal)
        startButton.setTitleColor(ImageStyle.textColor, for: .normal)
        startButton.titleLabel?.font = ImageStyle.headerFontSize
        startButton.backgroundColor = ImageStyle.pointColor
        startButton.clipsToBounds = true
        startButton.layer.cornerRadius = 10
    }
}

//MARK: - ProfileViewController
extension ProfileViewController {
    func configureViewDesign() {
        //navigation
        if UserDefaultManager.shared.userState == UserDefaultManager.UserStateCode.new.state {
            navigationItem.title = "프로필 설정"
        } else {
            navigationItem.title = "프로필 수정"
        }
        //image
        profileImage.contentMode = .scaleAspectFill
        profileImage.image = UIImage(named: UserDefaultManager.shared.tempProfileImage)
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = profileImage.layer.frame.width / 2
        profileImage.layer.borderWidth = 4
        profileImage.layer.borderColor = ImageStyle.pointColor.cgColor
        
        // textfield
        nicknameTextfield.placeholder = "닉네임을 입력해주세요 :)"
        nicknameTextfield.textAlignment = .center
        nicknameTextfield.backgroundColor = .clear
        nicknameTextfield.textColor = ImageStyle.textColor
        
        // status label
        statusTextfield.backgroundColor = .clear
        statusTextfield.font = ImageStyle.normalFontSize
        
        // button - 완료
        completeButton.setTitle("완료", for: .normal)
        completeButton.setTitleColor(ImageStyle.textColor, for: .normal)
        completeButton.titleLabel?.font = ImageStyle.headerFontSize
        completeButton.backgroundColor = ImageStyle.pointColor
        completeButton.clipsToBounds = true
        completeButton.layer.cornerRadius = 11
        
        // button - 이미지 수정
        profileImageSet.setImage(UIImage(named: "camera"), for: .normal)
        profileImageSet.setTitle("", for: .normal)
        profileImageSet.backgroundColor = .clear
        profileImageSet.clipsToBounds = true
        profileImageSet.layer.cornerRadius = profileImageSet.layer.frame.width / 2
        
    }
}

//MARK: - ProfileImageViewController
extension ProfileImageViewController {
    func configureCollectionViewDeisgn() {
        //navigation
        if UserDefaultManager.shared.userState == UserDefaultManager.UserStateCode.new.state {
            navigationItem.title = "프로필 설정"
        } else {
            navigationItem.title = "프로필 수정"
        }

        
        // collectionView
        profileCollectionView.backgroundColor = ImageStyle.backgroundColor
        
        // main profile Image
        profileImge.image = UIImage(named: UserDefaultManager.shared.profileImage)
        profileImge.layer.cornerRadius = profileImge.layer.frame.width / 2
        profileImge.layer.borderColor = ImageStyle.pointColor.cgColor
        profileImge.layer.borderWidth = 2.5
    
    }
    
    func configureCellLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        let rowCount : Double = 4
        let sectionSpacing : CGFloat = 10
        let itemSpacing : CGFloat = 15
        let width : CGFloat = UIScreen.main.bounds.width - (itemSpacing * (rowCount - 1)) - (sectionSpacing * 2)
        let itemWidth: CGFloat = width / rowCount
        
        // 각 item의 크기 설정 (아래 코드는 정사각형을 그린다는 가정)
        layout.itemSize = CGSize(width: itemWidth , height: itemWidth)
        // 스크롤 방향 설정
        layout.scrollDirection = .vertical
        // Section간 간격 설정
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        // item간 간격 설정
        layout.minimumLineSpacing = itemSpacing        // 최소 줄간 간격 (수직 간격)
        layout.minimumInteritemSpacing = itemSpacing   // 최소 행간 간격 (수평 간격)
        
        return layout
    }
}

