


//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//
//  theme.swift
//  SocialListeningApp
//
//  Created by chencharles on 16/2/18.
//  Copyright © 2016年 cicdata. All rights reserved.
//
//  全局公用属性

import UIKit

public let NavigationH: CGFloat = 64
public let TabBarH: CGFloat = 49

public let AppWidth: CGFloat = UIScreen.mainScreen().bounds.size.width
public let AppHeight: CGFloat = UIScreen.mainScreen().bounds.size.height
public let MainBounds: CGRect = UIScreen.mainScreen().bounds

public var BrandName:String = "Brand";
public var BrandId = 0;

//public let rootURL:String = "http://192.168.4.172:16007/SocialListeningServer/";
public let rootURL:String = "http://116.236.171.122:16007/SocialListeningServer/";

public let SD_ShowMianTabbarController_Notification = "SD_Show_HomePageController_Notification"
public let SD_ShowBrandListController_Notification = "SD_ShowBrandListController_Notification"
public let SD_ShowLoginController_Notification = "SD_ShowLoginController_Notification"


struct theme {
    ///  APP导航条barButtonItem文字大小
    static let SDNavItemFont: UIFont = UIFont.systemFontOfSize(16)
    ///  APP导航条titleFont文字大小
    static let SDNavTitleFont: UIFont = UIFont.systemFontOfSize(18)
    /// ViewController的背景颜色
    static let SDBackgroundColor: UIColor = UIColor.colorWith(255, green: 255, blue: 255, alpha: 1)
    /// webView的背景颜色
    static let SDWebViewBacagroundColor: UIColor = UIColor.colorWith(245, green: 245, blue: 245, alpha: 1)
    // UINavigationController 背景颜色
    static let SDNativeBackgroundColor: UIColor = UIColor.colorWith(57, green: 115, blue: 191, alpha: 1)//UIColor.colorWith(20, green: 90, blue: 177, alpha: 1);
    // 图片圆角半径
    static let ImageCornerRadius:CGFloat = 8;
    
    static let ImageCornerRadiusSamll:CGFloat = 4;

    
    /// 友盟分享的APP key
    static let UMSharedAPPKey: String = "55e2f45b67e58ed4460012db"
    /// 自定义分享view的高度
    static let ShareViewHeight: CGFloat = 215
    static let GitHubURL: String = "https://github.com/ZhongTaoTian"
    static let JianShuURL: String = "http://www.jianshu.com/users/5fe7513c7a57/latest_articles"
    /// cache文件路径
    static let cachesPath: String = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).last!
    /// UIApplication.sharedApplication()
    static let appShare = UIApplication.sharedApplication()
    static let sinaURL = "http://weibo.com/u/5622363113/home?topnav=1&wvr=6"
    /// 高德地图KEY
    static let GaoDeAPPKey = "2e6b9f0a88b4a79366a13ce1ee9688b8"
}


class Utils {
    class func stringToJson(str:AnyObject) ->  AnyObject{
        //利用OC的json库转换成OC的NSData，
        //如果设置options为NSJSONWritingOptions.PrettyPrinted，则打印格式更好阅读
        let data : NSData! = try? NSJSONSerialization.dataWithJSONObject(str, options: [])
        //NSData转换成NSString打印输出
        //let str = NSString(data:data, encoding: NSUTF8StringEncoding)
        //输出json字符串
        //print("Json Str:");
        //print(str!)
        
        //把NSData对象转换回JSON对象
        let json : AnyObject! = try? NSJSONSerialization
            .JSONObjectWithData(data, options:NSJSONReadingOptions.AllowFragments)
        //print("Json Object:"); print(json)
        
        
        return json;
    }
    
    //弹出窗口
    class func alert_view(error : Int){
        let alert = UIAlertView()
        if error == 1002 {
            alert.title = "Invalid user name or password."
        }else if error == 1003 {
            alert.title = "Network error."
        }else if error == 1004 {
            alert.title = "name is empty."
        }else if error == 1005 {
            alert.title = "name is more than 16 characters"
        }else if error == 1006 {
            alert.title = "password is empty"
        }else if error == 1007 {
            alert.title = "password is more than 16 characters"
        }else if error == 1008 {
            alert.title = "Service error."
        }else if error == 1009 {
            alert.title = "your accunt were locked."
        }else if error == 1010 {
            alert.title = "Unauthorized brand."
        }else if error == 1011 {
            alert.title = "Connection error."
        }else if error == 1012 {
            alert.title = "Invalid account."
        }else if error == 1013 {
            alert.title = "Non effective state."
        }
        alert.addButtonWithTitle("OK")
        alert.show()
    }
    
    class func getDateString(offsize:Int) -> String {
        let now = NSDate();
        let interval = NSTimeInterval(24*60*60*offsize);
        let newDate = NSDate(timeInterval: interval, sinceDate: now)
        let dateFormat = NSDateFormatter();
        dateFormat.dateFormat = "yyyy-MM-dd"
        let dateAsString = dateFormat.stringFromDate(newDate)
        return dateAsString
    }
    
    class func getDateStringByMils(mils:Double,formatStr:String) -> String{
        let newDate = NSDate(timeIntervalSince1970: NSTimeInterval(mils/1000));
        let dateFormat = NSDateFormatter();
        
        dateFormat.dateFormat = formatStr;
        let dateAsString = dateFormat.stringFromDate(newDate)
        return dateAsString
    }
    
    class func kSubStringFromIndex(string:String, from:Int) ->String {
        //获取截取的Index
        let fromindex = string.endIndex.advancedBy(from - string.characters.count)
        var subString = string.substringFromIndex(fromindex)
        subString = subString.stringByReplacingOccurrencesOfString("-", withString: "/", options: NSStringCompareOptions.LiteralSearch, range: nil)
        return subString
        
    }
    
    class func mySubStringFromIndex(var string:String, from:Int) ->String {
        //获取截取的Index
        if string.characters.count > from{
            string.removeAtIndex(string.endIndex.advancedBy(-from))
            return string
        }else{
            return string
        }
    }
    
    class func addBorder(view:UIView){
        view.layer.borderColor = UIColor.lightGrayColor().CGColor;
        view.layer.borderWidth = 0.5;
    }
    

    class func StringChanged(var Cstring:String) ->String{
        if Cstring.characters.count > 6{
            Cstring.insert(",", atIndex: Cstring.endIndex.advancedBy(-6))}
        if Cstring.characters.count > 3{
            Cstring.insert(",", atIndex: Cstring.endIndex.advancedBy(-3))
        }
        return Cstring
    }
 
}





