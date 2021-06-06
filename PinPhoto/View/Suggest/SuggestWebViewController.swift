//
//  SuggestWebViewController.swift
//  PinPhoto
//
//  Created by won heo on 2020/12/24.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit
import WebKit

final class SuggestWebViewController: UIViewController {
    // MARK:- @IBOutlet Properties
    @IBOutlet weak var webView: WKWebView!
    
    // MARK:- Propertises
    var suggestLink: String?
    
    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let link = suggestLink, let url = URL(string: link) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    // MARK:- Methods
    static func storyboardInstance() -> SuggestWebViewController? {
        let storyboard = UIStoryboard(name: SuggestWebViewController.storyboardName(), bundle: nil)
        
        return storyboard.instantiateInitialViewController()
    }
    
    // MARK:- @IBAction Methods
    @IBAction func dissmissBarButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}