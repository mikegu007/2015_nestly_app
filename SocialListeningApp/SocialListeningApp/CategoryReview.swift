//
//  CategoryReview.swift
//  SocialListeningApp
//
//  Created by ciccic on 16/3/2.
//  Copyright © 2016年 cicdata. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


class CategoryReview: UIViewController{
    
    //chart引入
    
    @IBOutlet weak var view1: UIView!
    
    @IBOutlet weak var view2: UIView!
    
    @IBOutlet weak var view3: UIView!
    
    @IBOutlet weak var view1_2: UIView!
    
    /*
    1001 normal
    1002 return null
    1003 network error
    */
    private var event_text = 0
    var loadImg:UIButton?
    var loadLabel:UILabel?
    
    var bean = AccountBean();

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //网络监测
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self,selector: "reachabilityChanged:",name: ReachabilityChangedNotification,
            object: reachability)
        
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        
        //navigationbar
        let brand = UILabel()
        brand.text = "Category Review - Metrics form last 7 days"
        brand.textColor = UIColor.blackColor()
        brand.frame = CGRectMake(0, 0, 10, 20)
        brand.font = UIFont(name: "", size: 30)
        navigationItem.titleView = brand
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        UIDevice.currentDevice().setValue(UIInterfaceOrientation.LandscapeRight.rawValue, forKey: "orientation")

        loadChartViewData()
        addErrorView()

    }
    
    func reachabilityChanged(note: NSNotification) {
            
            let reachability = note.object as! Reachability
            
            if reachability.isReachable() {
            if reachability.isReachableViaWiFi() {
            print("Reachable via WiFi")
            event_text = 1001
        } else {
            print("Reachable via Cellular")
            event_text = 1001
            }
        } else {
            print("Not reachable")
            Utils.alert_view(1003)
            event_text = 1003
            }
    }
    
    
    func addErrorView(){
        if self.event_text == 1001{
            view1_2.hidden = false
            view3.hidden = false
        }else if(self.event_text == 1003){
            view1_2.hidden = true
            view3.hidden = true
            loadImg = UIButton(frame: CGRectMake(AppHeight/2 - 40, 120, 80, 80))
            loadImg?.setBackgroundImage(UIImage(named: "load"), forState: .Normal)
            loadImg!.addTarget(self, action: "reloadEvent", forControlEvents: UIControlEvents.TouchUpInside)
            loadLabel = UILabel(frame: CGRect(x: AppHeight/2 - 90, y: 220, width: 200, height: 44))
            loadLabel?.text = "Network error,tap to reload"
            loadLabel?.font = UIFont(name: "Helvetica", size: 16)
            loadLabel?.textColor = UIColor.lightGrayColor()
            self.view.bringSubviewToFront(loadImg!)
            self.view.addSubview(loadImg!)
            self.view.addSubview(loadLabel!)
        }
    }
    
    func reloadEvent(){
        //print("success")
    }
    
    func loadChartViewData(chart:ChartViewInterface){
        //192.168.4.172:16007/SocialListeningServer/slccAction/getSlccData.cic?pageId=79&type=11
        
        //数据链接
        let url = rootURL + "slccAction/getSlccData.cic";
        
        let parameters = [
            "pageId": bean.id,
            "type":11

        ]
        Alamofire.request(.GET, url,parameters: parameters ).responseJSON{
            data in
//            print(data)
            if(data.result.isSuccess){
                let json = data.result.value!;
                chart.setData(json)
            }else{
                Utils.alert_view(1011);
            }
        }
    }
    
    
    func loadSLCCData(){
        //192.168.4.172:16007/SocialListeningServer/slccAction/getSlccData.cic?pageId=79&type=11
        
        //数据链接
        let url = rootURL + "slccAction/getSlccData.cic";
        
        let parameters = [
            "pageId": bean.id,
            "type":11
        ]
        Alamofire.request(.GET, url,parameters: parameters ).responseJSON{
            data in
            //print(data)
            if(data.result.isSuccess){
                let json = data.result.value!;
                self.pieview1.setData(json)
                self.lines.setData(json)
                self.barsGradient.setData(json)

            }else{
                Utils.alert_view(1011);
            }
        }
    }
    
    let pieview1 = PieChartViewTool()
    let lines = BarAndLinesChartViewTool()
    let barsGradient = BarsWithGradientTool();
    
    func loadChartViewData(){
        
        //set charts
        self.view.backgroundColor = UIColor.whiteColor()
        pieview1.frame.size.width = self.view.frame.height * (1/2)
        pieview1.frame.size.height  = self.view.frame.width * (0.55)
//        pieview1.setChart(months, values: unitsSold)
        //loadChartViewData(pieview1)

        view2.addSubview(pieview1)


        lines.frame = CGRect(x: 0, y: view3.y, width: self.view.frame.height, height: view3.height)
        //loadChartViewData(lines)
        view3.addSubview(lines)

        barsGradient.frame = CGRect(x: 0, y: 0,
            width: self.view.frame.height * (1/2), height:self.view.frame.width * (0.55));
        //loadChartViewData(barsGradient)
        view1.addSubview(barsGradient)
        
        loadSLCCData();
    }
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //禁止
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    
    @IBAction func doBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent;
        UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")

    }
    
    
}