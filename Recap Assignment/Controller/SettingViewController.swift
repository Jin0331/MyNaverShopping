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
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var likeLabel: UILabel!
    @IBOutlet var settingTable: UITableView!
    @IBOutlet var profileSetButton: UIButton!
    
    let settingList = SettingTable.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDesign()
        configureLabel()
        configureTableProtocol()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureLabel()
    }
    
    @IBAction func profileImageChange(_ sender: UIButton) {
    }
    
    @IBAction func profileSetting(_ sender: UIButton) {
        // 화면 전환
        let sb = UIStoryboard(name: ProfileViewController.identifier, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: ProfileViewController.identifier)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - Table View 관련
extension SettingViewController : UITableViewDelegate, UITableViewDataSource {
    
    func configureTableProtocol() {
        
        print(SettingTableViewCell.identifier)
        
        let xib = UINib(nibName: SettingTableViewCell.identifier, bundle: nil)
        settingTable.register(xib, forCellReuseIdentifier: SettingTableViewCell.identifier)
        
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
        
        cell.configureDesign(item: settingList[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function, "\(indexPath.row)- 셀 선택")
        
        if indexPath.row == SettingTable.reset.index {
            let alert = UIAlertController(title: "처음부터 시작하기", message: "데이터를 모두 초기화하시겠습니까?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default) { action in
                for key in UserDefaults.standard.dictionaryRepresentation().keys {
                    UserDefaults.standard.removeObject(forKey: key.description)
                }
                
                //TODO: - 해당부분은 재사용 되는데, 간소화방법이 있을까
                // seceneDelegate window vc rootview
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                
                let sb = UIStoryboard(name: OnboardingViewController.identifier, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: OnboardingViewController.identifier) as! OnboardingViewController
                let nav = UINavigationController(rootViewController: vc)
                
                sceneDelegate?.window?.rootViewController = nav
                sceneDelegate?.window?.makeKeyAndVisible()
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
        let likeDictionary = UserDefaultManager.shared.like
        let likeCount = likeDictionary.values.filter{$0 == true}.count
        likeLabel.text = "\(likeCount)개의 상품을 좋아하고 있어요!"
    }
}
