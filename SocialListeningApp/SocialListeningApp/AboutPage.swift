//
//  AboutPage.swift
//  SocialListeningApp
//
//  Created by ciccic on 16/2/29.
//  Copyright © 2016年 cicdata. All rights reserved.
//

import UIKit


class AboutPage: UIViewController{
    
    @IBOutlet weak var imageview1: UIImageView!
    
//    @IBOutlet weak var imageview2: UIView!
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        //        UIInterfaceOrientationIsLandscape(UIInterfaceOrientation.LandscapeLeft) = true
        return UIInterfaceOrientationMask.Portrait
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.Portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tabBarController?.tabBar.hidden = false
        imageview1.layer.masksToBounds = true
//        imageview2.layer.masksToBounds = true
        imageview1.layer.cornerRadius = 10
//        imageview2.layer.cornerRadius = 4
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func doBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
        // UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent;
    }
    
    
}