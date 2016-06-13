//
//  CategoryReviewInfo.swift
//  SocialListeningApp
//
//  Created by ciccic on 16/3/18.
//  Copyright © 2016年 cicdata. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


class CategoryReviewInfo: UIViewController,UIScrollViewDelegate{
    
    //chart引入
    
    @IBOutlet weak var view1: UIView!
    
    @IBOutlet weak var view2: UIView!
        
    @IBOutlet weak var add_barItem: UIBarButtonItem!
    
    @IBOutlet weak var main_scroll_view: UIScrollView!
    
    @IBOutlet weak var page_control: UIPageControl!
    
    // 保存循环的数据
    private var datas = [String]();
    
    var add_tableView = UITableView()

    var loadImg:UIButton?
    var loadLabel:UILabel?
    
    var bean = AccountBean();
    var portraitFlag = false;
 
    private var event_text = 1001
    
    var type_choose = 11
    private var hiddenNavBar = false;
    
    private var lastClickTime = NSDate().timeIntervalSince1970;
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        //        UIInterfaceOrientationIsLandscape(UIInterfaceOrientation.LandscapeLeft) = true
        return UIInterfaceOrientationMask.Landscape
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.LandscapeLeft
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        reachability_listening()
        //navigationbar
        let brand = UILabel()
        brand.text = bean.name
        brand.textColor = UIColor.blackColor()
        brand.frame = CGRectMake(0, 0, 10, 20)
        brand.font = UIFont(name: "", size: 30)
        navigationItem.titleView = brand
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 64, width: AppWidth, height: AppHeight)
//            CGPoint(x: 0, y: 64)

//        UIDevice.currentDevice().setValue(UIInterfaceOrientation.LandscapeRight.rawValue, forKey: "orientation")
        main_scroll_view.delegate = self
        add_tableView.delegate = self
        add_tableView.dataSource = self
        add_tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        add_tableView.bounces = false
        add_tableView.backgroundColor = UIColor.clearColor()
        add_tableView.alpha = 0.0
        self.automaticallyAdjustsScrollViewInsets = false
        
        
//        addErrorView(1001)
        
        //loadSLCCDataByLoop();
        
        let tag = UITapGestureRecognizer(target: self, action: "hiddenMenu");
        main_scroll_view.addGestureRecognizer(tag);
        
        
        lastClickTime = NSDate().timeIntervalSince1970;
        checkDateThread();
        /*
        xwDelay(2) { () -> Void in
            self.setNavBarVisible();

        }*/
        UIDevice.currentDevice().setValue(UIInterfaceOrientation.LandscapeLeft.rawValue, forKey: "orientation")


    }
    
    //网络监测
    var reachability: Reachability!
    
    func reachability_listening(){
        
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self,selector: "reachabilityChanged:",name: ReachabilityChangedNotification,object: nil)
    }
    
   
    func setNavBarVisible() {
        
        let frame = self.navigationController?.navigationBar.frame
        let offsetY = (hiddenNavBar ? CGFloat(20) : -64)
        navigationController?.navigationBar.alpha = 0.85
        let duration:NSTimeInterval = (0.5)
        if frame != nil {
            UIView.animateWithDuration(duration) {
                self.navigationController?.navigationBar.frame.origin = CGPoint(x: 0, y: offsetY)
//                print(offsetY)
                return
            }
        }
        setChartViewFrame()

    }
    
       
    func hiddenMenu(){
        //print("...");
        if hiddenNavBar == true{
            setNavBarVisible()
        }
        //setNavBarVisible()
        
        lastClickTime = NSDate().timeIntervalSince1970;
        if i > 0 {
            //淡出动画
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.6)
            add_tableView.alpha = 0.0
            UIView.commitAnimations()
            i = 0
        }
    }
    
    
    func checkDateThread(){
        let thread = NSThread(target: self, selector: "doHiddenNav", object: nil);
        thread.start();
    }
    
    var checkDate = true;

    func doHiddenNav(){
        while checkDate {
            let nowTime = NSDate().timeIntervalSince1970;
            //print("nowTime:\(nowTime),lastClickTime:\(lastClickTime)");
            //print("time distance:\(nowTime - lastClickTime)");
            if nowTime - lastClickTime >= 3 {
                if hiddenNavBar == false{
                    xwDelay(0.5) { () -> Void in
                        self.setNavBarVisible();
                    }
                }
            }
            
            sleep(1);
        }
    }
    
    
    
    func loadSLCCDataByLoop(){
        let thread = NSThread(target: self, selector: "doShow", object: nil);
        thread.start();
    }

    var flag = true;

    func doShow(){
        var i = 12;
        while flag {
            
            sleep(5);            
            
            if i == 16 {
                i = 11;
            }
            
            loadSLCCData(i);
            
            i++;
        }
    }


    
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable() {
            if reachability.isReachableViaWiFi() {
                print("Reachable via WiFi")
                event_text = 1001
                loadChartViewData()
//                addErrorView(1001)
            } else {
                print("Reachable via Cellular")
                event_text = 1001
                loadChartViewData()
//                addErrorView(1001)
            }
        } else {
            print("Not reachable")
            event_text = 1003
            xwDelay(0.1) { () -> Void in
//                Utils.alert_view(1003)
                self.addErrorView()

            }
        }
    }
    
    
    func addErrorView(){
            main_scroll_view.hidden = true
            loadImg = UIButton(frame: CGRectMake(AppHeight/2 - 40, 120, 80, 80))
            loadImg?.setBackgroundImage(UIImage(named: "load"), forState: .Normal)
            loadImg!.addTarget(self, action: "reloadEvent", forControlEvents: UIControlEvents.TouchUpInside)
            loadLabel = UILabel(frame: CGRect(x: AppHeight/2 - 90, y: 220, width: 200, height: 44))
            loadLabel?.text = "Network error,tap to reload"
            loadLabel?.font = UIFont(name: "Helvetica", size: 16)
            loadLabel?.textColor = UIColor.lightGrayColor()
        
            self.view.addSubview(loadImg!)
            self.view.addSubview(loadLabel!)
            self.view.bringSubviewToFront(loadImg!)

//        }
    }
    
    func reloadEvent(){
        loadChartViewData()
        
    }
    
    func removeNetError(){
        loadImg?.removeFromSuperview()
        loadLabel?.removeFromSuperview()
        main_scroll_view.hidden = false
    }
    

    
    
    func loadSLCCData(type:Int){
        //192.168.4.172:16007/SocialListeningServer/slccAction/getSlccData.cic?pageId=79&type=11
//        self.pleaseWait()
        //数据链接
        removeChartsData()
        let url = rootURL + "slccAction/getSlccData.cic";
//        print("type:\(type)");
//        print("pageId:\(bean.id)");
        let parameters = [
            "pageId": bean.id,
            "type":type
        ]
        Alamofire.request(.GET, url,parameters: parameters ).responseJSON{
            data in
//            print(data)
            self.clearAllNotice();
            if(data.result.isSuccess){
                let json = data.result.value!;
                self.pieview1.setData(json,a: 0)
                self.barsGradient.setData(json,a: 0)
                
                var pie_data = [:]
                pie_data = self.pieview1.setData(json,a: 0)

                let pie_name = pie_data.objectForKey("piecharts_name") as! NSArray
                let pie_values = pie_data.objectForKey("piecharts_values") as! NSArray
                var pie_all_values = 0.0
                for(var j = 0 ; j < pie_name.count; j++){
                    pie_all_values += pie_values[j] as! Double
                }
                if pie_name.count > 0{
                    self.pie_View?.name_label1.text = pie_name[0] as? String
                    self.pie_View?.number_label1.text =  (NSString(format: "%.2f", pie_values[0] as! Double * 100 / pie_all_values) as String) + "%"
                    self.pie_View?.image1.hidden = false
                    
                }
                if pie_name.count > 1{
                    self.pie_View?.name_label2.text = pie_name[1] as? String
                    self.pie_View?.number_label2.text =  (NSString(format: "%.2f", pie_values[1] as! Double * 100 / pie_all_values) as String) + "%"
                    self.pie_View?.image2.hidden = false
                    
                }
                if pie_name.count > 2{
                    self.pie_View?.name_label3.text = pie_name[2] as? String
                    self.pie_View?.number_label3.text =  (NSString(format: "%.2f", pie_values[2] as! Double * 100 / pie_all_values) as String) + "%"
                    self.pie_View?.image3.hidden = false
                    
                }
                if pie_name.count > 3{
                    self.pie_View?.name_label4.text = pie_name[3] as? String
                    self.pie_View?.number_label4.text =  (NSString(format: "%.2f", pie_values[3] as! Double * 100 / pie_all_values) as String) + "%"
                    self.pie_View?.image4.hidden = false
                }
                if pie_name.count > 4{
                    self.pie_View?.name_label5.text = pie_name[4] as? String
                    self.pie_View?.number_label5.text =  (NSString(format: "%.2f", pie_values[4] as! Double * 100 / pie_all_values) as String) + "%"
                    self.pie_View?.image5.hidden = false
                }
                
            }else{
                Utils.alert_view(1011);
            }
        }
    }
    
    func removeChartsData(){
        pie_View?.image1.hidden = true
        pie_View?.image2.hidden = true
        pie_View?.image3.hidden = true
        pie_View?.image4.hidden = true
        pie_View?.image5.hidden = true

        pie_View?.name_label1.text = ""
        pie_View?.name_label2.text = ""
        pie_View?.name_label3.text = ""
        pie_View?.name_label4.text = ""
        pie_View?.name_label5.text = ""

        pie_View?.number_label1.text = ""
        pie_View?.number_label2.text = ""
        pie_View?.number_label3.text = ""
        pie_View?.number_label4.text = ""
        pie_View?.number_label5.text = ""

    }
    
    let pieview1 = PieChartViewTool()
    let pie_View = NSBundle.mainBundle().loadNibNamed("category_pie_tuglie", owner: nil, options: nil).last as? Category_pie_tuglie
    let barsGradient = BarsWithGradientTool();
    
    private var chartViewWidht:CGFloat = 0;
    private var chartViewHeight:CGFloat = 0;

    func loadChartViewData(){
        if event_text != 1001{
            Utils.alert_view(event_text)
            return
        }
        removeNetError()
        //set charts
        self.view.backgroundColor = UIColor.whiteColor()
        
        let chartY:CGFloat = 30;
        
        chartViewWidht = AppHeight;// self.view.frame.height;
        chartViewHeight = AppWidth;// self.view.frame.width;

//        pieview1.frame = CGRect(x: chartViewWidht, y: chartY, width: chartViewWidht, height: chartViewHeight*0.8)
        pieview1.frame = CGRect(x: 0, y: chartY + 10, width: (chartViewWidht - 10)/2, height: chartViewHeight*0.9 - 20)
        let b = UIView()
        pie_View?.frame = CGRect(x: 0, y: 0,width: (chartViewWidht - 10)/2, height: chartViewHeight*0.7);
        b.frame = CGRect(x: (chartViewWidht - 5 )/2, y: chartY,width: (chartViewWidht - 10)/2, height: chartViewHeight*0.7);
        b.addSubview(pie_View!)
        b.backgroundColor = UIColor.blackColor()
        
        barsGradient.frame = CGRect(x: 0 , y: chartY + 20,width: chartViewWidht - 20, height:chartViewHeight * 0.7 + 20);
                
        view1.addSubview(barsGradient)
        view2.addSubview(pieview1)
        view2.addSubview(b)

        Utils.addBorder(view1);
        Utils.addBorder(view2);

        loadSLCCData(type_choose);
    }
    
    
    
    func scrollViewDidScroll(scrollView:UIScrollView){
        let width = self.view.frame.width
        let offsetX1 = main_scroll_view.contentOffset.x - 8
        let index = offsetX1 / width
        page_control.currentPage = Int(index + 1)

    }
    
    
    func setChartViewFrame(){

        let duration:NSTimeInterval = 0.5;
        UIView.animateWithDuration(duration) {
            var chartY:CGFloat = 10;
            var offY:CGFloat = 0;
            if self.hiddenNavBar == false {
                chartY = 30;
                offY = 64;
            }else{
                chartY = 30;
                offY = 0;
            }
            self.pieview1.frame = CGRect(x: 0, y: chartY + 10, width: (self.chartViewWidht  - 10)/2, height: self.chartViewHeight*0.9 - 20)
            self.barsGradient.frame = CGRect(x: 0, y: chartY + 20,width: self.chartViewWidht  - 10, height:self.chartViewHeight * 0.7 + 20);
            self.hiddenNavBar = !self.hiddenNavBar;

            return
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    
    @IBAction func doBack(sender: AnyObject) {
        flag = false;
        checkDate = false;
        //self.tabBarController?.tabBar.hidden = false
        self.dismissViewControllerAnimated(true, completion: nil);
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent;
        if portraitFlag == false{
            UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
        }
        
    }
    var i = 0

    @IBAction func add_barItem_action(sender: AnyObject) {
        add_tableView.frame = CGRect(x: self.view.width - 90, y: (navigationController?.navigationBar.height)! + 20, width: 90, height: 125)
        self.view.addSubview(add_tableView)
        if i == 0 {
            //淡入动画
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.6)
            add_tableView.alpha = 1
            UIView.commitAnimations()
            i++
        }else{
            //淡出动画
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.6)
            add_tableView.alpha = 0.0
            UIView.commitAnimations()
            i = 0
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        //        super.viewDidDisappear()
        stopListening()
    }
    
    func stopListening(){
        if reachability != nil{
            reachability.stopNotifier()
            reachability = nil;
            NSNotificationCenter.defaultCenter().removeObserver(self, name: ReachabilityChangedNotification, object: nil);
        }
    }
}

let test = ["All","Weibo","BBS","News","E-Com"]

///MARK:- UITableViewDelegate和UITableViewDataSource
extension CategoryReviewInfo: UITableViewDelegate, UITableViewDataSource {
    
    //获取tableviewcell个数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return test.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 25
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = NSBundle.mainBundle().loadNibNamed("DateViewCell", owner: nil, options: nil).last as? DataViewCell
        cell?.label_data.text = test[indexPath.row]
        cell?.label_data.font = UIFont(name: "Helvetica", size: 14)
        cell?.label_data.textColor = UIColor.grayColor();

        cell!.layer.masksToBounds = true
        cell!.layer.cornerRadius = 1
        if indexPath.row == 0 {
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        return cell!
    }
    
    
    //tableViewCell点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        var arry = tableView.visibleCells
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //淡入动画
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.6)
        add_tableView.alpha = 0.0
        UIView.commitAnimations()
        i = 0
        for(var j = 0;j < arry.count;j++){
            let cells:UITableViewCell = arry[j]
            cells.accessoryType = UITableViewCellAccessoryType.None
        }
        cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        if indexPath.row == 0 {
            type_choose = 11
        }else if indexPath.row == 1 {
            type_choose = 12
        }else if indexPath.row == 2 {
            type_choose = 13
        }else if indexPath.row == 3 {
            type_choose = 14
        }else if indexPath.row == 4 {
            type_choose = 15
        }
        loadSLCCData(type_choose);

    }
}