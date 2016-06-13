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


class KeywordInfo:NormalViewController,UIScrollViewDelegate{
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var accountView: UIView!
    
    @IBOutlet weak var accountScroll: UIScrollView!
    
    @IBOutlet weak var accountPageControl: UIPageControl!
    
    
    @IBOutlet weak var seg: UIView!
    
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var weiboView: UIView!
    
    
    @IBOutlet weak var weiboSroll: UIScrollView!
    
    @IBOutlet weak var weiboPageControl: UIPageControl!
    
    
    private var selectTableDataSource = [String]();
    
    private let dayString:[String] = ["1 Day","7 Days","14 Days","30 Days"];
    private let dataSource:[String] = ["All","Weibo","News","BBS","e-COMM"];
    private let mentions:[String] = ["All","Positive","Neutral","Negative"];

    
    // 数据源
    @IBOutlet weak var dataSourceView: UIView!
    @IBOutlet weak var dataSourceLabel: UILabel!
    @IBOutlet weak var dataSourceImg: UIImageView!
    

    // 日期选择
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var me_arr: UIImageView!

    
    // 情感分析
    @IBOutlet weak var sentimentView: UIView!
    @IBOutlet weak var sentimentLabel: UILabel!
    @IBOutlet weak var sentimentImg: UIImageView!
    
    // 标记筛选表格是否弹出
    private var selectTableShow = false;
    // 标记选中的哪个表格
    private var selectTableIndex = 0;
    
    // 数据来源上次选中的cell
    private var dataSourceSelectedIndex = 0;
    private var dataSourceSelectedValue = "";
    // 日期上次选中的cell

    private var dateSelectedIndex = 1;
    private var dateSelectedValue = "";

    // 情感上次选中的cell
    private var sentimentSelectedIndex = 0;
    private var sentimentSelectedValue = "";


    // 标记选中的表格cell
    private var selectTableValue = "";

    @IBOutlet weak var keywords_label: UILabel!
    
    @IBOutlet weak var data_source_label: UILabel!
    
    @IBOutlet weak var keyword_img: UIImageView!
    
    var timer : NSTimer!
    var timer2 : NSTimer!
    
    var bean = AccountBean();

    

    let able = UITableView()
    let able2 = UIView()
    var oldY:CGFloat = 0.0;
    var newY:CGFloat = 0.0;
    let navtitle:UILabel? = UILabel()


    
    let view1chart1 = BarAndLinesChartViewTool()
    let view1chart2 = PieChartViewTool()
    let view1chart3 = PieChartViewTool()
    let view1chart4 = BarChartViewTool()
    let view2chart2 = BarChartViewTool()
    let view2chart3 = BarChartViewTool()
    let view2chart4 = PieChartViewTool()
    let view2chart5 = PieChartViewTool()
    
    /*
    1001 normal
    1002 return null
    1003 network error
    */
    private var event_text = 1001
    var loadImg:UIButton?
    var loadLabel:UILabel?
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
        
        time1 = Utils.getDateString(-6);
        time2 = Utils.getDateString(0);
        
        reachability_listening()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        scrollView.showsHorizontalScrollIndicator=false
        scrollView.showsVerticalScrollIndicator = false
//        scrollView.bounces=false
        scrollView.delegate = self;
        scrollView.indicatorStyle = UIScrollViewIndicatorStyle.Default
        
        //navigationbar
        navtitle!.text = bean.name
        navtitle!.textColor = UIColor.blackColor()
        navtitle!.frame = CGRectMake(0, 0, 10, 20)
        navigationItem.titleView = navtitle
        addBorder(accountView);
        addBorder(seg);
        addBorder(weiboView);

        oldY = seg.frame.origin.y;
        newY = oldY;
        
        keyword_img.image = UIImage(named: "keyword")
        keyword_img.layer.cornerRadius = 35;
        keyword_img.layer.masksToBounds = true;
        
        showAccountCharts();
        showWeiboCharts();
        
        showDateView();
        
        loadKeywordBaseInfo()
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

    func reachabilityChanged(note: NSNotification) {
            
            let reachability = note.object as! Reachability
            
            if reachability.isReachable() {
            if reachability.isReachableViaWiFi() {
            print("Keyword Reachable via WiFi")
            event_text = 1001
        } else {
            print("Keyword Reachable via Cellular")
            event_text = 1001
            }
        } else {
            print("Keyword Not reachable")
            self.event_text = 1003
            xwDelay(0.1) { () -> Void in
//                Utils.alert_view(1003)
                self.addErrorView()
            }
        }
    }
    
    func loadKeywordBaseInfo(){
        //数据链接，解析
        let url = rootURL + "channelAccount/showSearchRight.cic";
        let parameters = [
            "channelId": bean.id
        ]
        Alamofire.request(.GET, url,parameters: parameters).responseJSON{
            data in
            if(data.result.isSuccess){
                let json = data.result.value!;
                if (!NSJSONSerialization.isValidJSONObject(json)) {
                    Utils.alert_view(1008);
                }else{
                    let jsonObj = Utils.stringToJson(json);
                    let content = jsonObj.objectForKey("content") as! String;
                    let medias = jsonObj.objectForKey("medias") as! String;
                    let mescontent = content.componentsSeparatedByString("~");
                    let mes = medias.componentsSeparatedByString(",");
                    var contentStr = "● ";
                    var mediaStr = "●  ";
                    
                    for character in mescontent {
                        contentStr += " \(character) OR"
                    }
                    for me in mes {
                        if me == "1"{
                            mediaStr += "WEIBO,"
                        }else if(me == "60"){
                            mediaStr += "NEWS,"
                        }else if(me == "50"){
                            mediaStr += "BBS,"
                        }else if(me == "80"){
                            mediaStr += "e-COMM,"
                        }else if(me == "70"){
                            mediaStr += "Search,"
                        }
                    }
                    contentStr.removeAtIndex(contentStr.endIndex.predecessor())
                    contentStr.removeAtIndex(contentStr.endIndex.predecessor())
                    mediaStr.removeAtIndex(mediaStr.endIndex.predecessor())
                    self.keywords_label.text = contentStr
                    self.data_source_label.text = mediaStr
                }
            }else{
                if self.event_text == 1003{
                }else{
                    Utils.alert_view(1011);
                }
            }
        }
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
        loadAccountChartsData();
        loadWeiboChartsData();
        loadKeywordBaseInfo()

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
    
    func loadLineChartViewData(chart:ChartViewInterface,type:String,indexName:String){
        //192.168.4.172:16007/SocialListeningServer/highcharts/getDataChart.cic?para=jsonfile=stat_channel_line|bean=statChannelChartBean|isclick=true|type=LINE|channelId=121413|limit=24|frequency=day|labType=11|tempDateBegin=2016-02-02|tempDateEnd=2016-03-02&indexName=资讯趋势&labId=21&chartType=channelTrend
        
        //数据链接
        let url = rootURL + "highcharts/getDataChart.cic";
        //print(bean.id);
        let parameters = [
            "para": "jsonfile=stat_channel_line|bean=statChannelChartBean|isclick=true|type=\(type)|channelId=\(bean.id)|limit=24|frequency=day|labType=11|tempDateBegin=\(time1)|tempDateEnd=\(time2)|sentiment=\(sentimentSelectedValue)|mediaType=\(dataSourceSelectedValue)",
            "indexName":indexName,
            "labId":"21",
            "chartType":"channelTrend"
        ]
        Alamofire.request(.GET, url,parameters: parameters).responseJSON{
            data in
            //print(data);
            if(data.result.isSuccess){
                let json = data.result.value!;
                chart.setData(json,a: 3)
            }else{
                if self.event_text == 1003{
                }else{
                    Utils.alert_view(1011);
                }
            }
        }
    }
    
    func loadBarChartViewData(chart:ChartViewInterface,barType:String,indexName:String){
        //192.168.4.172:16007/SocialListeningServer/highcharts/getDataChart.cic?para=jsonfile=stat_channel_bar|bean=statChannelBarBean|pageSize=24|isclick=true|type=BAR|channelId=121413|limit=24|barType=STAT_CHANNEL_SITE|labType=11|tempDateBegin=2016-02-02|tempDateEnd=2016-03-02&indexName=网站分布&labId=21&chartType=channelBar

        
        //数据链接
        let url = rootURL + "highcharts/getDataChart.cic";
        
        let parameters = [
            "para":"jsonfile=stat_channel_bar|bean=statChannelBarBean|pageSize=24|isclick=true|type=BAR|channelId=\(bean.id)|limit=5|barType=\(barType)|labType=11|tempDateBegin=\(time1)|tempDateEnd=\(time2)|sentiment=\(sentimentSelectedValue)|mediaType=\(dataSourceSelectedValue)",
            "indexName":indexName,
            "labId":"21",
            "chartType":"channelBar"
        ]
        Alamofire.request(.GET, url,parameters: parameters).responseJSON{
            data in
            self.clearAllNotice();
            if(data.result.isSuccess){
                let json = data.result.value!;
                chart.setData(json,a: 0)
            }else{
                if self.event_text == 1003{
                }else{
                    Utils.alert_view(1011);
                }
            }
        }
    }
    
    func loadPieChartViewData(chart:ChartViewInterface,pieType:String,indexName:String,type:String,which:Int){
        removeChartsData()
        //192.168.4.172:16007/SocialListeningServer/highcharts/getDataChart.cic?para=jsonfile=stat_channel_pie|bean=statChannelPieBean|isclick=true|type=PIE|channelId=121413|limit=24|pieType=STAT_CHANNEL_CONTENT|labType=11|tempDateBegin=2016-02-02|tempDateEnd=2016-03-02&indexName=内容识别&labId=21&chartType=channelPie
        //192.168.4.172:16007/SocialListeningServer/highcharts/getDataChart.cic?para=jsonfile=stat_channel_pie|bean=statChannelPieBean|isclick=true|type=VERIFIED|channelId=121413|limit=24|pieType=STAT_CHANNEL_VERIFIED|scene=verified|labType=11|tempDateBegin=2016-02-04|tempDateEnd=2016-03-10&indexName=认证&labId=21&chartType=channelPie
        
        //数据链接
        let url = rootURL + "highcharts/getDataChart.cic";
        
        let parameters = [
            "para":"jsonfile=stat_channel_pie|bean=statChannelPieBean|isclick=true|type=\(type)|channelId=\(bean.id)|limit=24|pieType=\(pieType)|labType=11|tempDateBegin=\(time1)|tempDateEnd=\(time2)|sentiment=\(sentimentSelectedValue)|mediaType=\(dataSourceSelectedValue)",
            "indexName":indexName,
            "labId":"21",
            "chartType":"channelPie"
        ]
        Alamofire.request(.GET, url,parameters: parameters).responseJSON{
            data in
//            print(data)
            if(data.result.isSuccess){
                let json = data.result.value!;
                chart.setData(json,a: 0)
                if which == 1{
                    var pie_data = [:]
                    pie_data = chart.setData(json,a: 0)
                    let pie_name = pie_data.objectForKey("piecharts_name") as! NSArray
                    let pie_values = pie_data.objectForKey("piecharts_values") as! NSArray
                    var pie_all_values = 0.0
                    for(var j = 0 ; j < pie_name.count; j++){
                        pie_all_values += pie_values[j] as! Double
                    }
                    if pie_name.count > 0{
                        self.myView?.name_label1.text = pie_name[0] as? String
                        self.myView?.number_label1.text =  (NSString(format: "%.2f", pie_values[0] as! Double * 100 / pie_all_values) as String) + "%"
                        self.myView?.image1.hidden = false

                    }
                    if pie_name.count > 1{
                        self.myView?.name_label2.text = pie_name[1] as? String
                        self.myView?.number_label2.text =  (NSString(format: "%.2f", pie_values[1] as! Double * 100 / pie_all_values) as String) + "%"
                        self.myView?.image2.hidden = false

                    }
                    if pie_name.count > 2{
                        self.myView?.name_label3.text = pie_name[2] as? String
                        self.myView?.number_label3.text =  (NSString(format: "%.2f", pie_values[2] as! Double * 100 / pie_all_values) as String) + "%"
                        self.myView?.image3.hidden = false

                    }
                    if pie_name.count > 3{
                        self.myView?.name_label4.text = pie_name[3] as? String
                        self.myView?.number_label4.text =  (NSString(format: "%.2f", pie_values[3] as! Double * 100 / pie_all_values) as String) + "%"
                        self.myView?.image4.hidden = false

                    }
                    
                }else if which == 2{
//                    print(data)
//                    print("dataSourceSelectedValue:\(self.dataSourceSelectedValue)")

                    var pie_data = [:]
                    pie_data = chart.setData(json,a: 0)
                    let pie_name = pie_data.objectForKey("piecharts_name") as! NSArray
                    let pie_values = pie_data.objectForKey("piecharts_values") as! NSArray
                    var pie_all_values = 0.0
                    for(var j = 0 ; j < pie_name.count; j++){
                        pie_all_values += pie_values[j] as! Double
                    }
                    if pie_name.count > 0{
                        self.myView2?.name_label1.text = pie_name[0] as? String
                        self.myView2?.number_label1.text =  (NSString(format: "%.2f", pie_values[0] as! Double * 100 / pie_all_values) as String) + "%"
                        self.myView2?.image1.hidden = false

                    }
                    if pie_name.count > 1{
                        self.myView2?.name_label2.text = pie_name[1] as? String
                        self.myView2?.number_label2.text =  (NSString(format: "%.2f", pie_values[1] as! Double * 100 / pie_all_values) as String) + "%"
                        self.myView2?.image2.hidden = false

                    }
                    if pie_name.count > 2{
                        self.myView2?.name_label3.text = pie_name[2] as? String
                        self.myView2?.number_label3.text =  (NSString(format: "%.2f", pie_values[2] as! Double * 100 / pie_all_values) as String) + "%"
                        self.myView2?.image3.hidden = false

                    }
                    if pie_name.count > 3{
                        self.myView2?.name_label4.text = pie_name[3] as? String
                        self.myView2?.number_label4.text =  (NSString(format: "%.2f", pie_values[3] as! Double * 100 / pie_all_values) as String) + "%"
                        self.myView2?.image4.hidden = false

                    }
                }else if which == 3{
                    var pie_data = [:]
                    pie_data = chart.setData(json,a: 0)
                    let pie_name = pie_data.objectForKey("piecharts_name") as! NSArray
                    let pie_values = pie_data.objectForKey("piecharts_values") as! NSArray
                    var pie_all_values = 0.0
                    for(var j = 0 ; j < pie_name.count; j++){
                        pie_all_values += pie_values[j] as! Double
                    }
                    if pie_name.count > 0{
                        self.myView3?.name_label1.text = pie_name[0] as? String
                        self.myView3?.number_label1.text =  (NSString(format: "%.2f", pie_values[0] as! Double * 100 / pie_all_values) as String) + "%"
                        self.myView3?.image1.hidden = false

                    }
                    if pie_name.count > 1{
                        self.myView3?.name_label2.text = pie_name[1] as? String
                        self.myView3?.number_label2.text =  (NSString(format: "%.2f", pie_values[1] as! Double * 100 / pie_all_values) as String) + "%"
                        self.myView3?.image2.hidden = false

                    }
                    if pie_name.count > 2{
                        self.myView3?.name_label3.text = pie_name[2] as? String
                        self.myView3?.number_label3.text =  (NSString(format: "%.2f", pie_values[2] as! Double * 100 / pie_all_values) as String) + "%"
                        self.myView3?.image3.hidden = false

                    }
                    if pie_name.count > 3{
                        self.myView3?.name_label4.text = pie_name[3] as? String
                        self.myView3?.number_label4.text =  (NSString(format: "%.2f", pie_values[3] as! Double * 100 / pie_all_values) as String) + "%"
                        self.myView3?.image4.hidden = false

                    }
                }
            }else{
                if self.event_text == 1003{
                }else{
                    Utils.alert_view(1011);
                }
            }
        }
    }
    
    
    func removeChartsData(){
        myView?.image1.hidden = true
        myView?.image2.hidden = true
        myView?.image3.hidden = true
        myView?.image4.hidden = true
        myView?.name_label1.text = ""
        myView?.name_label2.text = ""
        myView?.name_label3.text = ""
        myView?.name_label4.text = ""
        myView?.number_label1.text = ""
        myView?.number_label2.text = ""
        myView?.number_label3.text = ""
        myView?.number_label4.text = ""
        
        myView2?.image1.hidden = true
        myView2?.image2.hidden = true
        myView2?.image3.hidden = true
        myView2?.image4.hidden = true
        myView2?.name_label1.text = ""
        myView2?.name_label2.text = ""
        myView2?.name_label3.text = ""
        myView2?.name_label4.text = ""
        myView2?.number_label1.text = ""
        myView2?.number_label2.text = ""
        myView2?.number_label3.text = ""
        myView2?.number_label4.text = ""
        
        myView3?.image1.hidden = true
        myView3?.image2.hidden = true
        myView3?.image3.hidden = true
        myView3?.image4.hidden = true
        myView3?.name_label1.text = ""
        myView3?.name_label2.text = ""
        myView3?.name_label3.text = ""
        myView3?.name_label4.text = ""
        myView3?.number_label1.text = ""
        myView3?.number_label2.text = ""
        myView3?.number_label3.text = ""
        myView3?.number_label4.text = ""
        
        myView4?.image1.hidden = true
        myView4?.image2.hidden = true
        myView4?.image3.hidden = true
        myView4?.image4.hidden = true
        myView4?.name_label1.text = ""
        myView4?.name_label2.text = ""
        myView4?.name_label3.text = ""
        myView4?.name_label4.text = ""
        myView4?.number_label1.text = ""
        myView4?.number_label2.text = ""
        myView4?.number_label3.text = ""
        myView4?.number_label4.text = ""
    }
    //view2chart4独特饼图
    func loadPieChartViewQData(chart:ChartViewInterface,pieType:String,indexName:String,type:String){
        //192.168.4.172:16007/SocialListeningServer/highcharts/getDataChart.cic?para=jsonfile=stat_channel_pie|bean=statChannelPieBean|isclick=true|type=VERIFIED|channelId=121413|limit=24|pieType=STAT_CHANNEL_VERIFIED|scene=verified|labType=11|tempDateBegin=2016-02-04|tempDateEnd=2016-03-10&indexName=认证&labId=21&chartType=channelPie
        //数据链接
        let url = rootURL + "highcharts/getDataChart.cic";
        
        let parameters = [
            "para":"jsonfile=stat_channel_pie|bean=statChannelPieBean|isclick=true|type=\(type)|channelId=\(bean.id)|limit=24|pieType=\(pieType)|scene=verified|labType=11|tempDateBegin=\(time1)|tempDateEnd=\(time2)|sentiment=\(sentimentSelectedValue)|mediaType=\(dataSourceSelectedValue)",
            "indexName":indexName,
            "labId":"21",
            "chartType":"channelPie"
        ]
        Alamofire.request(.GET, url,parameters: parameters).responseJSON{
            data in
            if(data.result.isSuccess){
                let json = data.result.value!;
                chart.setData(json,a: 0)
                var pie_data = [:]
                pie_data = chart.setData(json,a: 0)
                let pie_name = pie_data.objectForKey("piecharts_name") as! NSArray
                let pie_values = pie_data.objectForKey("piecharts_values") as! NSArray
                var pie_all_values = 0.0
                for(var j = 0 ; j < pie_name.count; j++){
                    pie_all_values += pie_values[j] as! Double
                }
                if pie_name.count > 0{
                    self.myView4?.name_label1.text = pie_name[0] as? String
                    self.myView4?.number_label1.text =  (NSString(format: "%.2f", pie_values[0] as! Double * 100 / pie_all_values) as String) + "%"
                    self.myView4?.image1.hidden = false

                }
                if pie_name.count > 1{
                    self.myView4?.name_label2.text = pie_name[1] as? String
                    self.myView4?.number_label2.text =  (NSString(format: "%.2f", pie_values[1] as! Double * 100 / pie_all_values) as String) + "%"
                    self.myView4?.image2.hidden = false

                }
                if pie_name.count > 2{
                    self.myView4?.name_label3.text = pie_name[2] as? String
                    self.myView4?.number_label3.text =  (NSString(format: "%.2f", pie_values[2] as! Double * 100 / pie_all_values) as String) + "%"
                    self.myView4?.image3.hidden = false

                }
                if pie_name.count > 3{
                    self.myView4?.name_label4.text = pie_name[3] as? String
                    self.myView4?.number_label4.text =  (NSString(format: "%.2f", pie_values[3] as! Double * 100 / pie_all_values) as String) + "%"
                    self.myView4?.image4.hidden = false

                }
            }else{
                if self.event_text == 1003{
                }else{
                    Utils.alert_view(1011);
                }
            }
        }
    }
    
    let myView = NSBundle.mainBundle().loadNibNamed("PieCharts_tuglie", owner: nil, options: nil).last as? PieCharts_tuglie
    let myView2 = NSBundle.mainBundle().loadNibNamed("PieCharts_tuglie", owner: nil, options: nil).last as? PieCharts_tuglie
    
    func showAccountCharts(){
        
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
            CGFloat(width) * CGFloat(4),
            CGRectGetHeight(self.accountScroll.bounds)
        )
        let size = accountScroll.bounds.size;
        
//        addBorder(view1chart1);
//        addBorder(view1chart2);
//        addBorder(view1chart3);
//        addBorder(view1chart4);
        
        
        loadAccountChartsData();
        
        view1chart1.frame = CGRect(x: CGFloat(0) * (width), y: 20,width: width, height:size.height - 20);
        
        let view1chart1_label = UILabel()
        view1chart1_label.font = UIFont.systemFontOfSize(14)

        view1chart1_label.frame = CGRect(x: CGFloat(0) * (width) + 5, y: 0,width: width, height: 20)
        view1chart1_label.text = "Buzz trend"
        
        view1chart2.frame = CGRect(x: CGFloat(1) * (width), y: 20,width: width, height: 235 - 20)
        let b = UIView()
        myView?.frame = CGRect(x: 0, y: 0,width: width, height: 200);
        b.frame = CGRect(x: CGFloat(1) * (width), y: 236,width: width, height: 200)
        b.addSubview(myView!)
        let view1chart2_label = UILabel()
        view1chart2_label.font = UIFont.systemFontOfSize(14)

        view1chart2_label.frame = CGRect(x: CGFloat(1) * (width) + 5, y: 0,width: width, height: 20)
        view1chart2_label.text = "Sentiment"

        view1chart3.frame = CGRect(x: CGFloat(2) * (width), y: 20,width: width, height: 235 - 20);
        let c = UIView()
        myView2?.frame = CGRect(x: 0, y: 0,width: width, height: 200);
        c.frame = CGRect(x: CGFloat(2) * (width), y: 236,width: width, height: 200)
        c.addSubview(myView2!)
        let view1chart3_label = UILabel()
        view1chart3_label.font = UIFont.systemFontOfSize(14)

        view1chart3_label.frame = CGRect(x: CGFloat(2) * (width) + 5, y: 0,width: width, height: 20)
        view1chart3_label.text = "Media type distribution"
        
        view1chart4.frame = CGRect(x: CGFloat(3) * (width), y: 20,width: width, height:size.height - 20);
        let view1chart4_label = UILabel()
        view1chart4_label.font = UIFont.systemFontOfSize(14)

        view1chart4_label.frame = CGRect(x: CGFloat(3) * (width) + 5, y: 0,width: width, height: 20)
        view1chart4_label.text = "Top sites"
        
        accountScroll.addSubview(view1chart1)
        accountScroll.addSubview(view1chart1_label)

        accountScroll.addSubview(view1chart2)
        accountScroll.addSubview(view1chart2_label)

        accountScroll.addSubview(b)
        accountScroll.addSubview(view1chart3)
        accountScroll.addSubview(view1chart3_label)

        accountScroll.addSubview(c)
        accountScroll.addSubview(view1chart4)
        accountScroll.addSubview(view1chart4_label)

//        accountScroll.addSubview(view1chart5)
        
        accountPageControl.numberOfPages = 4;
        accountPageControl.currentPage = 0
        //设置页控件点击事件
        accountPageControl.addTarget(self, action: "pageChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    
    func loadAccountChartsData(){
        if event_text != 1001 {
            Utils.alert_view(self.event_text)
            return
        }
        self.pleaseWait();
        removeNetError()
        loadLineChartViewData(view1chart1, type: "LINE", indexName: "Buzz Trend")
        loadPieChartViewData(view1chart2, pieType: "STAT_CHANNEL_SENTIMENT", indexName: "Sentiment",type: "PIE",which: 1)
        loadPieChartViewData(view1chart3, pieType: "STAT_CHANNEL_MEDIATYPE", indexName: "Media Type Distribution",type: "PIE",which: 2)
        loadBarChartViewData(view1chart4, barType: "STAT_CHANNEL_SITE", indexName: "Top Sites")

    }
    
    func loadWeiboChartsData(){
        if event_text != 1001 {
            Utils.alert_view(self.event_text)
            return
        }
        self.pleaseWait();
        removeNetError()
        loadBarChartViewData(view2chart2, barType: "STAT_CHANNEL_SOURCE", indexName: "Client Distribution")
        loadBarChartViewData(view2chart3, barType: "STAT_CHANNEL_PROVINCE", indexName: "Geographical Distribution")
        loadPieChartViewQData(view2chart4, pieType: "STAT_CHANNEL_VERIFIED", indexName: "Verified",type: "VERIFIED")
        loadPieChartViewData(view2chart5, pieType: "STAT_CHANNEL_GENDER", indexName: "Gender",type: "PIE",which: 3)
    }
    
    let myView3 = NSBundle.mainBundle().loadNibNamed("PieCharts_tuglie", owner: nil, options: nil).last as? PieCharts_tuglie
    let myView4 = NSBundle.mainBundle().loadNibNamed("PieCharts_tuglie", owner: nil, options: nil).last as? PieCharts_tuglie
    
    func showWeiboCharts(){
        //关闭滚动条显示
        weiboSroll.showsHorizontalScrollIndicator = false
        weiboSroll.showsVerticalScrollIndicator = false
        weiboSroll.scrollsToTop = false
        weiboSroll.bounces=false
        
        //协议代理，在本类中处理滚动事件
        weiboSroll.delegate = self
        //滚动时只能停留到某一页
        weiboSroll.pagingEnabled = true
        
        let width = AppWidth - 22;
        
        //设置scrollView的内容总尺寸
        weiboSroll.contentSize = CGSizeMake(
            CGFloat(width) * CGFloat(4),
            CGRectGetHeight(self.weiboSroll.bounds)
        )
        let size = weiboSroll.bounds.size;
        
//        addBorder(view2chart1);
//        addBorder(view2chart2);
//        addBorder(view2chart3);
//        addBorder(view2chart4);
//        addBorder(view2chart5);
        
        
        loadWeiboChartsData();
        

        view2chart2.frame = CGRect(x: CGFloat(3) * (width), y: 20,width: width, height: size.height)
        let view2chart2_label = UILabel()
        view2chart2_label.font = UIFont.systemFontOfSize(14)
        view2chart2_label.frame = CGRect(x: CGFloat(3) * (width) + 5, y: 0,width: width, height: 20)
        view2chart2_label.text = "Client distribution"
        
        
        view2chart3.frame = CGRect(x: CGFloat(0) * (width), y: 20,width: width, height:size.height);
        let view2chart3_label = UILabel()
        view2chart3_label.font = UIFont.systemFontOfSize(14)
        view2chart3_label.frame = CGRect(x: CGFloat(0) * (width) + 5, y: 0,width: width, height: 20)
        view2chart3_label.text = "Geographical distribution"
        
        
        view2chart4.frame = CGRect(x: CGFloat(2) * (width), y: 20,width: width, height:235);
        let view2chart4_label = UILabel()
        view2chart4_label.font = UIFont.systemFontOfSize(14)
        view2chart4_label.frame = CGRect(x: CGFloat(2) * (width) + 5, y: 0,width: width, height: 20)
        view2chart4_label.text = "Verified"
        let e = UIView()
        myView4?.frame = CGRect(x: 0, y: 0,width: width, height: 200);
        e.frame = CGRect(x: CGFloat(2) * (width), y: 236,width: width, height: 200)
        e.addSubview(myView4!)
        
        view2chart5.frame = CGRect(x: CGFloat(1) * (width), y: 20,width: width, height:235);
        let d = UIView()
        myView3?.frame = CGRect(x: 0, y: 0,width: width, height: 200);
        d.frame = CGRect(x: CGFloat(1) * (width), y: 236,width: width, height: 200)
        d.addSubview(myView3!)
        let view2chart5_label = UILabel()
        view2chart5_label.font = UIFont.systemFontOfSize(14)
        view2chart5_label.frame = CGRect(x: CGFloat(1) * (width) + 5, y: 0,width: width, height: 20)
        view2chart5_label.text = "Gender"
        
        weiboSroll.addSubview(view2chart2)
        weiboSroll.addSubview(view2chart3)
        weiboSroll.addSubview(view2chart4)
        weiboSroll.addSubview(d)
        weiboSroll.addSubview(view2chart5)
        weiboSroll.addSubview(e)
        
        weiboSroll.addSubview(view2chart2_label)
        weiboSroll.addSubview(view2chart3_label)
        weiboSroll.addSubview(view2chart4_label)
        weiboSroll.addSubview(view2chart5_label)


        weiboPageControl.numberOfPages = 4;
        weiboPageControl.currentPage = 0
        //设置页控件点击事件
        weiboPageControl.addTarget(self, action: "pageChanged:", forControlEvents: UIControlEvents.ValueChanged)
    }

    
    func showDateView(){
        able.frame = CGRect(x: 0, y: 280, width: AppWidth, height: 200)
        able2.frame = CGRect(x: 0, y: 340+138, width: AppWidth+5, height: AppHeight)
        able2.backgroundColor = UIColor(red: 105/255.0, green: 105/255.0, blue: 105/255.0, alpha: 0.5)
        able.delegate = self
        able.dataSource = self
        self.view.addSubview(able)
        self.view.addSubview(able2)
        able.hidden = true
        able2.hidden = true
        //点击view
        let tapGR = UITapGestureRecognizer(target: self, action: "tapHandler:")
        let tapGR2 = UITapGestureRecognizer(target: self, action: "tapHandler:")
        let tapGR3 = UITapGestureRecognizer(target: self, action: "tapHandler:")
        // 点击灰色地带，弹窗消失
        let tapGR4 = UITapGestureRecognizer(target: self, action: "hidden_anim")


        dateView.addGestureRecognizer(tapGR)
        dataSourceView.addGestureRecognizer(tapGR2)
        sentimentView.addGestureRecognizer(tapGR3)
        
        able2.addGestureRecognizer(tapGR4)


    }
    
    func tapHandler(sender:UITapGestureRecognizer){
        
        let lastSelectTableIndex = selectTableIndex;
        
        
        
        if sender.view == dataSourceView {
            dataSourceImg.image = UIImage(named: "keywordarrup")
            me_arr.image = UIImage(named: "keywordarrdown")
            sentimentImg.image = UIImage(named: "keywordarrdown")
            selectTableIndex = 0;
            selectTableDataSource = dataSource
        }
        
        if sender.view == dateView {
            me_arr.image = UIImage(named: "keywordarrup")
            dataSourceImg.image = UIImage(named: "keywordarrdown")
            sentimentImg.image = UIImage(named: "keywordarrdown")
            selectTableIndex = 1;
            selectTableDataSource = dayString
            
        }
        
        if sender.view == sentimentView {
            sentimentImg.image = UIImage(named: "keywordarrup")
            me_arr.image = UIImage(named: "keywordarrdown")
            dataSourceImg.image = UIImage(named: "keywordarrdown")
            selectTableIndex = 2;
            selectTableDataSource = mentions
            
        }
        
        // 本次选中和上次选中一样
        if lastSelectTableIndex == selectTableIndex {
            
            if selectTableShow  {
                selectTableShow = false;
                setSelectLabel(selectTableIndex);
                hidden_anim()
                //setSelectLabel(lastSelectTableIndex);
            }else{
                selectTableShow = true;
                selectTableShow = true;
                able.hidden = false
                able2.hidden = false
                able.alpha = 1
                able2.alpha = 1
            }
            
            able.reloadData();

        }else{
            if selectTableShow {
                setSelectLabel(lastSelectTableIndex);
            }else{
                selectTableShow = true;
                selectTableShow = true;
                able.hidden = false
                able2.hidden = false
                able.alpha = 1
                able2.alpha = 1
            }
            
            able.reloadData();
        }
        
        
        /*
        if selectTableShow == false{
            selectTableShow = true;
            able.hidden = false
            able2.hidden = false
            able.alpha = 1
            able2.alpha = 1
            //me_arr.image = UIImage(named: "keywordarrdown")
        }else{

            selectTableShow = false;
            hidden_anim()
            //me_arr.image = UIImage(named: "keywordarr")
        }
        
        */
    }
    
    //点击页控件时事件处理
    func pageChanged(sender:UIPageControl) {
        print("pagechanged");
    }
    

    
    //UIScrollViewDelegate方法，每次滚动结束后调用
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        if let _ = accountScroll {
            if scrollView == accountScroll {
                //通过scrollView内容的偏移计算当前显示的是第几页
                var page = Int(scrollView.contentOffset.x / accountScroll.frame.size.width)
                //设置pageController的当前页
                if page > 5 {
                    page = 5;
                }
                accountPageControl.currentPage = page
            }
        }
        if let _ = weiboSroll {
            if scrollView == weiboSroll {
                //通过scrollView内容的偏移计算当前显示的是第几页
                var page = Int(scrollView.contentOffset.x / weiboSroll.frame.size.width)
                //设置pageController的当前页
                if page > 4 {
                    page = 4;
                }
                weiboPageControl.currentPage = page
            }
        }
        
        
        
    }
    
    func scrollViewDidScroll(scrollView:UIScrollView){
            if scrollView == self.scrollView {
                let offsetY: CGFloat = scrollView.contentOffset.y
//                print(offsetY)
                // 处理segmented_control
                if offsetY >= 180 {
                    newY = offsetY;
                    seg.frame = CGRect(x: seg.x, y: offsetY, width: seg.width, height: seg.height)
                    able.frame = CGRect(x: 0, y: 100, width: AppWidth, height: 200)
                    able2.frame = CGRect(x: 0, y: 160+140, width: AppWidth+5, height: AppHeight)
                    self.mainView.bringSubviewToFront(seg)
                } else {
                    seg.frame = CGRect(x: seg.x, y: self.oldY, width: seg.width, height: seg.height)
                    able.frame = CGRect(x: 0, y: -offsetY+280, width: AppWidth, height: 200)
                    able2.frame = CGRect(x: 0, y: -offsetY+340+140, width: AppWidth+5, height: AppHeight)
                }
            }
    }
    
    func setalpha(){
        able.alpha = 0
        able2.alpha = 0
    }
    func hidden_action(){
        able.hidden = true
        able2.hidden = true
        timer.invalidate()
        
        //setSelectLabel(selectTableIndex);
        
        sentimentImg.image = UIImage(named: "keywordarrdown")
        me_arr.image = UIImage(named: "keywordarrdown")
        dataSourceImg.image = UIImage(named: "keywordarrdown")
    }
    
    func setSelectLabel(selectTableIndex:Int){
        if selectTableValue != "" {
            if selectTableIndex == 0{
                dataSourceLabel.text = selectTableValue;
                if selectTableValue == "All" {
                    dataSourceLabel.text = "All";
                    dataSourceSelectedValue = "";
                }
                if selectTableValue == "Weibo" {
                    dataSourceSelectedValue = "1";
                }
                if selectTableValue == "News" {
                    dataSourceSelectedValue = "60";
                }
                if selectTableValue == "BBS" {
                    dataSourceSelectedValue = "50";
                }
                if selectTableValue == "e-COMM" {
                    dataSourceSelectedValue = "80";
                }
                
            }else if selectTableIndex == 1 {
                dateLabel.text = selectTableValue;
                if selectTableValue == "1 Day" {
                    time1 = Utils.getDateString(-1);
                }
                if selectTableValue == "7 Days" {
//                    dateLabel.text = "Date";
                    time1 = Utils.getDateString(-6);
                }
                if selectTableValue == "14 Days" {
                    time1 = Utils.getDateString(-13);
                }
                if selectTableValue == "30 Days" {
                    time1 = Utils.getDateString(-29);
                }
                

            }else{
                sentimentLabel.text = selectTableValue;
                // "Positive","Neutral","Negative"
                if selectTableValue == "All" {
                    sentimentLabel.text = "All";
                    sentimentSelectedValue = "";
                }
                if selectTableValue == "Positive" {
                    sentimentSelectedValue = "1";
                }
                if selectTableValue == "Neutral" {
                    sentimentSelectedValue = "0";
                }
                if selectTableValue == "Negative" {
                    sentimentSelectedValue = "-1";
                }
            }
        }
        
    }
    
    func hidden_anim(){
        selectTableShow = false;
        UIView.animateWithDuration(0.4, animations: setalpha)
        timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: ("hidden_action"), userInfo: nil, repeats: true)
        
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
extension KeywordInfo: UITableViewDelegate, UITableViewDataSource {
    
    //获取tableviewcell个数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return selectTableDataSource.count
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == able{
            let cell = NSBundle.mainBundle().loadNibNamed("DateViewCell", owner: nil, options: nil).last as? DataViewCell
            let dayStringList:String = selectTableDataSource[indexPath.row] as String
            cell!.label_data.text = dayStringList
            cell?.label_data.font = UIFont(name: "Helvetica", size: 14)
            cell?.label_data.textColor = UIColor.grayColor();
            var selIndex = 0;
            if selectTableIndex == 0 {
                selIndex = dataSourceSelectedIndex
            }else if selectTableIndex == 1{
                selIndex = dateSelectedIndex
            }else{
                selIndex = sentimentSelectedIndex
            }
            if indexPath.row == selIndex {
                selectTableValue = selectTableDataSource[indexPath.row]
                cell?.accessoryType = UITableViewCellAccessoryType.Checkmark;
            }
//            if(indexPath.row % 2 == 0){
//                cell!.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 249/255, alpha: 1)
//            }
            return cell!
        }
        return UITableViewCell()
    }
    
    //tableViewCell点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        var arry = tableView.visibleCells
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        scrollView.userInteractionEnabled = true
        selectTableValue = selectTableDataSource[indexPath.row]
        
        if selectTableIndex == 0 {
            dataSourceSelectedIndex = indexPath.row;
        }else if selectTableIndex == 1{
            dateSelectedIndex = indexPath.row;
        }else{
            sentimentSelectedIndex = indexPath.row;
        }
        
        setSelectLabel(selectTableIndex);
        
        hidden_anim()

        selectTableShow = false;
        
        for(var j = 0;j < arry.count;j++){
            let cells:UITableViewCell = arry[j]
            cells.accessoryType = UITableViewCellAccessoryType.None
        }
        cell?.accessoryType = UITableViewCellAccessoryType.Checkmark;
        
        
        loadAccountChartsData();
        loadWeiboChartsData();
        
    }
    
}

