//
//  SearchResultDetailViewController.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/20/24.
//

import UIKit
import WebKit

class SearchResultDetailViewController: UIViewController {
    
    @IBOutlet var searchDetailWebView: WKWebView!
    
    //    var detailURL : URL?
    //    var productTitle : String?
    var item : NaverShoppingItem?
    var defaultUrl : String = "https://msearch.shopping.naver.com/product/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDesign()
        
    }
    
}

extension SearchResultDetailViewController {
    func configureDesign () {
        
        self.view.backgroundColor = ImageStyle.backgroundColor
        
        guard let i = item else { return }
        guard let url = URL(string: "\(defaultUrl)\(i.productId)") else { return }
        
        //webView
        let request = URLRequest(url: url)
        searchDetailWebView.backgroundColor = .clear
        searchDetailWebView.load(request)
        
        // title & html 태그 제거
        self.navigationItem.title = i.title.replacingOccurrences(of: "<[^>]+>|&quot;",
                                                            with: "",
                                                            options: .regularExpression,
                                                            range: nil)
        
        // navgiation button
        let buttonImage = UserDefaultManager.shared.like[i.productId] ?? false ? "heart.fill" : "heart"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: buttonImage), style: .plain, target: self, action: #selector(searchResultDetailButtonTapped))
        
        self.navigationItem.rightBarButtonItem?.tintColor = ImageStyle.textColor
    }
    
    @objc func searchResultDetailButtonTapped(sender : UIBarButtonItem) {
        guard let i = item else { return }
        
        print(#function)
        UserDefaultManager.shared.userDefaultButtonUpdate(productID: i.productId)
        
        // navgiation button
        let buttonImage = UserDefaultManager.shared.like[i.productId] ?? false ? "heart.fill" : "heart"
        sender.image = UIImage(systemName: buttonImage)
    }
}
