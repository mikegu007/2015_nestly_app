//
//  MePage.swift
//  SocialListeningApp
//
//  Created by ciccic on 16/2/22.
//  Copyright © 2016年 cicdata. All rights reserved.
//

import UIKit


class MePage: MainUIViewController{
    
    @IBOutlet weak var user_view: UIView!
    @IBOutlet weak var password_view: UIView!
    @IBOutlet weak var logout_view: UIView!
    
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var name_id: UILabel!
    @IBOutlet weak var about: UIView!
    //private var isShow = false;
    @IBOutlet var my_view: UIView!
    
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
        my_view.backgroundColor = UIColor(red: 245 / 255.0, green: 245 / 255.0, blue: 249 / 255.0, alpha:0.1)
        let brand = UILabel()
        brand.text = "Me"
        brand.textColor = UIColor.whiteColor()
        brand.frame = CGRectMake(0, 0, 10, 20)
        brand.font = UIFont(name: "", size: 30)
        navigationItem.titleView = brand
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent

        password_view.layer.borderWidth = 0.5
        password_view.layer.borderColor = UIColor(red: 105/255.0, green: 105/255.0, blue: 105/255.0, alpha: 0.1).CGColor
        logout_view.layer.borderWidth = 0.5
        logout_view.layer.borderColor = UIColor(red: 105/255.0, green: 105/255.0, blue: 105/255.0, alpha: 0.1).CGColor
        
        let userName = NSUserDefaults.standardUserDefaults().valueForKey("userName");
        name_id.text = userName as? String
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changename:", name: "changeNamechangeName", object: nil)
        let tapGR3 = UITapGestureRecognizer(target: self, action: "test:")
        about.addGestureRecognizer(tapGR3)


    }
    
    func test(sender:UITapGestureRecognizer){
        about_view("");
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBarTitle(index:Int){
        print("Me isShow:\(isShow),index:\(index)");
        if isShow {
            // 横屏
            if index == 0 {
                self.tabBarController?.tabBar.hidden = true
                UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent;
                UIApplication.sharedApplication().statusBarHidden = false;
                // 竖屏
            }else{
                
                UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent;
                self.tabBarController?.tabBar.hidden = false
                
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        //print("出现了");
        if portraitFlag {
            UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent;
            self.tabBarController?.tabBar.hidden = true
            
        }else{
            UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent;
            self.tabBarController?.tabBar.hidden = false
        }
        isShow = true;

    }
    
    override func viewDidDisappear(animated: Bool) {
        isShow = false;
        //print("消失了");
        //UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default;
    }
    

    
    @IBAction func about_view(sender: AnyObject) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil);
        let about = storyBoard.instantiateViewControllerWithIdentifier("about_page")
        let nav = UINavigationController(rootViewController: about);
        self.presentViewController(nav, animated: true, completion: nil)
    }
    

    @IBAction func log_out(sender: AnyObject) {
        // 清除菜单数据缓存
        for(var i = 1 ; i < 12; i++){
            NSUserDefaults.standardUserDefaults().removeObjectForKey(String(i));
        }
        
        //NSUserDefaults.standardUserDefaults().removeObjectForKey("userName");
        NSUserDefaults.standardUserDefaults().synchronize();
        BrandId = 0;
        NSNotificationCenter.defaultCenter().postNotificationName(SD_ShowLoginController_Notification, object: nil,userInfo: ["a":1,"b":3]);

        
    }
    
    
    
}