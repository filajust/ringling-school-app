//
//  HomeViewController.swift
//  Ringling School App
//
//  Created by JJ Fila on 3/20/18.
//  Copyright © 2018 Ringling IT. All rights reserved.
//

import UIKit

class HomeViewController: BaseTabBarViewController {
    
    @IBOutlet weak var appNavigationScrollView: UIScrollView!
    
    var appNavigationViewButtons = [NavigationViewButton]()
    
    override func viewDidLayoutSubviews() {
        let mainNavigationView = loadNavigationViews()
        
        appNavigationScrollView.addSubview(mainNavigationView)
        appNavigationScrollView.contentSize = mainNavigationView.frame.size
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        super.viewWillDisappear(animated)
    }
    
    @objc func navButtonClicked(_ sender:UITapGestureRecognizer){
        performSegue(withIdentifier: "showWebView", sender: sender.view)
    }
    
    private func loadNavigationViews() -> UIView {
        let mainNavigationView = UIView()
        
        var xPosition : CGFloat = 0.0
        let xPadding : CGFloat = 30.0
        for navigationViewInfo in RinglingAppConstants.Navigation.Info {
            if let navViewImage = UIImage(named: navigationViewInfo.imageName) {
                let navViewImageView = UIImageView(image: navViewImage)
                let navViewFrame = CGRect(x: xPosition + xPadding, y: 0.0, width: self.view.frame.size.width * 0.8, height: appNavigationScrollView.frame.size.height)
                let navView = NavigationViewButton(frame: navViewFrame, imageView: navViewImageView, text: navigationViewInfo.text, navigationUrl: URL(string:navigationViewInfo.urlString)!)
                
                let tapGesture = UITapGestureRecognizer(target: self, action:  #selector (self.navButtonClicked (_:)))
                navView.addGestureRecognizer(tapGesture)
                
                appNavigationViewButtons.append(navView)
                mainNavigationView.addSubview(navView)
                
                xPosition = navViewFrame.origin.x + navViewFrame.size.width
            }
        }
        
        mainNavigationView.frame = CGRect(x: 0, y: 0, width: xPosition, height: appNavigationScrollView.frame.size.height)
        return mainNavigationView
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var url = RinglingAppConstants.Navigation.DefaultUrl
        if let button = sender as? NavigationViewButton {
            url = button.navigationUrl
        }
        
        // Create a new variable to store the instance of PlayerTableViewController
        let destinationViewController = segue.destination as! WebViewController
        destinationViewController.url = url
    }
}
