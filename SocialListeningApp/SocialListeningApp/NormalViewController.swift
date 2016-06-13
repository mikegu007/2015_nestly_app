//
//  NormalViewController.swift
//  SocialListeningApp
//
//  Created by chencharles on 16/2/24.
//  Copyright © 2016年 cicdata. All rights reserved.
//

import Foundation
import UIKit

class NormalViewController:UIViewController {
    
    var brand = UILabel();
    var titleText = BrandName;

    /// MARK:- 方法
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "navback"), style: UIBarButtonItemStyle.Plain, target: self, action: "doBack");
        brand.text = titleText;
        brand.textColor = UIColor.blackColor();
        brand.frame = CGRectMake(0, 0, 10, 20)
        brand.font = UIFont(name: "", size: 30)
        navigationItem.titleView = brand;
        
    }
    
    func doBack(){
        //UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent;
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}