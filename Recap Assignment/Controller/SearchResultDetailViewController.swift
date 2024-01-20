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
    
    var detailURL : URL?
    var productTitle : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDesign()
    }

}

extension SearchResultDetailViewController {
    func configureDesign () {
        
        
        guard let url = detailURL else { return }
        guard let pdTitle = productTitle else { return }
        
        //webView
        let request = URLRequest(url: url)
        searchDetailWebView.load(request)
        
        // title & html 태그 제거
        navigationItem.title = pdTitle.replacingOccurrences(of: "<[^>]+>|&quot;", 
                                                            with: "",
                                                            options: .regularExpression,
                                                            range: nil)
    }
}
