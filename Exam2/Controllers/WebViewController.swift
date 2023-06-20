//
//  WebViewController.swift
//  Exam2
//
//  Created by Shubhamsinh Rahevar on 02/03/23.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "< Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(WebViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        
        
        webView.navigationDelegate = self
        webView = WKWebView()
        self.view = webView
        
        let url = URL(string: "https://www.pacificglobalsolutions.com/about-us.html")
        let request = URLRequest(url: url!)
        webView.load(request)
        
    }
    
    @objc func back(sender: UIBarButtonItem) {
        if webView.canGoBack == true {
            webView.goBack()
        }
        else{
            
            navigationController?.popToRootViewController(animated: true)
        }
    }
}
