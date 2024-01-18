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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureProtocol()
        configureTableViewDesign() 
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as! MainTableViewCell
        
        cell.selectionStyle = .none // 선택 삭제
        
        return cell
    }
    
}
