//
//  termsOfService.swift
//  Taxi App
//
//  Created by User on 22/09/1938 Saka.
//  Copyright © 1938 Saka User. All rights reserved.
//

import UIKit
class termsOfService: UIViewController , UIWebViewDelegate {
    
    @IBOutlet weak var WebViewtermOfService: UIWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string : "http://www.prestoride.com/driver-terms-and-conditions.html")
        let urlRequest = URLRequest(url: url!)
            WebViewtermOfService.loadRequest(urlRequest)
        }
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        spinner.startAnimating()
    }
  func webViewDidFinishLoad(_ webView: UIWebView)
    {
        spinner.stopAnimating()
    }
}
