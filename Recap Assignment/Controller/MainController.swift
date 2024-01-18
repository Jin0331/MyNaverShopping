//
//  ViewController.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/18/24.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet var mainSearchbar: UISearchBar!
    @IBOutlet var mainTableView: UITableView!
    @IBOutlet var mainEmptyImage: UIImageView!
    @IBOutlet var mainEmptyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureProtocol()
        configureTableViewDesign()
        configureDesign()
        
//        mainTableView.isHidden = true
        
    }


}


extension MainViewController : UITableViewDelegate, UITableViewDataSource {
    func configureProtocol() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        let xib = UINib(nibName: MainTableViewCell.identifier, bundle: nil)
        mainTableView.register(xib, forCellReuseIdentifier: MainTableViewCell.identifier)
    }
    
    func configureTableViewDesign() {
        mainTableView.separatorStyle = .none
         
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as! MainTableViewCell
        
        cell.selectionStyle = .none // 선택 삭제
        
        
        
        
        return cell
    }
    
}

extension MainViewController {
    func configureDesign() {
        mainSearchbar.searchBarStyle = .minimal
        mainSearchbar.placeholder = "브랜드, 상품, 프로필, 태그 등"
        mainEmptyImage.image = ImageStyle.emptyImage
        mainEmptyImage.contentMode = .scaleAspectFit
        mainEmptyLabel.text = "최근 검색어가 없어요!"
        mainEmptyLabel.textAlignment = .center
        mainEmptyLabel.font = ImageStyle.headerFontSize
        mainEmptyLabel.textColor = ImageStyle.textColor
    }
}
