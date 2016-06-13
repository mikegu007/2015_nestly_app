
//
//  weibo_detail.swift
//  SocialListeningApp
//
//  Created by ciccic on 16/1/21.
//  Copyright © 2016年 cicdata. All rights reserved.
//

import Foundation
import UIKit
import Charts
import Alamofire


class WeiboDetail: UIViewController,UIScrollViewDelegate {
    //主要页面
    @IBOutlet weak var main_view: UIView!
    
    @IBOutlet weak var baseinfo_veiw: UIView!
    
    @IBOutlet weak var weiboImage: UIImageView!
    @IBOutlet weak var followingLabel: UILabel!

    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var tweetsLabel: UILabel!

    @IBOutlet weak var screen_height: NSLayoutConstraint!
   
    @IBOutlet weak var chart1_width: NSLayoutConstraint!
    
    @IBOutlet weak var chart2_width: NSLayoutConstraint!
    
    @IBOutlet weak var mainscrollview1: UIView!
    
    @IBOutlet weak var mainscrollview2: UIView!
    
    @IBOutlet weak var mainscrollview3: UIView!
    
    
    //chart3属性引入
    
    @IBOutlet weak var chart3view_width: NSLayoutConstraint!
    
    
    //scrollview引入
    @IBOutlet weak var sv: UIScrollView!
   
    @IBOutlet weak var sv1: UIScrollView!
    
    @IBOutlet weak var sv2: UIScrollView!
    
    @IBOutlet weak var sv3: UIScrollView!
    
    @IBOutlet weak var pc1: UIPageControl!
    
    @IBOutlet weak var pc2: UIPageControl!
    
    @IBOutlet weak var pc3: UIPageControl!
    
    //chartsview图表引入
    @IBOutlet weak var charts1view1: UIView!
    
    @IBOutlet weak var charts1view2: UIView!
    
    @IBOutlet weak var charts1view3: UIView!
    
    @IBOutlet weak var charts1view4: UIView!
    
    @IBOutlet weak var charts1view5: UIView!
    
//    @IBOutlet weak var charts1view6: UIView!
    
    @IBOutlet weak var charts2view1: UIView!
    
    @IBOutlet weak var charts2view2: UIView!
    
//    @IBOutlet weak var charts2view3: UIView!
    
    @IBOutlet weak var charts2view4: UIView!
    
    @IBOutlet weak var charts2view5: UIView!
    
    @IBOutlet weak var charts3view1: UIView!
    
    @IBOutlet weak var charts3view2: UIView!
    
    @IBOutlet weak var charts3view3: UIView!
    
    @IBOutlet weak var charts3view4: UIView!
    
    //tableview 引入
    @IBOutlet weak var tableview1: UITableView!
    
    @IBOutlet weak var tableview2: UITableView!
    
    
    
    var segmented_control: UISegmentedControl!
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

    var bean = AccountBean();
    var tablebean1 = [TableChartBean]()
    var tablebean2 = [TableChartBean]()


    private var time1 = "";
    private var time2 = "";
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
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        reachability_listening()
        //网络监测
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
        

        time1 = Utils.getDateString(-7);
        time2 = Utils.getDateString(-1);
        screen_height.constant = mainscrollview3.y + 500
        addBorder(baseinfo_veiw)
        self.automaticallyAdjustsScrollViewInsets = false
        tableview1.separatorStyle = UITableViewCellSeparatorStyle.None
        tableview1.bounces=false
        tableview2.separatorStyle = UITableViewCellSeparatorStyle.None
        tableview2.bounces=false

        //navigationbar
        navtitle!.text = bean.name
        navtitle!.textColor = UIColor.blackColor()
        navtitle!.frame = CGRectMake(0, 0, 10, 20)
        navigationItem.titleView = navtitle

        //chart1相关属性配置
        chart1_width.constant = (self.view.frame.size.width-40)*5

        
        //chart2相关属性配置
        chart2_width.constant = (self.view.frame.size.width-40)*4
        
        //chart3相关属性配置
        chart3view_width.constant = (self.view.frame.size.width-40)*4
        
//        //边框设置　
//        mainscrollview1.layer.borderWidth = 1
//        mainscrollview1.layer.borderColor = UIColor(red: 105/255.0, green: 105/255.0, blue: 105/255.0, alpha: 0.1).CGColor
//
//        mainscrollview3.layer.borderWidth = 1
//        mainscrollview3.layer.borderColor = UIColor(red: 105/255.0, green: 105/255.0, blue: 105/255.0, alpha: 0.1).CGColor
        

        //代理
        self.sv.delegate = self
        self.sv1.delegate = self
        self.sv2.delegate = self
        self.sv3.delegate = self
        self.tableview1.delegate = self
        self.tableview1.dataSource = self
        self.tableview2.delegate = self
        self.tableview2.dataSource = self
        tableview2.frame.size.width = self.view.frame.size.width
        
        //pagecontroller
        pc1.currentPageIndicatorTintColor = UIColor.blueColor()
        pc2.currentPageIndicatorTintColor = UIColor.blueColor()
        pc3.currentPageIndicatorTintColor = UIColor.blueColor()
        
//        weiboImage.layer.cornerRadius = theme.ImageCornerRadius;
        weiboImage.layer.cornerRadius = 35;
        weiboImage.layer.masksToBounds = true;
        weiboImage.wxn_setImageWithURL(NSURL(string: bean.imageurl)!, placeholderImage: UIImage(named: "test")!);
        viewborderadd()
        loadWeiboBaseInfo();
        loadChartData()
        
        segmented_info()

    }
    

    
    func reachability_listening(){

    }
    
    func segmented_info(){

        let appsArray:[String] = ["1 Day","7 Days","14 Days","30 Days"]
        segmented_control = UISegmentedControl(items: appsArray)
        segmented_control.frame = CGRectMake(20, 155, AppWidth - 40, 30)
//        print("segmented size:\(segmented_control.frame)");
        segmented_control.selectedSegmentIndex = 1
        segmented_control.addTarget(self, action: "segmentedAction:", forControlEvents: UIControlEvents.ValueChanged)
        main_view.addSubview(segmented_control)
    }
    
    
    func tapHandler(sender:UITapGestureRecognizer){
    
        print(segmented_control.selectedSegmentIndex);
    }
    
    func viewborderadd(){
        addBorder(mainscrollview1)
        addBorder(mainscrollview2)
        addBorder(mainscrollview3)

//        addBorder(charts1view1)
//        addBorder(charts1view2)
//        addBorder(charts1view3)
//        addBorder(charts1view4)
//        addBorder(charts1view5)
////        addBorder(charts1view6)
//        addBorder(charts2view1)
//        addBorder(charts2view2)
////        addBorder(charts2view3)
//        addBorder(charts2view4)
//        addBorder(charts2view5)
//        addBorder(charts3view1)
//        addBorder(charts3view2)
//        addBorder(charts3view3)
//        addBorder(charts3view4)

    
    }
    
    func loadHotContentData(){
        //192.168.4.172:16007/SocialListeningServer/weiboAccount/showUserHotTopic.cic?mediaUserId=3245550107&mediaType=1&beginTime=2016-02-02&endTime=2016-03-02&order=NUM_OF_QUOTES&pageNo=1&pageSize=10&clientId=101077
        

        //数据链接，解析
        let url = rootURL + "weiboAccount/showUserHotTopic.cic";
//        print(bean.id);
        let parameters = [
            "mediaUserId": bean.id,
            "mediaType":bean.mediaUserType,
            "beginTime":time1,
            "endTime":time2,
            "order":"NUM_OF_QUOTES",
            "pageNo":1,
            "clientId":bean.clientId

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
                    
                    self.tablebean1.removeAll();
                    
                    for(var i = 0 ; i < jsonObj.count; i++){
                        let temp = jsonObj[i]
                        let tabean = TableChartBean()
                        tabean.content = temp.objectForKey("text") as! String;
                        tabean.hotretweets = temp.objectForKey("numOfQuotes") as! Int
                        tabean.comments = temp.objectForKey("numOfComments") as! Int;
                        tabean.likes = temp.objectForKey("numOfLikes") as! Int;

                        self.tablebean1.append(tabean);
                    }
                    
                    self.tableview1.reloadData();
                    
                }
            }else{
                if self.event_text == 1003{
                }else{
                    Utils.alert_view(1011);
                }
            }
        }
    }
    
    func loadInterActionData(){
        //weiboAccount/showEngagementDetail.cic?mediaUserId=3245550107&mediaType=1&beginTime=2016-02-02&endTime=2016-03-02&order=NUM_OF_COMMENTS&pageNo=1&pageSize=10&clientId=101077
        
//        print("bean:\(bean.id)");
        
        //数据链接，解析
        let url = rootURL + "weiboAccount/showEngagementDetail.cic";
        let parameters = [
            "mediaUserId": bean.id,
//            "mediaUserId": 3245550107,

            "mediaType":bean.mediaUserType,
            "beginTime":time1,
            "endTime":time2,
            "order":"NUM_OF_COMMENTS",
            "pageNo":1,
            "pageSize":10,
            "clientId":bean.clientId
            
        ]


        Alamofire.request(.GET, url,parameters: parameters as? [String : AnyObject]).responseJSON{
            data in
//            print(data)
            self.clearAllNotice();
            if(data.result.isSuccess){
                let json = data.result.value!;
                if (!NSJSONSerialization.isValidJSONObject(json)) {
                    Utils.alert_view(1008);
                }else{
                    let jsonObj = Utils.stringToJson(json);
                    
                    self.tablebean2.removeAll();
                    
                    for(var i = 0 ; i < jsonObj.count; i++){
                        let temp = jsonObj[i]
                        let tabean = TableChartBean()
                        tabean.name = temp.objectForKey("engagementScreenName") as! String;
                        tabean.activeMention = temp.objectForKey("numOfActiveMention") as! Int
                        tabean.passiveMention = temp.objectForKey("numOfPassiveMention") as! Int
                        tabean.comments = temp.objectForKey("numOfComments") as! Int;
                        self.tablebean2.append(tabean);
                    }
                    self.tableview2.reloadData();
                }
            }else{
                if self.event_text == 1003{
                }else{
//                    Utils.alert_view(1011);
                }
            }
        }
    }
    
    
    func loadWeiboBaseInfo(){
        //数据链接，解析
        let url = rootURL + "weiboAccount/showAccountMediaHead.cic";
        let parameters = [
            "mediaUserId": bean.id,
            "mediaType": bean.mediaUserType

        ]
        Alamofire.request(.GET, url,parameters: parameters).responseJSON{
            data in
//            print(data);
            if(data.result.isSuccess){
                let json = data.result.value!;
                if (!NSJSONSerialization.isValidJSONObject(json)) {
                    Utils.alert_view(1008);
                }else{
                    let jsonObj = Utils.stringToJson(json);
                    let following = jsonObj.objectForKey("friendCount") as! Int;
                    let follower = jsonObj.objectForKey("followCount") as! Int;
                    let tweets = jsonObj.objectForKey("statusCount") as! Int;

                    self.followerLabel.text = Utils.StringChanged(String(follower));
                    self.followingLabel.text = Utils.StringChanged(String(following));
                    self.tweetsLabel.text = Utils.StringChanged(String(tweets));
                }
            }else{
                if self.event_text == 1003{
                }else{
//                    Utils.alert_view(1011);
                }              }
        }
    }
    
    
    func loadBarChartViewData(chart:ChartViewInterface,barType:String,indexName:String){
        //192.168.4.172:16007/SocialListeningServer/highcharts/getDataChart.cic?para=jsonfile=stat_channel_bar|bean=statUserBar|barType=STAT_USER_FANS_FANS|mediaUserId=3245550107|mediaType=1|beginTime=2015-12-08|endTime=2016-02-11|groupId=undefined&chartType=userBar&indexName=Number of Fans Distribution&clientId=101077
        
        //数据链接
        let url = rootURL + "highcharts/getDataChart.cic";
        
        let parameters = [
            "para": "jsonfile=stat_channel_bar|bean=statUserBar|barType=\(barType)|mediaUserId=\(bean.id)|mediaType=\(bean.mediaUserType)|beginTime=\(time1)|endTime=\(time2)|groupId=undefined",
            "chartType":"userBar",
            "indexName":indexName,
            "clientId": bean.clientId
        ]
        Alamofire.request(.GET, url,parameters: parameters as? [String : AnyObject]).responseJSON{
            data in
            if(data.result.isSuccess){
                let json = data.result.value!;
                chart.setData(json,a: 0)
            }else{
                if self.event_text == 1003{
                }else{
//                    Utils.alert_view(1011);
                }              }
        }
    }
    
    
    func loadPieChartViewData(chart:ChartViewInterface,pieType:String,indexName:String,which:Int){
        //192.168.4.172:16007/SocialListeningServer/highcharts/getDataChart.cic?para=jsonfile=stat_channel_pie|bean=statUserPie|pieType=STAT_USER_DAY_FANS_GENDER|mediaUserId=3245550107|mediaType=1|beginTime=2015-12-08|endTime=2016-02-11&chartType=userPie&indexName=Gender&clientId=101077
        removeChartsData()
        //数据链接
        let url = rootURL + "highcharts/getDataChart.cic";
        
        let parameters = [
            "para": "jsonfile=stat_channel_pie|bean=statUserPie|pieType=\(pieType)|mediaUserId=\(bean.id)|mediaType=\(bean.mediaUserType)|beginTime=\(time1)|endTime=\(time2)",
            "chartType":"userPie",
            "indexName":indexName,
            "clientId": bean.clientId
        ]
        
        Alamofire.request(.GET, url,parameters: parameters as? [String : AnyObject]).responseJSON{
            data in
            if(data.result.isSuccess){
                let json = data.result.value!;
//                print(json)
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

                }else{
                    
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
                }
            }else{
                if self.event_text == 1003{
                }else{
//                    Utils.alert_view(1011);
                }              }
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
        

    }
    
    func loadBarAndLineChartViewData(chart:ChartViewInterface,indexType:String,indexName:String){
        //192.168.4.172:16007/SocialListeningServer/highcharts/getDataChart.cic?para=jsonfile=stat_topic_mline|bean=statChannelMlineBean|type=MChart|labType=|pids=1906578485|limit=30|freq=day|dateId=|indexType=NUM_OF_R_FANS|mediaType=1|time1=2016-03-03|time2=2016-03-09|searchType=db&chartType=userTrend&indexName=New Fans&clientId=101077
        
        
        //数据链接
        let url = rootURL + "highcharts/getDataChart.cic";
        
        let parameters = [
            "para": "jsonfile=stat_topic_mline|bean=statChannelMlineBean|type=MChart|labType=|pids=\(bean.id)|limit=30|freq=day|dateId=|indexType=\(indexType)|mediaType=\(bean.mediaUserType)|time1=\(time1)|time2=\(time2)|searchType=db",
            "chartType":"userTrend",
            "indexName":indexName,
            "clientId": bean.clientId
        ]
        Alamofire.request(.GET, url,parameters: parameters as? [String : AnyObject]).responseJSON{
            data in
            //print(data)
            if(data.result.isSuccess){
                let json = data.result.value!;
                chart.setData(json,a: 3)
            }else{
                if self.event_text == 1003{
                }else{
//                    Utils.alert_view(1011);
                }              }
        }
    }
    
   
    
    func loadGroupedBarsChartViewData(chart:ChartViewInterface){
        //192.168.4.172:16007/SocialListeningServer/highcharts/getDataChart.cic?para=jsonfile=stat_channel_m_bar|bean=statMBar|barType=STAT_STATUS_TAG_DAY|mediaUserId=3245550107|mediaType=1|beginTime=2016-01-31|endTime=2016-02-29|accountId=28582|tagIds=1386501,1388416,1306160&chartType=userBar&indexName=TopicAnalysis&clientId=101077
        
        /*
        bean.id = 3245550107;
        bean.clientId = 28582;
        bean.mediaUserType = 1;
        */
        let url = rootURL + "weiboAccount/showAccountAnalysisInfo.cic";
        let parameters = [
            "analysisId": 4,
            "userId":bean.id,
            "mediaType":bean.mediaUserType,
            "beginTime": time1,
            "endTime": time2,
            "clientId":bean.clientId
            
        ]
        var tagStr = "";
        
        Alamofire.request(.GET, url,parameters: parameters as? [String : AnyObject]).responseJSON{
            data in
//            print(data)
            if(data.result.isSuccess){
                let json = data.result.value!;
                let jsonObj = Utils.stringToJson(json);

                if jsonObj.count > 0 {
                    for (var i = 0; i < jsonObj.count ; i++) {
                        let temp = jsonObj[i];
                        let accountId = temp.objectForKey("id") as! Int;
                        tagStr += "\(accountId),";
                        if i == jsonObj.count - 1 {
                            tagStr += "\(accountId)";
                        }
                    }
                    
                    if tagStr != "" {
                        self.doShowTagInfo(chart,tagIds: tagStr);
                    }

                }

                
            }else{
                if self.event_text == 1003{
                }else{
//                    Utils.alert_view(1011);
                }
            }
        }
        
    }
    
    
    func doShowTagInfo(chart:ChartViewInterface,tagIds:String){
        //highcharts/getDataChart.cic?para=jsonfile=stat_channel_m_bar|bean=statMBar|barType=STAT_STATUS_TAG_DAY|mediaUserId=3245550107|mediaType=1|beginTime=2016-01-31|endTime=2016-02-29|accountId=28582|tagIds=1386501,1388416,1306160&chartType=userBar&indexName=TopicAnalysis&clientId=101077
        
        //数据链接
        let url = rootURL + "highcharts/getDataChart.cic";

        //print(url)
        let parameters = [
        "para": "jsonfile=stat_channel_m_bar|bean=statMBar|barType=STAT_STATUS_TAG_DAY|mediaUserId=\(bean.id)|mediaType=\(bean.mediaUserType)|beginTime=\(time1)|endTime=\(time2)|accountId=\(bean.clientId)|tagIds=\(tagIds)",
        "chartType":"userBar",
        "indexName":"TopicAnalysis",
        "clientId": bean.clientId
        ]
        
//        print(parameters["para"])
//        print(parameters["chartType"])
//        print(parameters["indexName"])
//        print(parameters["clientId"])

        Alamofire.request(.GET, url,parameters: parameters as? [String : AnyObject]).responseJSON{
        data in
//            print(data)
            if(data.result.isSuccess){
                let json = data.result.value!;
                chart.setData(json,a: 0)
            }else{
                if self.event_text == 1003{
                }else{
//                    Utils.alert_view(1011);
                }
                chart.setData("{}",a: 0)

            }
        }
    }
    
    
    
    //charts引入
    let lineview1_1 = BarAndLinesChartViewTool()
    let barview1_2 = BarChartViewTool()
    let barview1_3 = BarChartViewTool()
    let pieview1_4 = PieChartViewTool()
    let pieview1_5 = PieChartViewTool()
    let lineview2_1 = BarAndLinesChartViewTool()
    let lineview2_2 = BarAndLinesChartViewTool()
    let groupedbarview2_4 = GroupedBarsViewTool()
    let lineview3_1 = BarAndLinesChartViewTool()
    let lineview3_2 = BarAndLinesChartViewTool()
    let lineview3_3 = BarAndLinesChartViewTool()
    
    let myView = NSBundle.mainBundle().loadNibNamed("PieCharts_tuglie", owner: nil, options: nil).last as? PieCharts_tuglie
    let myView2 = NSBundle.mainBundle().loadNibNamed("PieCharts_tuglie", owner: nil, options: nil).last as? PieCharts_tuglie
    
    func loadChartData(){
       
        
        let width = self.view.frame.width - 40;
        let charts_height = self.charts1view1.frame.size.height
        charts1view1.frame.size.width = width;
        charts1view2.frame.size.width = width
        charts1view3.frame.size.width = width
        charts1view4.frame.size.width = width
        charts1view5.frame.size.width = width
        charts2view1.frame.size.width = width
        charts2view2.frame.size.width = width
        charts2view4.frame.size.width = width
        charts2view5.frame.size.width = width
        charts3view1.frame.size.width = width
        charts3view2.frame.size.width = width
        charts3view3.frame.size.width = width
        charts3view4.frame.size.width = width
        


        
//        lineview1_1.frame.size.width = charts1view1.frame.size.width
//        lineview1_1.frame.size.height = charts1view1.frame.size.height - 20
        lineview1_1.frame = CGRect(x: 0, y: 20,width: width, height: charts_height - 20);
        let lineview1_1_label = UILabel()
        lineview1_1_label.font = UIFont.systemFontOfSize(14)
        lineview1_1_label.frame = CGRect(x: 5, y: 0,width: width, height: 20)
        lineview1_1_label.text = "New fans trend"
        barview1_2.frame = CGRect(x: 0, y: 20,width: width, height: charts_height - 20);
        let  barview1_2_label = UILabel()
        barview1_2_label.font = UIFont.systemFontOfSize(14)
        barview1_2_label.frame = CGRect(x: 5, y: 0,width: width, height: 20)
        barview1_2_label.text = "Number of fans distribution"
        barview1_3.frame = CGRect(x: 0, y: 20,width: width, height: charts_height - 20);
        let  barview1_3_label = UILabel()
        barview1_3_label.font = UIFont.systemFontOfSize(14)
        barview1_3_label.frame = CGRect(x: 5, y: 0,width: width, height: 20)
        barview1_3_label.text = "Geographical distribution"
        pieview1_4.frame.size.width = charts1view4.frame.size.width
        pieview1_4.frame.size.height =  235 - 20
        let  pieview1_4_label = UILabel()
        pieview1_4_label.font = UIFont.systemFontOfSize(14)
        pieview1_4_label.frame = CGRect(x: 5, y: 0,width: width, height: 20)
        pieview1_4_label.text = "Gender"
        pieview1_5.frame.size.width = charts1view4.frame.size.width
        pieview1_5.frame.size.height =  235 - 20
        let  pieview1_5_label = UILabel()
        pieview1_5_label.font = UIFont.systemFontOfSize(14)

        pieview1_5_label.frame = CGRect(x: 5, y: 0,width: width, height: 20)
        pieview1_5_label.text = "Verified fans"

        lineview2_1.frame = CGRect(x: 0, y: 20,width: width, height: charts_height - 20);
        let  lineview2_1_label = UILabel()
        lineview2_1_label.font = UIFont.systemFontOfSize(14)

        lineview2_1_label.frame = CGRect(x: 5, y: 0,width: width, height: 20)
        lineview2_1_label.text = "New tweet trend"
        lineview2_2.frame = CGRect(x: 0, y: 20,width: width, height: charts_height - 20);
        let  lineview2_2_label = UILabel()
        lineview2_2_label.font = UIFont.systemFontOfSize(14)

        lineview2_2_label.frame = CGRect(x: 5, y: 0,width: width, height: 20)
        lineview2_2_label.text = "Exposure"
        groupedbarview2_4.frame = CGRect(x: 0, y: 30,width: width, height: charts_height - 20);
        let  groupedbarview2_4_label = UILabel()
        groupedbarview2_4_label.font = UIFont.systemFontOfSize(14)

        groupedbarview2_4_label.frame = CGRect(x: 5, y: 0,width: width, height: 20)
        groupedbarview2_4_label.text = "Topic analysis"
        
        lineview3_1.frame = CGRect(x: 0, y: 20,width: width, height: charts_height - 20);
        let  lineview3_1_label = UILabel()
        lineview3_1_label.font = UIFont.systemFontOfSize(14)

        lineview3_1_label.frame = CGRect(x: 5, y: 0,width: width, height: 20)
        lineview3_1_label.text = "Retweets"
        lineview3_2.frame = CGRect(x: 0, y: 20,width: width, height: charts_height - 20);
        let  lineview3_2_label = UILabel()
        lineview3_2_label.font = UIFont.systemFontOfSize(14)

        lineview3_2_label.frame = CGRect(x: 5, y: 0,width: width, height: 20)
        lineview3_2_label.text = "Direct@"
        lineview3_3.frame = CGRect(x: 0, y: 20,width: width, height: charts_height - 20);
        let  lineview3_3_label = UILabel()
        lineview3_3_label.font = UIFont.systemFontOfSize(14)

        lineview3_3_label.frame = CGRect(x: 5, y: 0,width: width, height: 20)
        lineview3_3_label.text = "Comments"
        
        let  tableview2_5_label = UILabel()
        tableview2_5_label.font = UIFont.systemFontOfSize(14)

        tableview2_5_label.frame = CGRect(x: 5, y: 0,width: width, height: 20)
        tableview2_5_label.text = "Hot content"
        let  tableview3_4_label = UILabel()
        tableview3_4_label.font = UIFont.systemFontOfSize(14)

        tableview3_4_label.frame = CGRect(x: 5, y: 0,width: width, height: 20)
        tableview3_4_label.text = "Interaction"
        
        
        loadChartsData();

        let b = UIView()
        myView?.frame = CGRect(x: 0, y: 235,width: width, height: 200);
        b.frame = CGRect(x: 0, y: 0,width: width, height: 200);
        charts1view4.addSubview(b)
        b.addSubview(myView!)
        
        let c = UIView()
        myView2?.frame = CGRect(x: 0, y: 235,width: width, height: 200);
        c.frame = CGRect(x: 0, y: 0,width: width, height: 200);
        charts1view5.addSubview(c)
        c.addSubview(myView2!)
        
        charts1view1.addSubview(lineview1_1)
        charts1view1.addSubview(lineview1_1_label)
        charts1view2.addSubview(barview1_2)
        charts1view2.addSubview(barview1_2_label)
        charts1view3.addSubview(barview1_3)
        charts1view3.addSubview(barview1_3_label)
        charts1view4.addSubview(myView!)
        charts1view4.addSubview(pieview1_4)
        charts1view4.addSubview(pieview1_4_label)
        charts1view5.addSubview(pieview1_5)
        charts1view5.addSubview(pieview1_5_label)

        charts2view1.addSubview(lineview2_1)
        charts2view1.addSubview(lineview2_1_label)

        charts2view2.addSubview(lineview2_2)
        charts2view2.addSubview(lineview2_2_label)

        charts2view4.addSubview(groupedbarview2_4)
        charts2view4.addSubview(groupedbarview2_4_label)
        charts2view5.addSubview(tableview2_5_label)
        
        charts3view1.addSubview(lineview3_1)
        charts3view2.addSubview(lineview3_2)
        charts3view3.addSubview(lineview3_3)
        charts3view1.addSubview(lineview3_1_label)
        charts3view2.addSubview(lineview3_2_label)
        charts3view3.addSubview(lineview3_3_label)
        charts3view4.addSubview(tableview3_4_label)
    }
    
    func loadChartsData(){
        if event_text != 1001{
            Utils.alert_view(self.event_text);
            return;
        }
        self.pleaseWait();
        removeNetError()
        loadBarAndLineChartViewData(lineview1_1,indexType:"NUM_OF_R_FANS",indexName: "New Fans Trend");
        loadBarAndLineChartViewData(lineview2_1,indexType:"NUM_OF_TWEETS",indexName: "New Tweets");
        loadBarAndLineChartViewData(lineview2_2,indexType:"NUM_OF_EX_FANS",indexName: "Exposure");
        loadBarAndLineChartViewData(lineview3_1,indexType:"NUM_OF_PASSIVE_MENTION",indexName: "Passive Mention");
        loadBarAndLineChartViewData(lineview3_2,indexType:"NUM_OF_ACTIVE_MENTION",indexName: "Active Mention");
        loadBarAndLineChartViewData(lineview3_3,indexType:"NUM_OF_BECOMMENTS",indexName: "Commented");
        loadBarChartViewData(barview1_2,barType:"STAT_USER_FANS_FANS",indexName: "Number of Fans Distribution")
        loadBarChartViewData(barview1_3,barType:"STAT_USER_DAY_FANS_PROVINCE",indexName: "Geographical Distribution")
        loadPieChartViewData(pieview1_4,pieType:"STAT_USER_DAY_FANS_GENDER",indexName: "Gender",which: 1)
        loadPieChartViewData(pieview1_5,pieType:"STAT_USER_FANS_DAY_VER",indexName: "Verified Fans",which: 2)
//        loadBarAndLineChartViewData(barlineview2_3)
        loadGroupedBarsChartViewData(groupedbarview2_4)
        loadHotContentData()
        loadInterActionData()

    }
    
    
    func reachabilityChanged(note: NSNotification) {
            
            let reachability = note.object as! Reachability
            
            if reachability.isReachable() {
            if reachability.isReachableViaWiFi() {
            print("Weibo Reachable via WiFi")
            event_text = 1001

        } else {
            print("Weibo Reachable via Cellular")
            event_text = 1001

            }
        } else {
            print("Weibo Not reachable")
            xwDelay(0.1) { () -> Void in
//            Utils.alert_view(1003)
            if self.tablebean1.isEmpty{
            self.addErrorView()
                }
            }
            event_text = 1003
                

        }
    }
    
    func addErrorView(){
            sv.hidden = true
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
    
    func addBorder(view:UIView){
        view.layer.borderColor = UIColor.lightGrayColor().CGColor;
        view.layer.borderWidth = 0.5;
    }
    
    func reloadEvent(){
        loadChartsData()
        loadWeiboBaseInfo();
    }
    
    func removeNetError(){
        loadImg?.removeFromSuperview()
        loadLabel?.removeFromSuperview()
        sv.hidden = false
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func scrollViewDidScroll(scrollView:UIScrollView){
        let offsetY: CGFloat = scrollView.contentOffset.y
        let offsetX: CGFloat = scrollView.contentOffset.x
        let width = self.view.frame.width
        let offsetX1 = sv1.contentOffset.x - 8
        let offsetX2 = sv2.contentOffset.x - 8
        let offsetX3 = sv3.contentOffset.x - 8
        let index = offsetX1 / width
        let index2 = offsetX2 / width
        let index3 = offsetX3 / width
        self.pc1.currentPage = Int(index + 1)
        self.pc2.currentPage = Int(index2 + 1)
        self.pc3.currentPage = Int(index3 + 1)
        main_view.bringSubviewToFront(segmented_control)
        if scrollView == sv {
        // 处理segmented_control
            if offsetY >= 150 || offsetX>0 {
                segmented_control.frame = CGRect(x: 20, y: offsetY, width: AppWidth-40, height: segmented_control.height)
                segmented_control.backgroundColor = UIColor.whiteColor()
//                segmented_control.enabled = false
            } else if(offsetY < 100){
                segmented_control.frame = CGRect(x: 20, y: 155, width: AppWidth-40, height: segmented_control.height)
                segmented_control.enabled = true

                }
        }else{
            if lastOffsetY>150{
                segmented_control.frame = CGRect(x: 20, y: lastOffsetY, width: AppWidth-40, height: segmented_control.height)
                }
            }
        lastOffsetY = offsetY
    }
    

    @IBAction func doBack(sender: AnyObject) {
        self.clearAllNotice()
        self.dismissViewControllerAnimated(true, completion: nil);
       // UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent;
    }
    
    
     func segmentedAction(sender: UISegmentedControl) {
        
//        segmented_control
        switch segmented_control.selectedSegmentIndex{
        case 0:
            time1 = Utils.getDateString(-2);
            loadChartsData()

        case 1:
            time1 = Utils.getDateString(-7);
            loadChartsData()


        case 2:
            time1 = Utils.getDateString(-14);
            loadChartsData()


        case 3:
            time1 = Utils.getDateString(-30);
            loadChartsData()

        default:
            time1 = Utils.getDateString(-7);
            loadChartsData()

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
extension WeiboDetail: UITableViewDelegate, UITableViewDataSource {
    
    //获取tableviewcell个数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView == tableview1{
//            print("tablebean.count\(tablebean1.count)")
            return tablebean1.count
        }
        if tableView == tableview2{
            return tablebean2.count
        }
        return 0 
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 35
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == tableview1 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("hot_contentCell", forIndexPath: indexPath) as! Hot_ContentCell
            let tablebean = tablebean1[indexPath.row];
//            cell.label1.text = tablebean.content
            cell.label1.text = Utils.StringChanged(tablebean.content)
            cell.label2.text = Utils.StringChanged(String(tablebean.hotretweets))
            cell.label3.text = Utils.StringChanged(String(tablebean.comments))
            cell.label4.text = Utils.StringChanged(String(tablebean.likes))

            if(indexPath.row % 2 == 0){
                cell.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 249/255, alpha: 1)
            }
//            cell.model = tablebean
            return cell
        }
        if tableView == tableview2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("interactionCell", forIndexPath: indexPath) as! InteractionCell
            let tablebean = tablebean2[indexPath.row];
            cell.label1.text = tablebean.name
            cell.label1_width.constant = (self.view.frame.width-22) / 4
            cell.label2.text = String(tablebean.activeMention)
            cell.label2_width.constant = (self.view.frame.width-22) / 4
            cell.label3.text = String(tablebean.passiveMention)
            cell.label3_width.constant = (self.view.frame.width-22) / 4
            cell.label4.text = String(tablebean.comments)
            cell.label4_width.constant = (self.view.frame.width-22) / 4
            if(indexPath.row % 2 == 0){
                cell.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 249/255, alpha: 1)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    //tableViewCell点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}

