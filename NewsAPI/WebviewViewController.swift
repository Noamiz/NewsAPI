//
//  WebviewViewController.swift
//  NewsAPI
//
//  Created by Noam Mizrachi on 26/06/2019.
//  Copyright © 2019 Noam Mizrachi. All rights reserved.
//

import UIKit

class WebviewViewController: UIViewController {

    @IBOutlet weak var webview: UIWebView!
    var url: String?  //  The url to the article that is assigned to each web view on our view controller class.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webview.loadRequest(URLRequest(url: URL(string: url!)!))  //  The webView will load our url request.
    }
    
}
