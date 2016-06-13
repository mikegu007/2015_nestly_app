//
//  AppDelegate.swift
//  SocialListeningApp
//
//  Created by chencharles on 16/2/18.
//  Copyright © 2016年 cicdata. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
            return UIInterfaceOrientationMask.AllButUpsideDown
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        // 启动画面sleep 2秒钟

        
        application.statusBarHidden = false;
        
        NSThread.sleepForTimeInterval(1.5);
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showMianViewController", name: SD_ShowMianTabbarController_Notification, object: nil)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showBrandListController", name: SD_ShowBrandListController_Notification, object: nil)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showLoginController", name: SD_ShowLoginController_Notification, object: nil)
        
        
        setHomeWindow();
        
        
        return true
    }
    
    private var homePage:HomePage?;
    private var brandPage:BrandList?;
    private var brandNav:UINavigationController?;
    private var loginPage:LoginPage?;
    private var loginNav:UINavigationController?;

    func showMianViewController() {
        /*if let _ = homePage {
            //homePage?.viewControllers?.removeAll();
            homePage?.viewDidLoad();
        }else{
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil);
            homePage = storyBoard.instantiateViewControllerWithIdentifier("Main") as? HomePage;
        }
        */
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil);
        homePage = storyBoard.instantiateViewControllerWithIdentifier("Main") as? HomePage;
        
        self.window!.rootViewController = homePage
        //let nav = wechat.viewControllers![0] as? MainNavigationController
        //(nav?.viewControllers[0] as! MainViewController).pushcityView()
        window?.makeKeyAndVisible()

    }
    
    func showBrandListController() {
        /*if let _ = brandNav {
            brandPage?.loadViewData();
        }else{
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil);
            brandPage = storyBoard.instantiateViewControllerWithIdentifier("BrandList") as? BrandList;
            brandPage!.from = 1;
            brandNav = UINavigationController(rootViewController: brandPage!)
        }*/
        //UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default;

        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil);
        brandPage = storyBoard.instantiateViewControllerWithIdentifier("BrandList") as? BrandList;
        brandPage!.from = 1;
        brandNav = UINavigationController(rootViewController: brandPage!)
    
        self.window?.rootViewController = brandNav;//.presentViewController(nav, animated: true, completion: nil)

        //self.window?.rootViewController?.presentViewController(nav, animated: true, completion: nil);
        
        //let nav = wechat.viewControllers![0] as? MainNavigationController
        //(nav?.viewControllers[0] as! MainViewController).pushcityView()
        window?.makeKeyAndVisible()

    }
    
    func showLoginController() {
        if let _ = loginPage {
            loginPage?.viewDidLoad();
        }else{
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil);
            loginPage = storyBoard.instantiateViewControllerWithIdentifier("account_login") as? LoginPage;
            loginNav = UINavigationController(rootViewController: loginPage!)
        }
        
        self.window?.rootViewController = loginNav;//.presentViewController(nav, animated: true, completion: nil)
        
        //let nav = wechat.viewControllers![0] as? MainNavigationController
        //(nav?.viewControllers[0] as! MainViewController).pushcityView()
        window?.makeKeyAndVisible()
        
    }
    
    

    private var defaultView:UIViewController?;
    private func setHomeWindow() {
        window = UIWindow(frame: MainBounds)
        
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil);
        defaultView = storyBoard.instantiateViewControllerWithIdentifier("DefaultView") ;
        let nav = UINavigationController(rootViewController: defaultView!)
        
        self.window?.rootViewController = nav;//.presentViewController(nav, animated: true, completion: nil)
        
        

        
        let userName = NSUserDefaults.standardUserDefaults().valueForKey("userName");
        let password = NSUserDefaults.standardUserDefaults().valueForKey("password");

        if let _ = userName {

            self.doLogin(userName as! String,password: password as! String);

        }else{

            NSNotificationCenter.defaultCenter().postNotificationName(SD_ShowLoginController_Notification, object: nil,userInfo: ["a":1,"b":3]);

        }
        xwDelay(2) { () -> Void in
            //self.loadView.removeFromSuperview();
            //self.defaultView?.noticeTop("Login err,please try again!",autoClear: true,autoClearTime: 3);
            //self.defaultView?.notice("Login err,please try again!",type: NoticeType.info,autoClear: false,autoClearTime: 3);
            //self.defaultView?.noticeOnlyText("Login err,please try again!");

            
        }

    }

   
    
    
    func doLogin(userName:String,password:String)-> Bool{
        
    /*
        var alamofireManager : Manager?
        // 设置请求的超时时间
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.timeoutIntervalForRequest = 5    // 秒
    
        alamofireManager = Manager(configuration: config)
    */
        
        //addWaitView();
        
        // 清除菜单数据缓存
        for(var i = 1 ; i < 12; i++){
            NSUserDefaults.standardUserDefaults().removeObjectForKey(String(i));
        }
        
        //NSUserDefaults.standardUserDefaults().removeObjectForKey("userName");
        
        NSUserDefaults.standardUserDefaults().synchronize();
        

        
        var flag = false;
        
        //数据链接，解析
        let url = rootURL + "appUserLogin.cic";
        let parameters = [
            "userName": userName,
            "password": password
        ]
        
        
        //print(url)
        Alamofire.request(.GET, url,parameters: parameters).responseJSON{
            data in
            
            if(data.result.isSuccess){
                let json = data.result.value!;
                //print(json);
                
                if (!NSJSONSerialization.isValidJSONObject(json)) {
                    //print("is not a valid json object");
                }else{
                    //print("is not a good json object")
                    
                    let jsonObj = Utils.stringToJson(json);
                    
                    
                    let acctId = jsonObj.objectForKey("acctId") as! Int;
                    let customerId = jsonObj.objectForKey("customerId") as! Int;
                    

                    
                    if acctId > 0 && customerId > 0 {
                        let validStatus = jsonObj.objectForKey("validStatus") as! Int;
                        let homePageStatus = jsonObj.objectForKey("homePageStatus") as! Int;
                        
                        if validStatus == 0 {
                            NSUserDefaults.standardUserDefaults().setObject(acctId, forKey: "userId")
                            NSUserDefaults.standardUserDefaults().setObject(customerId, forKey: "customerId")
                            NSUserDefaults.standardUserDefaults().setObject(homePageStatus, forKey: "homePageStatus")
                            
                            
                            flag = true;
                            //print(flag);
                            
                            let resources = jsonObj.objectForKey("resources");
                            if let _ = resources {
                                if (NSJSONSerialization.isValidJSONObject(resources!)) {
                                    let jsonObj = Utils.stringToJson(resources!);
                                    
                                    for(var i = 0 ; i < jsonObj.count; i++){
                                        
                                        let temp = jsonObj[i];
                                        let resouStatus  = temp.objectForKey("resouStatus") as! Int;
                                        let tabName = temp.objectForKey("resouName") as! String;
                                        let deleteFlag  = temp.objectForKey("deleteFlag") as! Int;
                                        
                                        if deleteFlag == 0 {
                                            NSUserDefaults.standardUserDefaults().setObject(tabName, forKey: String(resouStatus));
                                            
                                        }
                                        
                                    }
                                }
                            }
                            
                            // BrandList
                            if homePageStatus == 0{
                                
                                NSNotificationCenter.defaultCenter().postNotificationName(SD_ShowBrandListController_Notification, object: nil,userInfo: ["a":1,"b":3]);
                                
                                
                            }else{
                                
                                NSNotificationCenter.defaultCenter().postNotificationName(SD_ShowMianTabbarController_Notification, object: nil,userInfo: ["a":1,"b":3]);
                                
                                let brand = jsonObj.objectForKey("brand");
                                if let _ = brand {
                                    if (NSJSONSerialization.isValidJSONObject(brand!)) {
                                        let bean = BrandBean();
                                        bean.id = brand?.objectForKey("brandId") as! Int;
                                        bean.name = brand?.objectForKey("brandName") as! String;
                                        
                                        //print("get default brand");
                                        
                                        NSNotificationCenter.defaultCenter().postNotificationName("changeBrand", object: bean)
                                    }
                                }
                                
                                
                                
                            }
                            
                        }

                    }
                }
            }
            
            if !flag {
                self.defaultView?.noticeTop("Login err,please try again!");
                //self.defaultView?.noticeOnlyText("Login err,please try again!");

                xwDelay(1) { () -> Void in
                    self.defaultView?.clearAllNotice();
                }
                
                NSNotificationCenter.defaultCenter().postNotificationName(SD_ShowLoginController_Notification, object: nil,userInfo: ["a":1,"b":3]);
            }

            NSUserDefaults.standardUserDefaults().synchronize();


        }
        return flag;
    }
    
    

    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    

    
}

