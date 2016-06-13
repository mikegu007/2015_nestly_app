//
//  MainUIViewController.swift
//  SocialListeningApp
//
//  Created by chencharles on 16/3/7.
//  Copyright © 2016年 cicdata. All rights reserved.
//

import UIKit

class MainUIViewController:UIViewController{
 
    var isShow = false;
    var portraitFlag = false;

    override func viewDidLoad() {
        super.viewDidLoad();
        //感知设备方向 - 开启监听设备方向
        UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
        //添加通知，监听设备方向改变
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receivedRotation",
            name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    
    
    
    //通知监听触发的方法
    func receivedRotation(){
        
        /*
        case Unknown
        case Portrait // Device oriented vertically, home button on the bottom
        case PortraitUpsideDown // Device oriented vertically, home button on the top
        case LandscapeLeft // Device oriented horizontally, home button on the right
        case LandscapeRight // Device oriented horizontally, home button on the left
        case FaceUp // Device oriented flat, face up
        case FaceDown // Device oriented flat, face down
        */
        
        let device = UIDevice.currentDevice()
        switch device.orientation{
        case .Portrait:
            //self.tabBarController?.tabBar.hidden = false
            //navigationItem.leftBarButtonItem?.tintColor = UIColor.blueColor()
            print("竖屏");
            portraitFlag = false;
            tabBarTitle(1);
        case .PortraitUpsideDown:
            //self.tabBarController?.tabBar.hidden = true
            //navigationItem.leftBarButtonItem?.title = "Weibo"
            //navigationItem.leftBarButtonItem?.tintColor = UIColor.grayColor()
            print("竖屏倒个个儿");
            portraitFlag = false;

            tabBarTitle(1);
        case .LandscapeLeft:
            //self.tabBarController?.tabBar.hidden = true
            //navigationItem.leftBarButtonItem?.title = "Weibo"
            //navigationItem.leftBarButtonItem?.tintColor = UIColor.grayColor()
            print("横屏往左");
            portraitFlag = true;

            tabBarTitle(0);
            
            
        case .LandscapeRight:
           
            print("横屏往右");
            portraitFlag = true;

            tabBarTitle(0);
            
            
        case .Unknown:
            //self.tabBarController?.tabBar.hidden = false
            //navigationItem.leftBarButtonItem?.tintColor = UIColor.blueColor()
            print("Unkonw");
            /*
            portraitFlag = true;
            tabBarTitle(0);
            
            portraitView();
            */
          
            
            if !portraitFlag {
                tabBarTitle(1);
            }
            
        default:
            //self.tabBarController?.tabBar.hidden = false
            print("default");
            
            if !portraitFlag {
                tabBarTitle(1);
            }
            
            
        }
        
        //self.tabBarController?.tabBar.hidden
    }
    
    func tabBarTitle(index:Int){
        print("self:\(self),isShow:\(isShow),index:\(index)");
        if isShow {
            if index == 0 {
                self.tabBarController?.tabBar.hidden = true
                UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default;
                UIApplication.sharedApplication().statusBarHidden = false;
               
                
            }else{
                UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent;
                self.tabBarController?.tabBar.hidden = false
                
            }
        }
    }
    
        
    override func viewDidAppear(animated: Bool) {
        print("self:\(self),出现了");
        print("portraitFlag:\(portraitFlag)");
        if portraitFlag {
            UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default;
            self.tabBarController?.tabBar.hidden = true

        }else{
            UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent;
            self.tabBarController?.tabBar.hidden = false
        }

        //UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent;

        isShow = true;
    }
    
    override func viewDidDisappear(animated: Bool) {
        print("self:\(self),消失了");
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default;
        isShow = false;
    }
}
