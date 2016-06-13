//
//  HomePage.swift
//  SocialListeningApp
//
//  Created by chencharles on 16/2/18.
//  Copyright © 2016年 cicdata. All rights reserved.
//
//

import UIKit
import Alamofire

class HomePage: UITabBarController {

    override func shouldAutorotate() -> Bool {
        return true
    }
//    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
//        //        UIInterfaceOrientationIsLandscape(UIInterfaceOrientation.LandscapeLeft) = true
//        return UIInterfaceOrientationMask.Portrait
//    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.Portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        //感知设备方向 - 开启监听设备方向
        UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
        //添加通知，监听设备方向改变
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receivedRotation",
            name: UIDeviceOrientationDidChangeNotification, object: nil)
        

        UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
        UIApplication.sharedApplication().statusBarHidden = false;
        setUpAllChildViewController();
        
    }
    let linkView = UIView()
    let linkImg = UIImageView()
    let linkLabel = UILabel()
    
    func linkPage(){
        //NSUserDefaults.standardUserDefaults().removeObjectForKey("linkId");
        let linkId = NSUserDefaults.standardUserDefaults().valueForKey("linkId");

        if let _ = linkId {
            
        }else{
            linkView.frame = CGRect(x: 0, y: 0, width: AppWidth, height: AppHeight)
            linkImg.center = CGPoint(x: AppWidth/2 - 40 , y: AppHeight/2 - 120)
            linkImg.frame.size = CGSize(width: 80, height: 80)
            linkImg.image = UIImage(named: "link")
            linkLabel.frame = CGRect(x: 0, y: AppHeight/2 - 20, width: AppWidth, height: 40)
            linkLabel.text = "Show more details in Landscape Mode"
            linkLabel.textAlignment = NSTextAlignment.Center
            linkLabel.textColor = UIColor.whiteColor()
            linkLabel.font = UIFont(name: "Helvetica", size: 14)
            linkView.backgroundColor = UIColor.darkGrayColor()
            linkView.alpha = 0.9
            linkView.addSubview(linkLabel)
            linkView.addSubview(linkImg)
            self.view.addSubview(linkView)
            linkView.userInteractionEnabled = true
            let tapGR = UITapGestureRecognizer(target: self, action: "linkHidden:")
            linkView.addGestureRecognizer(tapGR)
            //引导页参数
            NSUserDefaults.standardUserDefaults().setObject("1", forKey: "linkId")
            print("successful: \(linkId)")
        }
        
    
    }
    
    func linkHidden(sender : UITapGestureRecognizer){
        linkView.removeFromSuperview();
    }
    
    //通知监听触发的方法
    func receivedRotation(){
        let device = UIDevice.currentDevice()
        switch device.orientation{
        case .LandscapeLeft:
            closeGenerating();
        case .LandscapeRight:
            closeGenerating();
        default:
            break;

        }
    }

    
    func closeGenerating(){
        //linkView.hidden = true
        linkView.removeFromSuperview();
        //关闭设备监听
        UIDevice.currentDevice().endGeneratingDeviceOrientationNotifications()
        
    }
    

    
    func clearViews(){
        for view in views{
            view.removeFromParentViewController();
        }
        views.removeAll();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func selectTabItem(index:Int){
        print("select tab item :\(index)");
        //self.tabBarController?.selectedIndex = index;
        //print("tabBarController:\(self.tabBarController)");
        //print("tabBarItem:\(self.tabBarItem)");

    }
    
    private var owned:UIViewController?;
    private var earned:UIViewController?;
    private var campaign:UIViewController?;

    
    private var views:[UIViewController] = [];
    /// 初始化所有子控制器
    func setUpAllChildViewController() {
        
        //clearViews();
        
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil);

        for(var i = 1 ; i < 4; i++){
            
            let resouStatus  = String(i);
            let tabName = NSUserDefaults.standardUserDefaults().valueForKey(resouStatus);
            print("\(resouStatus),\(tabName)");
            
            if (i == 1) {
                if let _ = tabName{
                    if let _ = owned {
                    }else{
                    }
                    let one = storyBoard.instantiateViewControllerWithIdentifier("OwnedPage");
                    // owned
                    self.tabBaraAddChildViewController(vc: one, title: tabName as! String, imageName: "owned", selectedImageName: "owned2")
                }
                
            }else if i == 2 {
                if let _ = tabName{
                    let two = storyBoard.instantiateViewControllerWithIdentifier("EarnedPage");
                    // earned
                    self.tabBaraAddChildViewController(vc: two, title: tabName as! String, imageName: "earned", selectedImageName: "earned2")
                }
            }else if i == 3 {
                if let _ = tabName{
                    let three = storyBoard.instantiateViewControllerWithIdentifier("CampaignPage");
                    // campaign
                    self.tabBaraAddChildViewController(vc: three, title: tabName as! String, imageName: "campaign", selectedImageName: "campaign2")
                }
            }

            
        }

        
        
        let four = storyBoard.instantiateViewControllerWithIdentifier("MePage");
        // me
        self.tabBaraAddChildViewController(vc: four, title: "Me", imageName: "me", selectedImageName: "me2");
        
        linkPage();
        
    }
    
    private func tabBaraAddChildViewController(vc vc: UIViewController, title: String, imageName: String, selectedImageName: String) {
        vc.tabBarItem = UITabBarItem(title: title, image: UIImage(named: imageName), selectedImage: UIImage(named: selectedImageName))
        vc.view.backgroundColor = theme.SDBackgroundColor
        let nav = MainNavigationController(rootViewController: vc)
        addChildViewController(nav)
        views.append(nav);
    }

    
}