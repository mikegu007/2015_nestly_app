//
//  LoginPage.swift
//  SocialListeningApp
//
//  Created by ciccic on 16/2/29.
//  Copyright © 2016年 cicdata. All rights reserved.
//

import UIKit
import Alamofire


class LoginPage: UIViewController,UITextFieldDelegate,UIActionSheetDelegate{
    
    @IBOutlet weak var user_view: UIView!
    
    @IBOutlet weak var password_view: UIView!
    
    @IBOutlet weak var login_button: UIButton!
    
    @IBOutlet weak var user_text: UITextField!
    
    @IBOutlet weak var password_text: UITextField!
    
    var event_text = 1001
    
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
        self.navigationController?.navigationBar.barTintColor = theme.SDNativeBackgroundColor

        //navigationbar
        let brand = UILabel()
        brand.text = "Account Login"
        brand.textColor = UIColor.whiteColor()
        brand.frame = CGRectMake(0, 0, 10, 20)
        brand.font = UIFont(name: "", size: 30)
        navigationItem.titleView = brand
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent

        //边框
        user_view.layer.borderWidth = 0.5
        user_view.layer.borderColor = UIColor(red: 105/255.0, green: 105/255.0, blue: 105/255.0, alpha: 0.1).CGColor
        password_view.layer.borderWidth = 0.5
        password_view.layer.borderColor = UIColor(red: 105/255.0, green: 105/255.0, blue: 105/255.0, alpha: 0.1).CGColor
        
        //login_button相关配置
        login_button.backgroundColor = theme.SDNativeBackgroundColor
        login_button.tintColor = UIColor.whiteColor()
        login_button.layer.masksToBounds = true
        login_button.layer.cornerRadius = 10
        
        //textField相关配置
        user_text.becomeFirstResponder()
        user_text.delegate = self
        password_text.secureTextEntry=true
        password_text.delegate = self
        user_text.returnKeyType = UIReturnKeyType.Default
        
        
        let userName = NSUserDefaults.standardUserDefaults().valueForKey("userName");
        let password = NSUserDefaults.standardUserDefaults().valueForKey("password");

        if let _ = userName {
            user_text.text = userName as? String;
        }
        
        if let _ = password {
            password_text.text = password as? String;
        }
        
        // 清除菜单数据缓存
        for(var i = 1 ; i < 12; i++){
            NSUserDefaults.standardUserDefaults().removeObjectForKey(String(i));
        }
        
        //NSUserDefaults.standardUserDefaults().removeObjectForKey("userName");
        
        NSUserDefaults.standardUserDefaults().synchronize();
        

        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if user_text.canBecomeFirstResponder() == true {
            password_text.becomeFirstResponder()
        }
        return true
    }
    
    
    
    @IBAction func login_action(sender: AnyObject) {
        do{
            let reachability = try Reachability.reachabilityForInternetConnection()
            if reachability.isReachable(){
                self.event_text = 1001
            }else{
                self.event_text = 1003
                Utils.alert_view(event_text);
                return;
            }
        }catch{
            print("connect error")
        }
        
        //错误判断
        if(user_text.text == ""){
            event_text = 1004
            Utils.alert_view(event_text);
            return;
        }
        
        if(user_text.text?.characters.count > 16){
            event_text = 1005
            Utils.alert_view(event_text);
            return;
        }
        
        if(password_text.text == "" ){
            event_text = 1006
            Utils.alert_view(event_text);
            return;
        }
        
        if(password_text.text?.characters.count > 16){
            event_text = 1007
            Utils.alert_view(event_text);
            return;
        }
        
        self.pleaseWait();
        //数据链接，解析
        let url = rootURL + "appUserLogin.cic";
        let parameters = [
            "userName": user_text.text!,
            "password": password_text.text!
        ]
        
//        print(url)
        Alamofire.request(.GET, url,parameters: parameters).responseJSON{
            data in
            self.clearAllNotice();
            if(data.result.isSuccess){
                let json = data.result.value!;
//                print(json);
                
                if (!NSJSONSerialization.isValidJSONObject(json)) {
                    Utils.alert_view(1008);
                }else{
                    
                    let jsonObj = Utils.stringToJson(json);
                    //print(jsonObj)
                    
                    
                    let acctId = jsonObj.objectForKey("acctId");
                    let customerId = jsonObj.objectForKey("customerId") as! Int;

                    if acctId as! Int == 0 {
                        Utils.alert_view(1002);
                    }else{

                        if customerId == 0 {
                            Utils.alert_view(1012);
                        }else{
                        
                            let customerId = jsonObj.objectForKey("customerId");
                            
                            
                            NSUserDefaults.standardUserDefaults().setObject(acctId, forKey: "userId")
                            NSUserDefaults.standardUserDefaults().setObject(customerId, forKey: "customerId")
                            
                            
                            let validStatus = jsonObj.objectForKey("validStatus") as! Int;
                            if validStatus == 1{
                                Utils.alert_view(1013);
                            }else if validStatus == 0 {
                                NSUserDefaults.standardUserDefaults().setObject(self.user_text.text, forKey: "userName")
                                //                        NSNotificationCenter.defaultCenter().postNotificationName("changeName", object: self.user_text.text)
                                NSUserDefaults.standardUserDefaults().setObject(self.password_text.text, forKey: "password")
                                
                                NSUserDefaults.standardUserDefaults().setObject(acctId, forKey: "userId")
                                NSUserDefaults.standardUserDefaults().setObject(customerId, forKey: "customerId")
                                
                                let validStatus = jsonObj.objectForKey("validStatus") as! Int;
                                
                                if validStatus == 0 {
                                    NSUserDefaults.standardUserDefaults().setObject(self.user_text.text, forKey: "userName")
                                    NSUserDefaults.standardUserDefaults().setObject(self.password_text.text, forKey: "password")
                                    
                                    let homePageStatus = jsonObj.objectForKey("homePageStatus") as! Int;
                                    NSUserDefaults.standardUserDefaults().setObject(homePageStatus, forKey: "homePageStatus")
                                    
                                    let resources = jsonObj.objectForKey("resources");
                                    if let _ = resources {
                                        if (NSJSONSerialization.isValidJSONObject(resources!)) {
                                            let jsonObj = Utils.stringToJson(resources!);
                                            
                                            for(var i = 0 ; i < jsonObj.count; i++){
                                                
                                                let temp = jsonObj[i];
                                                let resouStatus  = temp.objectForKey("resouStatus") as! Int;
                                                let tabName = temp.objectForKey("resouName") as! String;
                                                
                                                NSUserDefaults.standardUserDefaults().setObject(tabName, forKey: String(resouStatus));
                                                
                                            }
                                        }
                                    }
                                        if homePageStatus == 0{
                                        
                                        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
                                        
                                        NSNotificationCenter.defaultCenter().postNotificationName(SD_ShowBrandListController_Notification, object: nil,userInfo: ["a":1,"b":3]);
                                    }else{
                                        NSNotificationCenter.defaultCenter().postNotificationName(SD_ShowMianTabbarController_Notification, object: nil,userInfo: ["a":1,"b":3]);
                                        
                                        let brand = jsonObj.objectForKey("brand");
                                        if let _ = brand {
                                            if (NSJSONSerialization.isValidJSONObject(brand!)) {
                                                let bean = BrandBean();
                                                bean.id = brand?.objectForKey("brandId") as! Int;
                                                bean.name = brand?.objectForKey("brandName") as! String;
                                                NSNotificationCenter.defaultCenter().postNotificationName("changeBrand", object: bean)
                                            }
                                        }
                                    }
                                    
                                }else{
                                    Utils.alert_view(1009);
                                }
                            }
                        }
                    }
                }
            }else{
                Utils.alert_view(1008);
            }
            
            NSUserDefaults.standardUserDefaults().synchronize();

        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}