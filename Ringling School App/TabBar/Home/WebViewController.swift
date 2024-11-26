//
//  WebViewController.swift
//  Ringling School App
//
//  Created by JJ Fila on 4/13/18.
//  Copyright © 2018 Ringling IT. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    var url : URL?
    @IBOutlet weak var loadingSpinner: LoadingSpinnerAnimationView!
    @IBOutlet weak var grayedOutView: UIView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setupProperties()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupProperties()
    }
    
    func setupProperties() {
        url = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        
        if let unwrappedUrl = url {
            let urlRequest = URLRequest(url: unwrappedUrl)
            webView.load(urlRequest)
        }
        
        loadingSpinner.startLoadingAnimation()
    }
    
    // UIWebViewDelegate
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if (loadingSpinner != nil) {
            loadingSpinner.stopLoadingAnimation(completion: {
                self.loadingSpinner.removeFromSuperview()
                self.loadingSpinner = nil
            })
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.grayedOutView.backgroundColor = UIColor.clear
        }, completion: { (finished) in
            self.grayedOutView.removeFromSuperview()
        })
    }
}
