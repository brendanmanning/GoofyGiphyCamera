//
//  AboutViewController.swift
//  GoofyGiphyCamera
//
//  Created by Brendan Manning on 9/9/18.
//  Copyright © 2018 Brendan Manning. All rights reserved.
//

import UIKit
import WebKit

class AboutViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        webView!.load(URLRequest(url: URL(string: "https://github.com/brendanmanning/GoofyGiphyCamera/blob/master/README.md")!));
    }
    
    @IBAction func close(_ sender: Any) {
        self.presentingViewController!.dismiss(animated: true, completion: nil);
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
