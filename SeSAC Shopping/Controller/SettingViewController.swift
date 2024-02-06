//
//  SettingViewController.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/20/24.
//

import UIKit

//TODO: - alert 및 초기화 - 완료
//TODO: - 시간되면 cell 위로 과도하게 스크롤 되는거 막기

class SettingViewController: UIViewController {
    
    let backgroundView : UIView = {
        let backgroundView = UIView()
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 10
        backgroundView.backgroundColor = ImageStyle.cellColor
        
        return backgroundView
    }()
    
    let profileImage : ProfileImageView = {
        let profileImage = ProfileImageView(frame: .zero)
        profileImage.configureImageSpecific(borderWidth: 2.5, userDefaultImageName: UserDefaultManager.shared.profileImage)
                
       return profileImage
    }()
    
    let nicknameLabel : UILabel = {
        let nicknameLabel = UILabel()
        nicknameLabel.font = ImageStyle.headerFontSize
        nicknameLabel.textColor = ImageStyle.textColor
        
        return nicknameLabel
    }()
    
    let likeLabel : UILabel = {
        let likeLabel = UILabel()
        likeLabel.font = ImageStyle.normalFontSize
        likeLabel.textColor = ImageStyle.textColor
        
        return likeLabel
    }()
    
    let settingTable : UITableView = {
        let settingTable = UITableView(frame: .zero, style: .insetGrouped)
        settingTable.backgroundColor = .clear
        settingTable.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        
        return settingTable
    }()
    
    let profileSetButton : CommonButton = {
        let profileSetButton = CommonButton()
        profileSetButton.configureEmptyButton()
        
        return profileSetButton
    }()
    
    let settingList = SettingTable.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationDesign()
        configureTableProtocol()
        configureView()
        configureLabel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureView()
        configureLabel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImage.configureCornerRadius()
    }
    
}

extension SettingViewController : ViewSetup {
    func configureView() {
        view.backgroundColor = ImageStyle.backgroundColor
        self.navigationItem.title = "설정"
        
        //TODO: - profilesetting 화면 전환 button - 완료
        profileSetButton.addTarget(self, action: #selector(profileSetting), for: .touchUpInside)
        
        configureHierachy()
        setupConstraints()
    }

    func configureHierachy() {
        [backgroundView, profileImage, nicknameLabel, likeLabel, settingTable, profileSetButton].forEach { item in
            return view.addSubview(item)
        }
    }
    
    func setupConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.top.trailing.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(100)
        }
        profileImage.snp.makeConstraints { make in
            make.height.width.equalTo(60)
            make.centerY.equalTo(backgroundView)
            make.leading.equalTo(backgroundView).inset(16)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(15)
            make.trailing.equalTo(backgroundView.snp.trailing).inset(5)
            make.top.equalTo(profileImage.snp.top).inset(6)
        }
        
        likeLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(nicknameLabel)
            make.top.equalTo(nicknameLabel.snp.bottom).offset(10)
        }
        
        settingTable.snp.makeConstraints { make in
            make.top.equalTo(backgroundView.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(380)
        }
        
        profileSetButton.snp.makeConstraints { make in
            make.height.width.equalTo(60)
            make.centerY.equalTo(backgroundView)
            make.leading.equalTo(backgroundView).inset(16)
        }
    }
    
    @objc func profileSetting(sender: UIButton) {
        // 화면 전환
        navigationController?.pushViewController(ProfileViewController(), animated: true)
    }
    
}




//MARK: - Table View 관련
extension SettingViewController : UITableViewDelegate, UITableViewDataSource {
    
    func configureTableProtocol() {
        
        settingTable.delegate = self
        settingTable.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = settingTable.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as! SettingTableViewCell
        
        cell.backgroundColor = ImageStyle.cellColor
        cell.selectionStyle = .none
        
        cell.configureCell(item: settingList[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function, "\(indexPath.row)- 셀 선택")
        
        
        //TODO: - Alert --> 클로저로 변경 -> 이미 변경되어 있음 ;
        if indexPath.row == SettingTable.reset.index {
            let alert = UIAlertController(title: "처음부터 시작하기", message: "데이터를 모두 초기화하시겠습니까?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default) { action in
                for key in UserDefaults.standard.dictionaryRepresentation().keys {
                    UserDefaults.standard.removeObject(forKey: key.description)
                }
                self.viewChangeToOnboarding()
            })
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

//MARK: - normal function
extension SettingViewController {    
    func configureLabel() {
        
        //TODO: - 닉네임 설정되면 바꿔야됨 - 완료
        nicknameLabel.text = UserDefaultManager.shared.nickname
        
        // 좋아요 개수 측정
        //TODO: - 특정문자 색 변경
        let likeDictionary = UserDefaultManager.shared.like
        let likeCount = likeDictionary.values.filter{$0 == true}.count
        let searchText = "\(likeCount)개의 상품을 좋아하고 있어요!"
        
        // 특정문자 색 변경
        let attrStr = NSMutableAttributedString(string: searchText)
        let range = (searchText as NSString).range(of: "[0-9]+개의 상품", options: .regularExpression)
        attrStr.addAttribute(.foregroundColor, value: ImageStyle.pointColor, range: range)
        
        likeLabel.attributedText = attrStr
    }
}
