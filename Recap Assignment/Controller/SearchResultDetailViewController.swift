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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(detailURL)
        configureDesign()
    }

}

extension SearchResultDetailViewController {
    func configureDesign () {
        guard let url = detailURL else {
            print("Error: detailURL is nil")
            return
        }

        let request = URLRequest(url: url)
        print(request)
        searchDetailWebView.load(request)
    }
}
