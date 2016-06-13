//
//  OwnedPage.swift
//  SocialListeningApp
//
//  Created by chencharles on 16/2/18.
//  Copyright © 2016年 cicdata. All rights reserved.
//

//

import UIKit
import SwiftCharts
import Alamofire


class OwnedPage: MainUIViewController,DoubleTextViewDelegate,LoadDataDelegate,UISearchBarDelegate,IntentDelegate{
    
    
    @IBOutlet weak var viewNormal: UIView!
    
    @IBOutlet weak var viewPortrait: UIView!
    
    @IBOutlet weak var switchBtn: DoubleTextView!
    
    var mainScrollView:UIScrollView!;
    
    var tableView1:MainTableView!;
    var tableView2:MainTableView!;
    var tableView3:MainTableView!;
    var tableView4:MainTableView!;
    var changeDaysBtn:UISegmentedControl = UISegmentedControl(items: ["1 Day","7 Days","14 Days","30 Days"]);
    
    var weiboName:String = "";
    var wechatName:String = "";

    // 记录切换到哪个tab
    private var currIndex = 0;
    // -1 都没有权限 0 第一个有权限 1 第二个有权限 2 都有权限
    private var ownedType = 2;
    //private var portraitFlag = false;
    private var selectRow:NSIndexPath?;
    
    var weiboAccounts = [AccountBean]();
    var wechatAccounts = [AccountBean]();
    private let brand = UILabel();
    var intentDelegate:IntentDelegate?;
    /*
    1001 normal
    1002 return null
    1003 network error
    */
    private var event_text = 1001
    var loadImg:UIButton?
    var loadLabel:UILabel?
    var contentLabel1:UILabel?
    var contentLabel2:UILabel?
    var contentLabel3:UILabel?
    var contentLabel4:UILabel?

    private var weiboPageIndex = 1;
    private var wechatPageIndex = 1;

    private var weiboHaveNextPage = false;
    private var wechatHaveNextPage = false;

    private let pageSize = 20;
    
    private var segSelIndex = 1;
    //var isShow = true;
    private var weiboTableContentOff:CGFloat = CGFloat()
    private var wechatTableContentOff:CGFloat = CGFloat()

    override func shouldAutorotate() -> Bool {
        return true
    }
//    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
//        //        UIInterfaceOrientationIsLandscape(UIInterfaceOrientation.LandscapeLeft) = true
//        return UIInterfaceOrientationMask.Landscape
//    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.Portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //changetitle
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changetitle:", name: "changeBrand", object: nil)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: UIBarButtonItemStyle.Plain, target: self, action: "doShowView");
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()

        switchBtn.backgroundColor = UIColor.colorWith(249, green: 249, blue: 249, alpha: 1);
        brand.text = BrandName;
        brand.textColor = UIColor.whiteColor();
        brand.textAlignment = NSTextAlignment.Center
        brand.frame = CGRectMake(0, 0, 10, 20)
        brand.font = UIFont(name: "", size: 30)
        navigationItem.titleView = brand;
        
        
        setMainScrollView();
        
        set1TableView();
        set2TableView();
        set3TableView();
        set4TableView();
        
        //网络监测
        reachability_listening()
        
        let weiboTab = NSUserDefaults.standardUserDefaults().valueForKey("4");
        let wechatTab = NSUserDefaults.standardUserDefaults().valueForKey("5");

        var weiboStr = "Weibo";
        var wechatStr = "Wechat";
        if let _ = weiboTab {
            ownedType = 0;
            weiboStr = weiboTab as! String;
            if let _ = wechatTab {
                ownedType = 2;
                wechatStr = wechatTab as! String;
            }
        }else{
            ownedType = -1;
            if let _ = wechatTab {
                ownedType = 1;
                wechatStr = wechatTab as! String;
            }
        }
        switchBtn.delegate = self;

        //ownedType = 1;

        //属性配置
        if ownedType == 1 {
            currIndex = 1;
        }else{
            currIndex = 0;
        }
        
        switchBtn.initTitle(weiboStr, rigthText: wechatStr,clickIndex: ownedType)
        if ownedType != 2 {
            mainScrollView.scrollEnabled = false;
        }
        addErrorContent();
        setSearchBar()

        
        
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
    
    
    func changetitle(bean:NSNotification){
        let temp = bean.object as! BrandBean;
        brand.text = temp.name;
        BrandName = temp.name;
        BrandId = temp.id;
        if BrandId > 0 {
            weiboAccounts.removeAll();
            wechatAccounts.removeAll();
            
            weiboHaveNextPage = false;
            wechatHaveNextPage = false;
            
            weiboPageIndex = 1;
            wechatPageIndex = 1;
            self.loadView1Data();
            self.loadView2Data();
            if portraitFlag {
                self.navigationItem.leftBarButtonItem!.title = BrandName;
            }
        }
    
        
    }
    
    func reachabilityChanged(note: NSNotification) {
            
        let reachability = note.object as! Reachability
        if reachability.isReachable() {
            if reachability.isReachableViaWiFi() {
                print("owned Reachable via WiFi")
                event_text = 1001
                setSearchBar()

            } else {
                print("owned Reachable via Cellular")
                event_text = 1001
                setSearchBar()

            }
        } else {
            print("owned Not reachable")
            xwDelay(0.1) { () -> Void in
//                Utils.alert_view(1003)
                self.event_text = 1003
                self.setNetworkError()
            }

        }
    }
    
    func setSearchBar(){
        tableView1.removeNetworkError()
        tableView1.addedSearchBar = false;
        tableView1.addSearchBar();
        tableView1.searchBar?.delegate = self;
        tableView2.removeNetworkError()
        tableView2.addedSearchBar = false;
        tableView2.addSearchBar();
        tableView2.searchBar?.delegate = self;
    }
    
    func setNetworkError(){
        tableView1.removeSearchBar()
        tableView1.addNetworkError()
        tableView2.removeSearchBar()
        tableView2.addNetworkError()
    }
    
    //通知监听触发的方法
    override func receivedRotation(){
        super.receivedRotation();
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
            portraitFlag = false;
            tabBarTitle(1);
            normalView();
        case .PortraitUpsideDown:
            portraitFlag = false;
            tabBarTitle(1);
            normalView();
        case .LandscapeLeft:
            portraitFlag = true;
            tabBarTitle(0);
            portraitView();
            
        case .LandscapeRight:
            portraitFlag = true;
            tabBarTitle(0);
            portraitView();
            
        case .Unknown:
            if !portraitFlag {
                tabBarTitle(1);
            }
            
        default:

            if !portraitFlag {
                tabBarTitle(1);
                
            }
            
        }
        
        print("portraitFlag:\(portraitFlag)");
        //self.tabBarController?.tabBar.hidden
    }
    
    override func tabBarTitle(index:Int){
        super.tabBarTitle(index);
        //if isShow {
            if index == 0 {
                //UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default;

                self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: BrandName, style: UIBarButtonItemStyle.Plain, target: self, action: "doNone");
                navigationItem.leftBarButtonItem?.tintColor = UIColor.grayColor();
                navigationItem.titleView = changeDaysBtn;
                changeDaysBtn.selectedSegmentIndex = segSelIndex;
                changeDaysBtn.addTarget(self, action: "segmentChange:", forControlEvents: UIControlEvents.ValueChanged)
                
            }else{
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: UIBarButtonItemStyle.Plain, target: self, action: "doShowView");
                brand.text = BrandName;
                brand.textColor = UIColor.whiteColor();
                brand.frame = CGRectMake(0, 0, 10, 20)
                brand.font = UIFont(name: "", size: 30)
                navigationItem.titleView = brand;
                navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
            }
        
    }
    
    func doNone(){
        
    }
     //segemnet选择改变事件
     func segmentChange(sender: AnyObject?){
        segSelIndex = changeDaysBtn.selectedSegmentIndex;
        NSNotificationCenter.defaultCenter().postNotificationName("changeDay", object: segSelIndex)

    }
    
    private func setMainScrollView() {
        self.automaticallyAdjustsScrollViewInsets = false
        mainScrollView = UIScrollView(frame: CGRectMake(0, 40, AppWidth, AppHeight - NavigationH - TabBarH))
        //mainScrollView.frame = CGRectMake(0, 0, AppWidth, AppHeight - NavigationH - TabBarH);
        mainScrollView.backgroundColor = theme.SDBackgroundColor
        mainScrollView.contentSize = CGSizeMake(AppWidth * 2.0, 0)
        mainScrollView.showsHorizontalScrollIndicator = false
        mainScrollView.showsVerticalScrollIndicator = false
        mainScrollView.pagingEnabled = true
        mainScrollView.delegate = self
        viewNormal.addSubview(mainScrollView)
    }
    
    private func set1TableView() {
        tableView1 = MainTableView(frame: CGRectMake(0, 0, AppWidth, mainScrollView.height), style: .Grouped, dataSource: self, delegate: self)
        tableView1.addRefreshHeaher();
        let totalCount = Int((AppHeight - NavigationH - TabBarH - 40) / 80);
        tableView1.minTotalCount = totalCount;
        tableView1.addLoadFooter();
        tableView1.loadDataDelegate = self;
        tableView1.hiddenSearchBar(false);
        mainScrollView.addSubview(tableView1)
        
    }
    
    private func set2TableView() {
        tableView2 = MainTableView(frame: CGRectMake(AppWidth, 0, AppWidth, mainScrollView.height), style: .Grouped, dataSource: self, delegate: self)
        tableView2.addRefreshHeaher();
        let totalCount = Int((AppHeight - NavigationH - TabBarH - 40) / 80);
        tableView2.minTotalCount = totalCount;
        tableView2.addLoadFooter();
        tableView2.loadDataDelegate = self;
        mainScrollView.addSubview(tableView2)

    }
    
    
    private func set3TableView() {
        
        if tableView3 == nil {
            tableView3 = MainTableView(frame: CGRectMake(0, 0, AppHeight, AppWidth), style: .Plain, dataSource: self, delegate: self)
            tableView3.addRefreshHeaher();
            
            let totalCount = Int((AppWidth - NavigationH) / 80);
            tableView3.minTotalCount = totalCount;
            tableView3.addLoadFooter();
            tableView3.loadDataDelegate = self;
            
            //contentlabel
            contentLabel3 = UILabel()
            contentLabel3?.frame.size = CGSize(width: 200, height: 44)
            contentLabel3?.textAlignment = NSTextAlignment.Center
            contentLabel3?.center = CGPoint(x: AppHeight/2, y: AppWidth/2 - 100)
            contentLabel3?.text = "No content"
            contentLabel3?.font = UIFont(name: "Helvetica", size: 16)
            contentLabel3?.textColor = UIColor.lightGrayColor()
            contentLabel3?.hidden = true
            tableView3.addSubview(contentLabel3!)
            
            //event_text 判断
            if event_text == 1001{
                viewPortrait.addSubview(tableView3)
            }else if(event_text == 1003){
                landsNetError()
            }
        }
        if tableView4 != nil {
            tableView4.frame = CGRectMake(0, 0, 0, 0);
        }
        tableView3.frame = CGRectMake(0, 0, AppHeight, AppWidth);
        
    }
    
    private func set4TableView() {
        
        if tableView4 == nil {
            tableView4 = MainTableView(frame: CGRectMake(0, 0, AppHeight, AppWidth), style: .Plain, dataSource: self, delegate: self)
            tableView4.addRefreshHeaher();
            let totalCount = Int((AppWidth - NavigationH) / 80);
            tableView4.minTotalCount = totalCount;
            tableView4.addLoadFooter();
            tableView4.loadDataDelegate = self;
            
            //contentlabel
            contentLabel4 = UILabel()
            contentLabel4?.frame.size = CGSize(width: 200, height: 44)
            contentLabel4?.textAlignment = NSTextAlignment.Center
            contentLabel4?.center = CGPoint(x: AppHeight/2, y: AppWidth/2 - 100)
            contentLabel4?.text = "No content"
            contentLabel4?.font = UIFont(name: "Helvetica", size: 16)
            contentLabel4?.textColor = UIColor.lightGrayColor()
            contentLabel4?.hidden = true
            tableView4.addSubview(contentLabel4!)
            

            //event_text 判断
            if event_text == 1001{
                viewPortrait.addSubview(tableView4)
            }else if(event_text == 1003){
                landsNetError()
            }
        }
        if tableView3 != nil {
            tableView3.frame = CGRectMake(0, 0, 0, 0);
        }
        tableView4.frame = CGRectMake(0, 0, AppHeight, AppWidth);
    }
    
    func landsNetError(){
        loadImg = UIButton(frame: CGRectMake(AppHeight/2 - 40, 50, 80, 80))
        loadImg?.setBackgroundImage(UIImage(named: "load"), forState: .Normal)
        loadImg!.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.TouchUpInside)
        loadLabel = UILabel(frame: CGRect(x: AppHeight/2 - 90, y: 150, width: 200, height: 44))
        loadLabel?.text = "Network error,tap to reload"
        loadLabel?.font = UIFont(name: "Helvetica", size: 16)
        loadLabel?.textColor = UIColor.lightGrayColor()
        viewPortrait.addSubview(loadImg!)
        viewPortrait.addSubview(loadLabel!)
    }
    
    func removelandsNetError(){
        loadImg?.removeFromSuperview()
        loadLabel?.removeFromSuperview()
    }
    
    func portraitView(){
        NSNotificationCenter.defaultCenter().postNotificationName("changeDay", object: segSelIndex)
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor();
        if currIndex == 0 {
            set3TableView();
            endRefreshing(tableView3);
        }else{
            set4TableView();
            endRefreshing(tableView4);
        }
        
    }
    
    func normalView(){
        switchBtn.changeBtnStyleIndex(currIndex)
        self.navigationController?.navigationBar.barTintColor = theme.SDNativeBackgroundColor;

        if currIndex == 0 {
            //set3TableView();
            endRefreshing(tableView1);
        }else{
            //set4TableView();
            endRefreshing(tableView2);
        }
    }
    
    func endRefreshing(table:MainTableView){

        
        table.reloadData();
        table.headerView?.endRefreshing();
        table.footerView?.endRefreshing();

    }
    
    func loadView1Data(){
        
        if ownedType == -1 || ownedType == 1{
            
            self.endRefreshing(self.tableView1);
            self.endRefreshing(self.tableView3);
            
            return;
        }
        
        print("初始化加载数据1");
        self.pleaseWait()

        //数据链接，解析
        let url = rootURL + "brand/getBrandService.cic";
        let parameters = [
            "brandId": BrandId,
            "serviceType":1,
            "pageNum":weiboPageIndex,
            "pageSize":pageSize,
            "userName":weiboName
        ]
        Alamofire.request(.GET, url,parameters: parameters as? [String : AnyObject]).responseJSON{
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
                        let bean = AccountBean()
                        bean.name = temp.objectForKey("mediaUserName") as! String;
                        bean.imageurl = temp.objectForKey("mediaUserImg") as! String
                        bean.desc = temp.objectForKey("mediaUserDesc") as! String
                        bean.address = temp.objectForKey("mediaUserLocation") as! String
                        bean.id = temp.objectForKey("mediaUserId") as! Int;
                        bean.mediaUserType = temp.objectForKey("mediaUserType") as! Int;
                        bean.clientId = temp.objectForKey("iwmcClientid") as! Int;

                        self.weiboAccounts.append(bean);
                    }
                    // 数据还有一页
                    if self.pageSize == jsonObj.count {
                        self.weiboHaveNextPage = true;
                    }else{
                        self.weiboHaveNextPage = false
                    }
                    self.endRefreshing(self.tableView1);
                    self.endRefreshing(self.tableView3);
                }
            }else{
                if self.event_text == 1003{
                }else{
//                    Utils.alert_view(1011);
                    print("Connection error")
                }
            }
            self.clearAllNotice();
        }

    }
    
    func loadView2Data(){
        
        if ownedType == 0 || ownedType == -1{
            
            self.endRefreshing(self.tableView2);
            self.endRefreshing(self.tableView4);
            
            return;
        }
        
        print("初始化加载数据2");
//        if event_text != 1001{
//            Utils.alert_view(self.event_text);
//            self.endRefreshing(self.tableView2);
//            self.endRefreshing(self.tableView4);
//            return;
//        }
        self.pleaseWait()

        //数据链接，解析
        let url = rootURL + "brand/getBrandService.cic";
        let parameters = [
            "brandId": BrandId,
            "serviceType":2,
            "pageNum":wechatPageIndex,
            "pageSize":pageSize,
            "userName":wechatName
        ]
        Alamofire.request(.GET, url,parameters: parameters as? [String : AnyObject]).responseJSON{
            data in
            if(data.result.isSuccess){
                let json = data.result.value!;
                if (!NSJSONSerialization.isValidJSONObject(json)) {
                    Utils.alert_view(1008);
                }else{
                    let jsonObj = Utils.stringToJson(json);
                    for(var i = 0 ; i < jsonObj.count; i++){
                        let temp = jsonObj[i]
                        let webean = AccountBean()
                        webean.name = temp.objectForKey("mediaUserName") as! String;
                        webean.address = temp.objectForKey("mediaUserDateSince") as! String
                        webean.id = temp.objectForKey("mediaUserId") as! Int;
                        webean.clientId = temp.objectForKey("iwmcClientid") as! Int;
                        self.wechatAccounts.append(webean);
                    }
                    
                    // 数据还有一页
                    if self.pageSize == jsonObj.count {
                        self.wechatHaveNextPage = true;
                    }else{
                        self.wechatHaveNextPage = false
                    }
                    
                    self.endRefreshing(self.tableView2);
                    self.endRefreshing(self.tableView4);

                }
            }else{
                if self.event_text == 1003{
                }else{
//                    Utils.alert_view(1011);
                    print("Connection error")
                }            }
            self.clearAllNotice();
        }
    }

    func upPullLoadData(){
        print("下拉刷新");
        
        var table:MainTableView = self.tableView1;
        if self.currIndex == 0{
            weiboPageIndex = 1
            weiboHaveNextPage = false;
            self.weiboAccounts.removeAll();
            loadView1Data()
            removelandsNetError()
            if self.portraitFlag {
                table = self.tableView3;
                if event_text == 1003{
                    landsNetError()
                }
            }else{
                table = self.tableView1;
            }

        }else{
            wechatPageIndex = 1;
            wechatHaveNextPage = false;
            self.wechatAccounts.removeAll();
            loadView2Data()
            removelandsNetError()
            if self.portraitFlag {
                table = self.tableView4;
                if event_text == 1003{
                    landsNetError()
                }
            }else{
                table = self.tableView2;
            }
        }
        
        table.reloadData();
        table.headerView?.endRefreshing()
        
    }
    
    func refresh(){
        upPullLoadData();
    }
    
    func loadMore(){
        print("上拉加载更多");
        var table:MainTableView = self.tableView1;
        if self.currIndex == 0{
            if self.portraitFlag {
                table = self.tableView3;
            }else{
                table = self.tableView1;
            }
            
            if weiboHaveNextPage {
                self.weiboPageIndex++;
                loadView1Data()
                //table.footerView?.endRefreshing()
                
            }
            
        }else{
            if self.portraitFlag {
                table = self.tableView4;
            }else{
                table = self.tableView2;
            }
            if wechatHaveNextPage {
                self.wechatPageIndex++;
                loadView2Data()
                //table.footerView?.endRefreshing()
                
            }
            
        }
        
    }
    
    
    
    func addErrorContent(){
        contentLabel1 = UILabel()
        contentLabel1?.frame.size = CGSize(width: 200, height: 44)
        contentLabel1?.textAlignment = NSTextAlignment.Center
        contentLabel1?.center = CGPoint(x: AppWidth/2, y: AppHeight/2 - 100)
        contentLabel1?.text = "No content"
        contentLabel1?.font = UIFont(name: "Helvetica", size: 16)
        contentLabel1?.textColor = UIColor.lightGrayColor()
        contentLabel1?.hidden = true
        contentLabel2 = UILabel()
        contentLabel2?.frame.size = CGSize(width: 200, height: 44)
        contentLabel2?.textAlignment = NSTextAlignment.Center
        contentLabel2?.center = CGPoint(x: AppWidth/2, y: AppHeight/2 - 100)
        contentLabel2?.text = "No content"
        contentLabel2?.font = UIFont(name: "Helvetica", size: 16)
        contentLabel2?.textColor = UIColor.lightGrayColor()
        contentLabel2?.hidden = true

        tableView1.addSubview(contentLabel1!)
        tableView2.addSubview(contentLabel2!)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        if weiboTableContentOff > 100{
            tableView1.contentOffset.y = weiboTableContentOff
        }
        if wechatTableContentOff > 100{
        tableView2.contentOffset.y = wechatTableContentOff
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doShowView() {
        
        if weiboName != "" || wechatName != "" {
            tableView1.clearSearchBar()
            tableView2.clearSearchBar()
            weiboName = ""
            wechatName = ""
        }
        
        
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil);
        let one = storyBoard.instantiateViewControllerWithIdentifier("BrandList") as! BrandList;
        one.intentDelegate = self;
        let nav = UINavigationController(rootViewController: one);
        self.presentViewController(nav, animated: true, completion: nil)
//        stopListening()
        
        
        
    }
    
    func doubleTextView(doubleTextView: DoubleTextView, didClickBtn btn: UIButton, forIndex index: Int){
        //print("forIndex:\(String(index))");
        currIndex = index;
        mainScrollView.setContentOffset(CGPointMake(AppWidth * CGFloat(index), 0), animated: true)
    }
    
    func stopListening(){
        if reachability != nil{
        reachability.stopNotifier()
        reachability = nil;
            NSNotificationCenter.defaultCenter().removeObserver(self, name: ReachabilityChangedNotification, object: nil);
        }
    }
    
}



/// MARK: UImainScrollViewDelegate
extension OwnedPage: UIScrollViewDelegate {
    
    // MARK: - UImainScrollViewDelegate 监听mainScrollView的滚动事件
    func scrollViewDidEndDecelerating(mainScrollView: UIScrollView) {
        if mainScrollView == self.mainScrollView {
                let index = Int(mainScrollView.contentOffset.x / (AppWidth))
                //print("tab index:\(index)");
                self.currIndex = index;
                switchBtn.changeBtnStyleIndex(index)

            
        }
    }
    
    
    
}

///MARK:- UITableViewDelegate和UITableViewDataSource
extension OwnedPage: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == tableView1 {
            if event_text == 1003{
            }else{
                if(weiboAccounts.count == 0){
                    contentLabel1?.hidden = false
                }else{
                    contentLabel1?.hidden = true
                }
            }
            return weiboAccounts.count;
        }
        
        if let _ = tableView3 {
            if tableView == tableView3 {
                if event_text == 1003{
                    tableView3.separatorStyle = UITableViewCellSeparatorStyle.None
                }else{
                    if(weiboAccounts.count == 0){
                        contentLabel3?.hidden = false
                        tableView3.separatorStyle = UITableViewCellSeparatorStyle.None
                    }else{
                        contentLabel3?.hidden = true
                        tableView3.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
                    }
                }
                return weiboAccounts.count;
            }
            
        }
        
        if tableView == tableView2{
            if event_text == 1003{
            }else{
                if(wechatAccounts.count == 0){
                    contentLabel2?.hidden = false
                }else{
                    contentLabel2?.hidden = true
                }
            }
            return wechatAccounts.count;
        }
        
        if let _ = tableView4 {
            if tableView == tableView4 {
                if event_text == 1003{
                    tableView3.separatorStyle = UITableViewCellSeparatorStyle.None
                }else{
                    if(wechatAccounts.count == 0){
                        contentLabel4?.hidden = false
                        tableView4.separatorStyle = UITableViewCellSeparatorStyle.None
                    }else{
                        contentLabel4?.hidden = true
                        tableView4.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
                    }
                }
                return wechatAccounts.count;
            }
            
        }
        
        return 0;
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 80;
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView == tableView1 { 
            
            let identifier = "themeCell"
            
            var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? WeiboTableCell
            if cell == nil {
                cell = NSBundle.mainBundle().loadNibNamed("WeiboTableCell", owner: nil, options: nil).last as? WeiboTableCell
            }
            let bean = weiboAccounts[indexPath.row];
            cell!.model = bean;
            
            return cell!;
            
        }
        
        if let _ = tableView3 {
            
            if tableView == tableView3 {
                
                let identifier = "themeCell3"
                
                var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? WeiboTableCell
                if cell == nil {
                    cell = NSBundle.mainBundle().loadNibNamed("WeiboTableCell", owner: nil, options: nil).last as? WeiboTableCell
                }
                if !weiboAccounts.isEmpty {
                    let bean = weiboAccounts[indexPath.row];
                    cell!.model = bean;
                    var day_ago = 7;
                    switch segSelIndex {
                    case 0 :
                        day_ago = 1
                    case 1 :
                        day_ago = 7
                    case 2 :
                        day_ago = 14
                    case 3 :
                        day_ago = 30
                    default :
                        day_ago = 7
                    }
                    //print("loadtable3");
                    
                    cell!.loadZhibiao(day_ago,mediaUserId: bean.id);
                }
                
                return cell!;
                
            }
        }
        
        
        if tableView == tableView2  { // 美辑TableView
            
            let identifier = "themeCell2"
            
            var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? WechatTableCell
            if cell == nil {
                cell = NSBundle.mainBundle().loadNibNamed("WechatTableCell", owner: nil, options: nil).last as? WechatTableCell
            }
            if let _ = cell {
                let bean = wechatAccounts[indexPath.row];
                cell!.model = bean;

                return cell!;
            }
            
        }
        
        
        if let _ = tableView4 {
            
            if tableView == tableView4  { // 美辑TableView
                
                let identifier = "themeCell4"
                
                var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? WechatTableCell
                if cell == nil {
                    cell = NSBundle.mainBundle().loadNibNamed("WechatTableCell", owner: nil, options: nil).last as? WechatTableCell
                }
                
                if !wechatAccounts.isEmpty {
                    let bean = wechatAccounts[indexPath.row];
                    cell!.model = bean;
                    var day_ago = 7;
                    switch segSelIndex {
                    case 0 :
                        day_ago = 1
                    case 1 :
                        day_ago = 7
                    case 2 :
                        day_ago = 14
                    case 3 :
                        day_ago = 30
                    default :
                        day_ago = 7
                    }
                    
                    cell!.loadWechat(day_ago,wechatUserId: bean.id);
                }
                
                return cell!;
                
            }
        }
        
        return UITableViewCell()
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        xwDelay(0.2) { () -> Void in
        if let _ = self.tableView1 {
            if  tableView == self.tableView1 {
                let bean = self.weiboAccounts[indexPath.row];
                self.doShowWeibo(bean);

            }
        }
        if let _ = self.tableView2{
            if tableView == self.tableView2 {
                let bean = self.wechatAccounts[indexPath.row];
                self.doShowWechat(bean)
            }
        }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    func doShowWeibo(bean:AccountBean){
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil);
        let weibo = storyBoard.instantiateViewControllerWithIdentifier("WeiboDetail") as! WeiboDetail;
        weibo.bean = bean;
        let nav = UINavigationController(rootViewController: weibo);
        self.presentViewController(nav, animated: true, completion: nil)
        intentDelegate?.getIntentValue((BrandName));
//        stopListening()

    }
    
    func doShowWechat(bean:AccountBean){
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil);
        let wechat = storyBoard.instantiateViewControllerWithIdentifier("WechatInfo") as! WechatInfo;
        wechat.bean = bean;
        let nav = UINavigationController(rootViewController: wechat);
        self.presentViewController(nav, animated: true, completion: nil)
//        stopListening()
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath){
        selectRow = indexPath;
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == tableView1{
//            print(tableView1.contentOffset.y)
            weiboTableContentOff = tableView1.contentOffset.y
        }
        if scrollView == tableView2{
            wechatTableContentOff = tableView2.contentOffset.y
        }
    }
    
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        if currIndex == 0 {
            print("点击了第一个searchBar")

        }else{
            print("点击了第二个searchBar")

        }
        
        return true;
    }
    // return NO to not become first responder
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar){
        print("开始编辑")
        
    }// called when text starts editing
    
    
    // 输入框内容改变触发事件
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print("过滤：\(searchText)");
        
        if currIndex == 0 {
            weiboName = searchText;
        }else{
            wechatName = searchText;
        }
        
        // 开始搜索所有数据
        if searchText == "" {
            upPullLoadData();
            searchBar.resignFirstResponder();

        }
    }
    
    // 书签按钮触发事件
    func searchBarBookmarkButtonClicked(searchBar: UISearchBar) {
        print("搜索历史")
    }
    
    // 取消按钮触发事件
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        print("取消搜索")
        searchBar.resignFirstResponder();

    }
    
    // 搜索触发事件
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("开始搜索")
        searchBar.resignFirstResponder();
        
        upPullLoadData();
    }
    
    func getIntentValue(value:AnyObject){
        BrandName = value as! String;
        let label = self.navigationItem.titleView as! UILabel;
        label.text = BrandName;
        
    }
    
    
}