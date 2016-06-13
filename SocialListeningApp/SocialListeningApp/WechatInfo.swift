//
//  WechatInfo.swift
//  SocialListeningApp
//
//  Created by chencharles on 16/2/22.
//  Copyright © 2016年 cicdata. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


class WechatInfo:NormalViewController,UIScrollViewDelegate{

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var baseinfo_view: UIView!
    
    @IBOutlet weak var accountView: UIView!
    
    @IBOutlet weak var accountScroll: UIScrollView!
    
    @IBOutlet weak var accountPageControl: UIPageControl!
    
    @IBOutlet weak var fansView: UIView!
    
    @IBOutlet weak var fansScroll: UIScrollView!
    
    @IBOutlet weak var fansPageControl: UIPageControl!
    
    var seg: UISegmentedControl!

    @IBOutlet weak var weichatImage: UIImageView!
    
    
    @IBOutlet weak var mainView: UIView!
    
    
    let view1tableview3 = UITableView()
//    let view2tableview5 = UITableView()

    
    var oldY:CGFloat = 0.0;

    var newY:CGFloat = 0.0;
    
    private var lastOffsetY: CGFloat = 155
    
    /*
    1001 normal
    1002 return null
    1003 network error
    */
    private var event_text = 1001
    var loadImg:UIButton?
    var loadLabel:UILabel?
    let navtitle:UILabel? = UILabel()


    @IBOutlet weak var datasince_label: UILabel!
    
    @IBOutlet weak var hotfans_label: UILabel!
    
    @IBOutlet weak var hotacticles_label: UILabel!
    
    @IBOutlet weak var avgreads_label: UILabel!
    
    var bean = AccountBean();
    var tablechartbean = [TableChartBean]()
    private var time1 = "";
    private var time2 = "";

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
    
    /// MARK:- 方法
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weichatImage.layer.cornerRadius = 35;
        weichatImage.layer.masksToBounds = true;
        
        time1 = Utils.getDateString(-7);
        time2 = Utils.getDateString(-1);
        reachability_listening()
        
        //navigationbar
        navtitle!.text = bean.name
        navtitle!.textColor = UIColor.blackColor()
        navtitle!.frame = CGRectMake(0, 0, 10, 20)
        navigationItem.titleView = navtitle
        
        addBorder(baseinfo_view)
        
        self.automaticallyAdjustsScrollViewInsets = false
        scrollView.showsHorizontalScrollIndicator=false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical=true
        scrollView.delegate = self;
        scrollView.indicatorStyle = UIScrollViewIndicatorStyle.Default


        addBorder(accountView);
        addBorder(fansView);
//        oldY = seg.frame.origin.y;
        newY = oldY;
        
        self.datasince_label.text = self.bean.address;

        
        showAccountCharts();
        showFansCharts();
        loadWechatBaseInfo()
        segmented_info()
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
    
    
    func segmented_info(){
        
        let appsArray:[String] = ["1 Day","7 Days","14 Days","30 Days"]
        seg = UISegmentedControl(items: appsArray)
        seg.frame = CGRectMake(20, 155, AppWidth - 40, 30)
        //        print("segmented size:\(segmented_control.frame)");
        seg.selectedSegmentIndex = 1
        seg.addTarget(self, action: "segmentedAction:", forControlEvents: UIControlEvents.ValueChanged)
        mainView.addSubview(seg)
    }
    
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable() {
        if reachability.isReachableViaWiFi() {
            print("Wechat Reachable via WiFi")
            event_text = 1001
        } else {
            print("Wechat Reachable via Cellular")
            event_text = 1001
            }
        } else {
            print("Wechat Not reachable")
            xwDelay(0.1) { () -> Void in
//                Utils.alert_view(1003)
                if self.tablechartbean.isEmpty {
                self.addErrorView()
                }
            }
        event_text = 1003
        }
    }
    
    func loadChartTableViewData(){
        //192.168.4.172:16007/SocialListeningServer/wechatAccount/showWechatTop5Article.cic?dayId=7&wechatUserId=166&beginTime=2016-02-25&endTime=2016-03-02&statType=day&sign=1&clientId=101077
        
        
        //数据链接，解析
        let url = rootURL + "wechatAccount/showWechatTop5Article.cic";
        let parameters = [
            "dayId": "",
            "wechatUserId": bean.id,
            "beginTime":time1,
            "endTime":time2,
            "statType":"day",
            "sign":1,
            "clientId":bean.clientId
            
        ]
//        print(url);
//        print(parameters);
        Alamofire.request(.GET, url,parameters: parameters as? [String : AnyObject]).responseJSON{
            data in
            
//            print(data)

            if(data.result.isSuccess){
                //                print(data)
                let json = data.result.value!;
                if (!NSJSONSerialization.isValidJSONObject(json)) {
//                    Utils.alert_view(1008);
                }else{
                    let jsonObj = Utils.stringToJson(json);
                    
                    self.tablechartbean.removeAll();
                    
                    for(var i = 0 ; i < jsonObj.count; i++){
                        let temp = jsonObj[i]
                        let tabean = TableChartBean()
                        tabean.content = temp.objectForKey("title") as! String;
                        tabean.reads = temp.objectForKey("intPageReadCount") as! Int
                        tabean.shares = temp.objectForKey("shareCount") as! Int;
                        print(temp.objectForKey("refDate"))
                        let refDate = temp.objectForKey("refDate") as! Double;
                        tabean.pubDate = Utils.getDateStringByMils(refDate, formatStr: "yyyy-MM-dd");
                        
                        self.tablechartbean.append(tabean);
                    }
                    
                    self.view1tableview3.reloadData();
//                    self.view2tableview5.reloadData();
                    
                }
            }else{
                if self.event_text == 1003{
                    
                }else{
                    print("E");
//                    Utils.alert_view(1011);
                }
            }
        }
    }
    
    
    
    func loadWechatBaseInfo(){
        //数据链接，解析
        let url = rootURL + "wechatAccount/findWechatPercentage.cic";
        var dateSince = bean.address
        dateSince = dateSince.stringByReplacingOccurrencesOfString("/", withString: "-", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        let parameters = [
            //"dayId": 0,
            "beginTime":dateSince,
            "endTime":time2,
            "wechatUserId": bean.id
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
//                    print(jsonObj)
                    var tot_articles:Double = 1.0
                    var avg_reads:Double = 1.0
                    for(var i = 0 ; i < jsonObj.count; i++){
                        let temp = jsonObj[i]
                        let wechatId = temp.objectForKey("id") as! String;
                        let val = temp.objectForKey("value1") as! String;
                        if(wechatId == "CUMULATE_USER"){
                            self.hotfans_label.text = Utils.StringChanged(val)
                        }else if(wechatId == "MSGID"){
                            self.hotacticles_label.text = Utils.StringChanged(val)
                            tot_articles = Double(val)!
                            
                        }else if(wechatId == "ORI_PAGEREAD_COUNT"){
                            avg_reads = Double(val)!
                        }

                    }
                    
                    var calculators:Double = 0;
                    if tot_articles > 0 {
                        calculators = avg_reads / tot_articles;
                    }
                    calculators = ceil(calculators);
                    let dou = Int(calculators);
                    //let dou = NSString(format: "%.0f", calculators)
//                    print(dou)
                    if tot_articles == 0 {
                        self.avgreads_label.text = "0"
                    }else{
                        self.avgreads_label.text = Utils.StringChanged(String(dou))
                    }
//                    print(calculators)
                    //self.datasince_label.text = self.bean.address;

                }
            }else{
                if self.event_text == 1003{
                }else{
                    print("A");
                        Utils.alert_view(1011);
                }
            }
        }
        loadChartTableViewData()
    }
    
    func addErrorView(){
        scrollView.hidden = true
        loadImg = UIButton()
        loadImg?.frame.size = CGSize(width: 80, height: 80)
        loadImg?.center = CGPoint(x: AppWidth / 2, y: AppHeight/3 - 50)
        loadImg?.setBackgroundImage(UIImage(named: "load"), forState: .Normal)
        loadImg!.addTarget(self, action: "reloadEvent", forControlEvents: UIControlEvents.TouchUpInside)
        loadLabel = UILabel()
        loadLabel?.frame.size = CGSize(width: 200, height: 44)
        loadLabel?.center = CGPoint(x: AppWidth / 2, y: AppHeight / 2 - 80)
        loadLabel?.textAlignment = NSTextAlignment.Center
        loadLabel?.text = "Network error,tap to reload"
        loadLabel?.font = UIFont(name: "Helvetica", size: 16)
        loadLabel?.textColor = UIColor.lightGrayColor()
        self.view.addSubview(loadImg!)
        self.view.addSubview(loadLabel!)
    }
    
    
    func reloadEvent(){
//        showAccountCharts();
//        showFansCharts();
        loadWechatBaseInfo()
        loadAccountChartsData()
        loadFansChartsData()
    }
    
    func removeNetError(){
        loadImg?.removeFromSuperview()
        loadLabel?.removeFromSuperview()
        scrollView.hidden = false
    }
    

    
    func addBorder(view:UIView){
        view.layer.borderColor = UIColor.lightGrayColor().CGColor;
        view.layer.borderWidth = 0.5;
    }
    
    func loadBarAndLineChartViewData(chart:ChartViewInterface){
        //192.168.4.172:16007/SocialListeningServer/wechatAccount/showGraphicStatistics.cic?dayId=7&wechatUserId=166&beginTime=2016-02-25&endTime=2016-03-02&statType=day&sign=1&clientId=101077
        
        //数据链接
        let url = rootURL + "wechatAccount/showGraphicStatistics.cic";
        
        let parameters = [
            //"dayId": "14",
            "wechatUserId":bean.id,
            "beginTime":time1,
            "endTime": time2,
            "statType": "day",
            "sign": "1",
            "clientId": bean.clientId

        ]
        Alamofire.request(.GET, url,parameters: parameters as? [String : AnyObject]).responseJSON{
            data in
            //print(data)
            if(data.result.isSuccess){
                let json = data.result.value!;
                chart.setData(json,a: 0)
            }else{
                if self.event_text == 1003{
                }else{
                    print("B");

//                    Utils.alert_view(1011);
                }
            }
        }
    }
    
    func loadAreasChartViewData(chart:ChartViewInterface,method:String){
        //192.168.4.172:16007/SocialListeningServer/wechatAccount/showWechatGraphicShareArea.cic?dayId=7&wechatUserId=166&beginTime=2016-02-25&endTime=2016-03-02&statType=day&sign=1&clientId=101077
        
        //数据链接
        let url = rootURL + "wechatAccount/" + method;
        
        let parameters = [
            //"dayId": "7",
            "wechatUserId":bean.id,
            "beginTime":time1,
            "endTime": time2,
            "statType": "day",
            "sign": "1",
            "clientId": bean.clientId
            
        ]
        Alamofire.request(.GET, url,parameters: parameters as? [String : AnyObject]).responseJSON{
            data in
            //print(data)
            if(data.result.isSuccess){
                let json = data.result.value!;
                chart.setData(json,a: 0)
            }else{
                if self.event_text == 1003{
                }else{
                    print("C");

//                    Utils.alert_view(1011);
                }
            }
        }
    }
    
    func loadStackedBarsViewData(chart:ChartViewInterface,method:String){
        ////192.168.4.172:16007/SocialListeningServer/wechatAccount/showNewFansGenderOrCity.cic?dayId=7&wechatUserId=166&beginTime=2016-02-25&endTime=2016-03-02&statType=day&sign=1&clientId=101077
        
        //数据链接
        let url = rootURL + "wechatAccount/" + method;
        
        let parameters = [
            //"dayId": "7",
            "wechatUserId":bean.id,
            "beginTime":time1,
            "endTime": time2,
            "statType": "day",
            "sign": "1",
            "clientId": bean.clientId
            
        ]
        Alamofire.request(.GET, url,parameters: parameters as? [String : AnyObject]).responseJSON{
            data in
           // print(data)
            self.clearAllNotice();
            if(data.result.isSuccess){
                let json = data.result.value!;
                chart.setData(json,a: 0)
            }else{
                if self.event_text == 1003{
                }else{
                    print("D");

//                    Utils.alert_view(1011);
                }
            }
        }
    }
    
    let view1chart1 = BarAndLinesChartViewTool();
    let view1chart2 = AreasChartViewTool();
    
    func showAccountCharts(){

        view1chart2.labelText = "Articles’ Sharing Scenes";
        //关闭滚动条显示
        accountScroll.showsHorizontalScrollIndicator = false
        accountScroll.showsVerticalScrollIndicator = false
        accountScroll.scrollsToTop = false
        accountScroll.bounces=false
        
        //协议代理，在本类中处理滚动事件
        accountScroll.delegate = self
        //滚动时只能停留到某一页
        accountScroll.pagingEnabled = true
        
        let width = AppWidth - 22;

        //设置scrollView的内容总尺寸
        accountScroll.contentSize = CGSizeMake(
            CGFloat(width) * CGFloat(3),
            CGRectGetHeight(self.accountScroll.bounds)
        )
        let size = accountScroll.bounds.size;
//        addBorder(view1tableview3);
//        addBorder(view1chart2);
//        addBorder(view1chart1);
        
        view1tableview3.delegate = self
        view1tableview3.dataSource = self
        

        
        view1chart1.frame = CGRect(x: CGFloat(0) * (width), y: 20,
            width: width, height: size.height - 20);
        let view1chart1_label = UILabel()
        view1chart1_label.font = UIFont.systemFontOfSize(14)

        view1chart1_label.frame = CGRect(x: CGFloat(0) * (width) + 5, y: 0,width: width, height: 20)
        view1chart1_label.text = "Account engagement analysis"
        
        view1chart2.frame = CGRect(x: CGFloat(1) * (width), y: 20,
            width: width, height: size.height - 20);
        
        let view1chart2_label = UILabel()
        view1chart2_label.font = UIFont.systemFontOfSize(14)

        view1chart2_label.frame = CGRect(x: CGFloat(1) * (width) + 5, y: 0,width: width, height: 20)
        view1chart2_label.text = "Articles’ sharing scenes"
        
        view1tableview3.frame = CGRect(x: CGFloat(2) * (width), y: 20,
            width: width, height: size.height - 20);
        view1tableview3.bounces = false
        
        let view1tableview3_label = UILabel()
        view1tableview3_label.font = UIFont.systemFontOfSize(14)

        view1tableview3_label.frame = CGRect(x: CGFloat(2) * (width) + 5, y: 0,width: width, height: 20)
        view1tableview3_label.text = "Top 5 articles"
        
        loadAccountChartsData();
        
        
        accountScroll.addSubview(view1chart1)
        accountScroll.addSubview(view1chart1_label)

        accountScroll.addSubview(view1chart2)
        accountScroll.addSubview(view1chart2_label)

        accountScroll.addSubview(view1tableview3)
        accountScroll.addSubview(view1tableview3_label)

        
        accountPageControl.numberOfPages = 3;
        accountPageControl.currentPage = 0
        //设置页控件点击事件
        accountPageControl.addTarget(self, action: "pageChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
    }
    

    func loadAccountChartsData(){
        if event_text != 1001 {
            Utils.alert_view(self.event_text)
//            print(event_text)
            return
        }
        removeNetError()
        self.pleaseWait();

        loadBarAndLineChartViewData(view1chart1)
        loadAreasChartViewData(view1chart2,method: "showWechatGraphicShareArea.cic")

    }
    
    let view2chart1 = StackedBarsViewTool()
    let view2chart2 = AreasChartViewTool()
    let view2chart3 = StackedBarsViewTool()
    let view2chart4 = AreasChartViewTool()
    
    func showFansCharts(){
        
        
        view2chart1.labelText = "New fans demographics";
        view2chart2.labelText = "New fans acquisition channels";
        view2chart3.labelText = "Aggregated fans demographics";
        view2chart4.labelText = "Aggregated fans acquisition channels";

        //关闭滚动条显示
        fansScroll.showsHorizontalScrollIndicator = false
        fansScroll.showsVerticalScrollIndicator = false
        fansScroll.scrollsToTop = false
        fansScroll.bounces=false
        
        //协议代理，在本类中处理滚动事件
        fansScroll.delegate = self
        //滚动时只能停留到某一页
        fansScroll.pagingEnabled = true
        
        let width = AppWidth - 22;
        
        //设置scrollView的内容总尺寸
        fansScroll.contentSize = CGSizeMake(
            CGFloat(width) * CGFloat(4),
            CGRectGetHeight(self.fansScroll.bounds)
        )
        let size = fansScroll.bounds.size;
        
        

//        view2tableview5.delegate = self
//        view2tableview5.dataSource = self


//        addBorder(view2chart1);
//        addBorder(view2chart2);
//        addBorder(view2chart3);
//        addBorder(view2chart4);
//        addBorder(view2tableview5)
        
        
        view2chart1.frame = CGRect(x: CGFloat(0) * (width), y: 20,width: width, height:size.height - 20);
        let view2chart1_label = UILabel()
        view2chart1_label.font = UIFont.systemFontOfSize(14)

        view2chart1_label.frame = CGRect(x: CGFloat(0) * (width) + 5, y: 0,width: width, height: 20)
        view2chart1_label.text = "New fans demographics"
        view2chart2.frame = CGRect(x: CGFloat(1) * (width), y: 20,width: width, height: size.height - 20)
        let view2chart2_label = UILabel()
        view2chart2_label.font = UIFont.systemFontOfSize(14)

        view2chart2_label.frame = CGRect(x: CGFloat(1) * (width) + 5, y: 0,width: width, height: 20)
        view2chart2_label.text = "New fans acquisition channels"
        view2chart3.frame = CGRect(x: CGFloat(2) * (width), y: 20,width: width, height:size.height - 20);
        let view2chart3_label = UILabel()
        view2chart3_label.font = UIFont.systemFontOfSize(14)

        view2chart3_label.frame = CGRect(x: CGFloat(2) * (width) + 5, y: 0,width: width, height: 20)
        view2chart3_label.text = "Aggregated fans demographics"
        view2chart4.frame = CGRect(x: CGFloat(3) * (width), y: 20,width: width, height:size.height - 20);
        let view2chart4_label = UILabel()
        view2chart4_label.font = UIFont.systemFontOfSize(14)

        view2chart4_label.frame = CGRect(x: CGFloat(3) * (width) + 5, y: 0,width: width, height: 20)
        view2chart4_label.text = "Aggregated fans acquisition channels"
        loadFansChartsData();

        
        fansScroll.addSubview(view2chart1)
        fansScroll.addSubview(view2chart1_label)

        fansScroll.addSubview(view2chart2)
        fansScroll.addSubview(view2chart2_label)

        fansScroll.addSubview(view2chart3)
        fansScroll.addSubview(view2chart3_label)

        fansScroll.addSubview(view2chart4)
        fansScroll.addSubview(view2chart4_label)

//        fansScroll.addSubview(view2tableview5)

        fansPageControl.numberOfPages = 4;
        fansPageControl.currentPage = 0
        //设置页控件点击事件
        fansPageControl.addTarget(self, action: "pageChanged:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func loadFansChartsData(){
        loadAreasChartViewData(view2chart2,method: "showWechatNewFansSourceArea.cic")
        loadAreasChartViewData(view2chart4,method: "showWechatTotalFansSourceArea.cic")
        loadStackedBarsViewData(view2chart3, method: "showWechatTotalFansAnalysis.cic")
        loadStackedBarsViewData(view2chart1, method: "showNewFansGenderOrCity.cic")

    }
    
    //点击页控件时事件处理
    func pageChanged(sender:UIPageControl) {
        //根据点击的页数，计算scrollView需要显示的偏移量
        print("pagechanged");
    }
    
    //UIScrollViewDelegate方法，每次滚动结束后调用
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        if let _ = accountScroll {
            if scrollView == accountScroll {
                //通过scrollView内容的偏移计算当前显示的是第几页
                var page = Int(scrollView.contentOffset.x / accountScroll.frame.size.width)
                //设置pageController的当前页
                if page > 4 {
                    page = 4;
                }
                accountPageControl.currentPage = page
            }
        }
        if let _ = fansScroll {
            if scrollView == fansScroll {
                //通过scrollView内容的偏移计算当前显示的是第几页
                var page = Int(scrollView.contentOffset.x / fansScroll.frame.size.width)
                //print("page:\(page)");
                //设置pageController的当前页
                if page > 4 {
                    page = 4;
                }
                fansPageControl.currentPage = page
            }
        }
        
        
    }
    
    func scrollViewDidScroll(scrollView:UIScrollView){
        let offsetY: CGFloat = scrollView.contentOffset.y
        let offsetX: CGFloat = scrollView.contentOffset.x
        if let _ = self.scrollView {
            if scrollView == self.scrollView {
                // 处理segmented_control
                if offsetY >= 150 || offsetX>0 {
                    seg.frame = CGRect(x: seg.x, y: offsetY, width: seg.width, height: seg.height)
                    seg.backgroundColor = UIColor.whiteColor()
                } else if(offsetY < 100){
                    seg.frame = CGRect(x: seg.x, y: 155, width: seg.width, height: seg.height)
                }
            }
        }
        
    }

    
    func segmentedAction(sender: UISegmentedControl) {
        switch seg.selectedSegmentIndex{
        case 0:
            //print("0")
            time1 = Utils.getDateString(-2);
            loadAccountChartsData()
            loadFansChartsData()
            
        case 1:
            //print("1")
            time1 = Utils.getDateString(-7);
            loadAccountChartsData()
            loadFansChartsData()

        case 2:
            //print("2")
            time1 = Utils.getDateString(-14);
            loadAccountChartsData()
            loadFansChartsData()
            
        case 3:
            //print("3")
            time1 = Utils.getDateString(-30);
            loadAccountChartsData()
            loadFansChartsData()
            
        default:
            time1 = Utils.getDateString(-7);
            loadAccountChartsData()
            loadFansChartsData()
            
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
///MARK:- UITableViewDelegate和UITableViewDataSource
extension WechatInfo: UITableViewDelegate, UITableViewDataSource {
    
    //获取tableviewcell个数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return tablechartbean.count
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = NSBundle.mainBundle().loadNibNamed("ChartTableCell", owner: nil, options: nil).last as? ChartTableCell
            let tablebean = tablechartbean[indexPath.row];
            cell?.numberlabel.text = String(indexPath.row + 1)
            cell?.titlelabel.text = tablebean.content
            cell?.eyelabel.text = String(tablebean.reads)
            cell?.transmitlabel.text = String(tablebean.shares)
            cell?.timelabel.text = tablebean.pubDate;
            return cell!

    }
    
    //tableViewCell点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}

