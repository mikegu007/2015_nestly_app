//
//  ViewController.swift
//  SocialListeningApp
//
//  Created by chencharles on 16/2/18.
//  Copyright © 2016年 cicdata. All rights reserved.
//

import UIKit

class DefaultRootView: UIViewController {

    @IBOutlet weak var loadActivity: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadActivity.startAnimating();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

