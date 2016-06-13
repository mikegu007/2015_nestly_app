//
//  BrandList.swift
//  SocialListeningApp
//
//  Created by chencharles on 16/2/19.
//  Copyright © 2016年 cicdata. All rights reserved.
//

//

import Foundation
import UIKit
import Alamofire

class BrandList: UIViewController,UITableViewDelegate,UITableViewDataSource,LoadDataDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    // 记录页面是从哪里过来
    var from = 0;
    var brands = [BrandBean]();
    /*
    1001 normal
    1002 return null
    1003 network error
    */
    private var event_text = 1001
    var loadImg:UIButton? = UIButton();
    var loadLabel:UILabel? = UILabel();
    var contentLabel:UILabel? = UILabel();

    
    var intentDelegate:IntentDelegate?;

    var reachability: Reachability!
    
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
        super.viewDidLoad();


        //网络监测
        reachability_listening()
        tableView.delegate = self;
        tableView.dataSource = self;
        self.addRefreshHeaher();
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        addErrorContent();
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default;
        xwDelay(0.5) { () -> Void in
            self.refresh()
        }
    }
    
    
    //网络监测
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
        
        NSNotificationCenter.defaultCenter().addObserver(self,selector: "reachabilityChanged:",name: ReachabilityChangedNotification,
            object: nil)
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
            xwDelay(0.1) { () -> Void in
                Utils.alert_view(1003)
            }
            event_text = 1003;
        }
        setBrandList(event_text);
    }
    
    func setBrandList(let event:Int){
        if(event == 1001){
            tableView.scrollEnabled = true;
            loadViewData();
        }else if(event == 1003){
            tableView.scrollEnabled = false;
            if brands.isEmpty{
                addErrorView()
            }
        }
    }

    
    func addRefreshHeaher(){
        let headerView = XWRefreshNormalHeader(target: self, action: "upPullLoadData");
        tableView.headerView = headerView;
    }
    
    func addErrorView(){
         xwDelay(0.1) { () -> Void in
            let loadImg = self.loadImg;
            loadImg?.frame.size = CGSize(width: 80, height: 80)
            loadImg?.center = CGPoint(x: AppWidth / 2, y: AppHeight/3 - 50)
            loadImg?.setBackgroundImage(UIImage(named: "load"), forState: .Normal)
            loadImg!.addTarget(self, action: "reloadEvent", forControlEvents: UIControlEvents.TouchUpInside)
            let loadLabel = self.loadLabel;
            loadLabel?.frame.size = CGSize(width: 200, height: 44)
            loadLabel?.center = CGPoint(x: AppWidth / 2, y: AppHeight / 2 - 80)
            loadLabel?.textAlignment = NSTextAlignment.Center
            loadLabel?.text = "Network error,tap to reload"
            loadLabel?.font = UIFont(name: "Helvetica", size: 16)
            loadLabel?.textColor = UIColor.lightGrayColor()
            self.view.addSubview(loadImg!)
            self.view.addSubview(loadLabel!)
        }
    }
    
    func removeErrorView(){
        xwDelay(0.1) { () -> Void in
            self.loadImg?.removeFromSuperview()
            self.loadLabel?.removeFromSuperview()
            
        }
    
    }
    
    func addErrorContent(){
            contentLabel?.frame.size = CGSize(width: 200, height: 44)
            contentLabel?.textAlignment = NSTextAlignment.Center
            contentLabel?.center = CGPoint(x: AppWidth/2, y: AppHeight/2)
            contentLabel?.text = "No content"
            contentLabel?.font = UIFont(name: "Helvetica", size: 16)
            contentLabel?.textColor = UIColor.lightGrayColor()
            contentLabel?.hidden = false
            self.view.addSubview(contentLabel!)
    }

    func reloadEvent(){
        //print("success");
        loadViewData();
    }

    
    func loadViewData(){
//        print(event_text);
        if event_text != 1001{
            Utils.alert_view(self.event_text);
            self.tableView.headerView?.endRefreshing()
            return;
        }
        self.pleaseWait()
//        print("初始化加载数据1");
        //数据链接，解析
        let url = rootURL + "brand/getBrandListForApp.cic";
        let customerId = NSUserDefaults.standardUserDefaults().valueForKey("customerId") as! Int;
        let acctId = NSUserDefaults.standardUserDefaults().valueForKey("userId") as! Int;
        let parameters = [
            "cusId": customerId,
            "userId": acctId
        ]
        Alamofire.request(.GET, url,parameters: parameters).responseJSON{
            data in
//            print(data)
            if(data.result.isSuccess){
                let json = data.result.value!;
                if (!NSJSONSerialization.isValidJSONObject(json)) {
                    Utils.alert_view(1008);
                }else{
                    let jsonObj = Utils.stringToJson(json);
                    for(var i = 0 ; i < jsonObj.count; i++){
                        let temp = jsonObj[i]
                        let bean = BrandBean();
                        bean.id = temp.objectForKey("brandId") as! Int;
                        bean.owned = temp.objectForKey("owned") as! Int;
                        bean.img = temp.objectForKey("brandLogo") as! String;
                        bean.imageurl = rootURL + "/images/" + (temp.objectForKey("brandLogo") as! String);
                        bean.name = temp.objectForKey("brandName") as! String;
                        self.brands.append(bean);
                    }
                    if self.brands.count == 0 {
                        self.addErrorContent();
                        self.tableView.headerView?.endRefreshing()
                    }else{
                        self.tableView.reloadData();
                        self.tableView.headerView?.endRefreshing()
                    }
                    self.removeErrorView()

                }
            }else{
                if self.event_text == 1003{
                    
                }else{
                    Utils.alert_view(1011);
                }
            }
            self.clearAllNotice();
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //获取tableviewcell个数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
//        print(brands.count)
        if(brands.count == 0){
        }else{
            contentLabel?.removeFromSuperview()
        }
        return brands.count

    }
    //tableviewcell内容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let identifier = "brand_cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? BrandTableCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("BrandTableCell", owner: nil, options: nil).last as? BrandTableCell
        }
        
        let bean = brands[indexPath.row];
        cell!.model = bean;
        
        if BrandId == 0 {
            if indexPath.row == 0 {
                cell?.accessoryType = UITableViewCellAccessoryType.Checkmark;
            }
        }else if bean.id == BrandId {
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark;
        }
        
        if bean.owned == 1 {
            cell?.brand.textColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
            cell?.brandImg?.image = UIImage(named: "brindlist_nochanged")
        }
        
        cell?.layer.borderWidth = 0.3
        cell?.layer.borderColor = UIColor(red: 105/255.0, green: 105/255.0, blue: 105/255.0, alpha: 0.1).CGColor
        return cell!
        
    }
    //tableViewCell点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        xwDelay(0.5) { () -> Void in
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        var arry = tableView.visibleCells
//        print(indexPath.row)
        let bean = self.brands[indexPath.row];
        if bean.owned == 1 {
            //无访问权限
            Utils.alert_view(1010)
            return
        }else{
            print("arry.count = \(arry.count)")
            for(var i = 0;i<arry.count;i++){
                let cells:UITableViewCell = arry[i]
                cells.accessoryType = UITableViewCellAccessoryType.None
                cells.textLabel?.textColor = UIColor.grayColor()
                
            }
            cell?.textLabel?.textColor = UIColor.blackColor()
            
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark;

            var sendNotice = false;
            if bean.id != BrandId {
                BrandId = bean.id;
                sendNotice = true;
            }
         
            self.doBack("");
            
            if sendNotice {
                NSNotificationCenter.defaultCenter().postNotificationName("changeBrand", object: bean)
            }
            //intentDelegate?.getIntentValue((bean.name));
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    
    @IBAction func doBack(sender: AnyObject) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent;
        if reachability != nil{
        reachability.stopNotifier()
        reachability = nil;
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ReachabilityChangedNotification, object: nil);
        }
        if from == 1 {
            NSNotificationCenter.defaultCenter().postNotificationName(SD_ShowMianTabbarController_Notification, object: "");
            if BrandId == 0 {
                if brands.count > 0 {
                    let bean = brands[0];
                    NSNotificationCenter.defaultCenter().postNotificationName("changeBrand", object: bean)
                }
            }
        }else{
            xwDelay(0.2) { () -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
            }

        }
    }
    
    
    func upPullLoadData(){
        //print("下拉刷新");
            self.brands.removeAll();
            self.loadViewData();
    }
    
    func refresh(){
        upPullLoadData();
    }
    
    func loadMore(){
       // print("上拉加载更多");
        
        //延迟执行 模拟网络延迟，实际开发中去掉
        xwDelay(1) { () -> Void in
            let table:UITableView = self.tableView;
            table.reloadData()
            table.footerView?.endRefreshing()
        }
    }

}
