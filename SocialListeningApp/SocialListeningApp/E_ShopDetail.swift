//
//  E_ShopDetail.swift
//  SocialListeningApp
//
//  Created by ciccic on 16/4/8.
//  Copyright © 2016年 cicdata. All rights reserved.
//

import Foundation
import UIKit
import Charts
import Alamofire


class E_ShopDetail: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var sv: UIScrollView!
    
    @IBOutlet weak var sales_view: UIScrollView!
    
    @IBOutlet weak var conversion_view: UIScrollView!
    
    @IBOutlet weak var screen_height: NSLayoutConstraint!
    
    @IBOutlet weak var sales_pagecontrol: UIPageControl!
    
    @IBOutlet weak var conversion_pagecontrol: UIPageControl!
    
    @IBOutlet weak var sales_label: UILabel!

    @IBOutlet weak var uv_label: UILabel!
    
    @IBOutlet weak var conversion_label: UILabel!
    
    @IBOutlet weak var buyer_label: UILabel!
    
    @IBOutlet weak var payment_label: UILabel!
    
    @IBOutlet weak var spent_label: UILabel!
    
    @IBOutlet weak var from_view: UIView!
    
    @IBOutlet weak var from_label: UILabel!
    
    @IBOutlet weak var to_view: UIView!
    
    @IBOutlet weak var to_label: UILabel!
    
    @IBOutlet weak var date_segment: UIView!
    
    @IBOutlet weak var main_view: UIView!
    
    @IBOutlet weak var view1_1: UIView!
    
    @IBOutlet weak var view2_2: UIView!

    @IBOutlet weak var view2_3: UIView!
    
    @IBOutlet weak var view2_1: UIView!
    
    @IBOutlet weak var view1_2: UIView!
    
    @IBOutlet weak var view1_3: UIView!
    
    var oldY:CGFloat = 0.0;
    var newY:CGFloat = 0.0;
    
    let navtitle:UILabel? = UILabel()
    
    let bean = E_shopBean()
    var beans = CampaignBean()

    private var time1 = "";
    private var time2 = "";
    
    var json:AnyObject = []

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
    
    let customerId = NSUserDefaults.standardUserDefaults().valueForKey("customerId") as! Int;

    override func viewDidLoad() {
        time1 = beans.time1
        time2 = beans.time2
        time1 = time1.stringByReplacingOccurrencesOfString("/", withString: "-", options: NSStringCompareOptions.LiteralSearch, range: nil)
        time2 = time2.stringByReplacingOccurrencesOfString("/", withString: "-", options: NSStringCompareOptions.LiteralSearch, range: nil)
        self.from_label.text = time1.stringByReplacingOccurrencesOfString("-", withString: "/", options: NSStringCompareOptions.LiteralSearch, range: nil)
        self.to_label.text = time2.stringByReplacingOccurrencesOfString("-", withString: "/", options: NSStringCompareOptions.LiteralSearch, range: nil)

        screen_height.constant = 1200
        self.automaticallyAdjustsScrollViewInsets = false
        sv.delegate = self
        //navigationbar
        navtitle!.text = beans.name
        navtitle!.textColor = UIColor.blackColor()
        navtitle!.frame = CGRectMake(0, 0, 10, 20)
        navigationItem.titleView = navtitle
        showsalesview()
        showconversionview()
        let tag1 = UITapGestureRecognizer(target: self, action: "date_changed");
        from_view.addGestureRecognizer(tag1);
        let tag2 = UITapGestureRecognizer(target: self, action: "date_changed_to");
        to_view.addGestureRecognizer(tag2);
        addViewBorder()
        loadViewData()
    }
    
    func addViewBorder(){
        addBorder(date_segment)
        addBorder(view1_1)
        addBorder(view1_2)
        addBorder(view1_3)
        addBorder(view2_1)
        addBorder(view2_2)
        addBorder(view2_3)

    }
    
    func date_changed(){
        let alertController:UIAlertController=UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        // 初始化 datePicker
        let datePicker = UIDatePicker( )
        //将日期选择器区域设置为中文，则选择器日期显示为中文
        datePicker.locale = NSLocale(localeIdentifier: "zh_CN")
        // 设置样式，当前设为同时显示日期和时间
        datePicker.datePickerMode = UIDatePickerMode.Date
        // 设置日期范围（超过日期范围，会回滚到最近的有效日期）
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let maxDate = dateFormatter.dateFromString(time2)
        let minDate = dateFormatter.dateFromString(beans.time1)
        datePicker.maximumDate = maxDate
        datePicker.minimumDate = minDate
        // 设置默认时间
        datePicker.date = minDate!
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default){
            (alertAction)->Void in
            let text_string = dateFormatter.stringFromDate(datePicker.date)
            let filtered = text_string.stringByReplacingOccurrencesOfString("-", withString: "/", options: NSStringCompareOptions.LiteralSearch, range: nil)
            self.from_label.text = filtered
            self.from_label.adjustsFontSizeToFitWidth = true
            self.time1 = text_string
            self.upPullLoadData()
            })
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel,handler:nil))
        alertController.view.addSubview(datePicker)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func date_changed_to(){
        let alertController:UIAlertController=UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        // 初始化 datePicker
        let datePicker = UIDatePicker( )
        //将日期选择器区域设置为中文，则选择器日期显示为中文
        datePicker.locale = NSLocale(localeIdentifier: "zh_CN")
        // 设置样式，当前设为同时显示日期和时间
        datePicker.datePickerMode = UIDatePickerMode.Date
        // 设置日期范围（超过日期范围，会回滚到最近的有效日期）
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let maxDate = dateFormatter.dateFromString(beans.time2)
        let minDate = dateFormatter.dateFromString(time1)
        datePicker.maximumDate = maxDate
        datePicker.minimumDate = minDate
        // 设置默认时间
        datePicker.date = maxDate!
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default){
            (alertAction)->Void in
            let text_string = dateFormatter.stringFromDate(datePicker.date)
            let filtered = text_string.stringByReplacingOccurrencesOfString("-", withString: "/", options: NSStringCompareOptions.LiteralSearch, range: nil)
            self.to_label.text = filtered
            self.to_label.adjustsFontSizeToFitWidth = true
            self.time2 = text_string
            self.upPullLoadData()
            })
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel,handler:nil))
        alertController.view.addSubview(datePicker)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func loadPieChartViewData(chart:ChartViewInterface,b:Int){
        //数据链接
        removeChartsData()
        let url = rootURL + "campaign/getEShopDetail.cic";
        let parameters = [
            "customerId": customerId,
            "shopName": beans.name,
            "startDate": time1,
            "endDate": time2
//            "customerId": 124,
//            "shopName": "test1",
//            "startDate": "2015-11-11",
//            "endDate": "2015-12-11"
        ]
//        print(time1)
//        print(time2)
        Alamofire.request(.GET, url,parameters: parameters as? [String : AnyObject]).responseJSON{
            data in
            print(data)
            if(data.result.isSuccess){
                self.json = data.result.value!;
                chart.setData(self.json,a: b)
                var pie_data = [:]
                pie_data = chart.setData(self.json,a: b)
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
            }else{
            }
        }
    }
    
    func removeChartsData(){
        pie_View?.image1.hidden = true
        pie_View?.image2.hidden = true
        pie_View?.image3.hidden = true
        pie_View?.image4.hidden = true
        pie_View?.name_label1.text = ""
        pie_View?.name_label2.text = ""
        pie_View?.name_label3.text = ""
        pie_View?.name_label4.text = ""
        pie_View?.number_label1.text = ""
        pie_View?.number_label2.text = ""
        pie_View?.number_label3.text = ""
        pie_View?.number_label4.text = ""
    }
    
    func loadBarAndLineChartViewData(chart:ChartViewInterface,b:Int,url_type:Int){
        //数据链接
        var url :String
        if url_type == 1 {
            url = rootURL + "campaign/getEShopInfo.cic";
        }else{
            url = rootURL + "campaign/getEShopDetail.cic";
        }
        let parameters = [
            "customerId": customerId,
            "shopName": beans.name,
            "startDate": time1,
            "endDate": time2
//            "customerId": 124,
//            "shopName": "test1",
//            "startDate": "2015-11-11",
//            "endDate": "2015-12-11"
        ]
        //        print(bean.id)
        Alamofire.request(.GET, url,parameters: parameters as? [String : AnyObject]).responseJSON{
            data in
//            print(data)
            if(data.result.isSuccess){
                self.json = data.result.value!;
                chart.setData(self.json,a: b)
            }else{
            }
        }
    }
    
    
    func loade_shop_view(conver:Int){
        self.pleaseWait()
        //SocialListeningServer/campaign/getEShopInfo.cic?customerId=124&shopName=test1&startDate=2015-11-11&endDate=2015-12-11
        //数据链接，解析
        let url = rootURL + "campaign/getEShopDetail.cic";
        let parameters = [
            "customerId": customerId,
            "shopName": beans.name,
            "startDate": time1,
            "endDate": time2
//            "customerId": 124,
//            "shopName": "test1",
//            "startDate": "2015-11-11",
//            "endDate": "2015-12-11"
        ]
        Alamofire.request(.GET, url,parameters: parameters as! [String : NSObject]).responseJSON{
            data in
//                        print(data)
            if(data.result.isSuccess){
                self.json = data.result.value!;
                if (!NSJSONSerialization.isValidJSONObject(self.json)) {
                    Utils.alert_view(1008);
                }else{
                    let result = self.json.objectForKey("result");
//                    print(result)
                    if result is NSNull {
                    }else{
                        if let _ = result{
                        if conver == 1{
                            let conversion = result!.objectForKey("conversion")
                            let conversion2 = result!.objectForKey("conversion") as! NSArray

                            if let _ = conversion{
                            if conversion is NSNull  {
                            }else{
                                if  conversion?.count !== 0 {
                                let a = conversion![0].objectForKey("imp") as! NSNumber
                                let b = conversion![0].objectForKey("click") as! NSNumber
                                let c = conversion![0].objectForKey("orders") as! NSNumber
                                let d = conversion![0].objectForKey("paymentOrders") as! NSNumber
                                let e = conversion![0].objectForKey("sales") as! NSNumber

                                self.bean.value1 = "IMP:\(a)"
                                self.bean.value2 = "Click:\(b)"
                                self.bean.value3 = "Orders:\(c)"
                                self.bean.value4 = "Payment Orders:\(d)"
                                self.bean.value5 = "Sales:\(e)"
                                self.myView!.model = self.bean;
                                }
                                }}
                        }else{
                            let conversion = result!.objectForKey("conversion_total")
                            if let _ = conversion{

                            if conversion is NSNull {
                            }else{
                                if  conversion?.count !== 0 {

                                let a = conversion!.objectForKey("imp") as! NSNumber
                                let b = conversion!.objectForKey("click") as! NSNumber
                                let c = conversion!.objectForKey("orders") as! NSNumber
                                let d = conversion!.objectForKey("paymentOrders") as! NSNumber
                                let e = conversion!.objectForKey("sales") as! NSNumber
                                
                                self.bean.value1 = "IMP:\(a)"
                                self.bean.value2 = "Click:\(b)"
                                self.bean.value3 = "Orders:\(c)"
                                self.bean.value4 = "Payment Orders:\(d)"
                                self.bean.value5 = "Sales:\(e)"
                                self.myView2!.model = self.bean;
                                }}
                            }}
                        }
                    }
                }
            }else{
                
            }
            self.clearAllNotice();
        }
    }
    
    
    
    let pieview1_1 = PieChartViewTool()
    let pie_View = NSBundle.mainBundle().loadNibNamed("PieCharts_tuglie", owner: nil, options: nil).last as? PieCharts_tuglie
    let bar_lines1_2 = BarAndLinesChartViewTool();
    let bar_lines1_3 = BarAndLinesChartViewTool();

    
    func showsalesview(){
        //关闭滚动条显示
        sales_view.showsHorizontalScrollIndicator = false
        sales_view.showsVerticalScrollIndicator = false
        sales_view.scrollsToTop = false
        sales_view.bounces=false
        
        //协议代理，在本类中处理滚动事件
        sales_view.delegate = self
        //滚动时只能停留到某一页
        sales_view.pagingEnabled = true
        
        let width = AppWidth - 22;
        
        //设置scrollView的内容总尺寸
        sales_view.contentSize = CGSizeMake(
            CGFloat(width) * CGFloat(3),
            CGRectGetHeight(self.sales_view.bounds)
        )
        let size = sales_view.bounds.size;
        
        pieview1_1.frame = CGRect(x: CGFloat(0) * (width), y: 20,width: width, height: 235 - 20);
        let b = UIView()
        pie_View?.frame = CGRect(x: 0, y: 0,width: width, height: 200);
        b.frame = CGRect(x: CGFloat(0) * (width), y: 235,width: width, height: 200);
        b.addSubview(pie_View!)
        let pieview1_1_label = UILabel()
        pieview1_1_label.font = UIFont.systemFontOfSize(14)

        pieview1_1_label.frame = CGRect(x: CGFloat(0) * (width) + 5, y: 0,width: width, height: 20)
        pieview1_1_label.text = "IMP"
        bar_lines1_2.frame = CGRect(x: CGFloat(1) * (width), y: 20,width: width, height: size.height - 20);
        let bar_lines1_2_label = UILabel()
        bar_lines1_2_label.font = UIFont.systemFontOfSize(14)

        bar_lines1_2_label.frame = CGRect(x: CGFloat(1) * (width) + 5, y: 0,width: width, height: 20)
        bar_lines1_2_label.text = "UV"
        bar_lines1_3.frame = CGRect(x: CGFloat(2) * (width), y: 20,width: width, height: size.height - 20);
        let bar_lines1_3_label = UILabel()
        bar_lines1_3_label.font = UIFont.systemFontOfSize(14)

        bar_lines1_3_label.frame = CGRect(x: CGFloat(2) * (width) + 5, y: 0,width: width, height: 20)
        bar_lines1_3_label.text = "Buyers"
        
        loadSalesChartsData();
        sales_view.addSubview(pieview1_1)
        sales_view.addSubview(b)
        sales_view.addSubview(bar_lines1_2)
        sales_view.addSubview(bar_lines1_3)
        
        sales_view.addSubview(pieview1_1_label)
        sales_view.addSubview(bar_lines1_2_label)
        sales_view.addSubview(bar_lines1_3_label)

//        addBorder(pieview1_1)
//        addBorder(bar_lines1_2)
//        addBorder(bar_lines1_3)

        
        sales_pagecontrol.numberOfPages = 3;
        sales_pagecontrol.currentPage = 0
        //设置页控件点击事件
        sales_pagecontrol.addTarget(self, action: "pageChanged:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func loadSalesChartsData(){
        loadPieChartViewData(pieview1_1,b: 5)
        loadBarAndLineChartViewData(bar_lines1_2, b: 1,url_type: 1)
        loadBarAndLineChartViewData(bar_lines1_3, b: 2,url_type: 2)

    }
    
    let myView = NSBundle.mainBundle().loadNibNamed("Campaign_Charts_View", owner: nil, options: nil).last as? Campagin_charts_view
    let myView2 = NSBundle.mainBundle().loadNibNamed("Campaign_Charts_View", owner: nil, options: nil).last as? Campagin_charts_view


    
    func showconversionview(){
        
        //关闭滚动条显示
        conversion_view.showsHorizontalScrollIndicator = false
        conversion_view.showsVerticalScrollIndicator = false
        conversion_view.scrollsToTop = false
        conversion_view.bounces=false
        
        //协议代理，在本类中处理滚动事件
        conversion_view.delegate = self
        //滚动时只能停留到某一页
        conversion_view.pagingEnabled = true
        
        let width = AppWidth - 22;
        
        //设置scrollView的内容总尺寸
        conversion_view.contentSize = CGSizeMake(
            CGFloat(width) * CGFloat(2),
            CGRectGetHeight(self.conversion_view.bounds)
        )
        let size = conversion_view.bounds.size;
        let b = UIView()
        myView?.frame = CGRect(x: 0, y: 0,width: width, height: size.height);
        myView?.name_label.text = "Conversion.Total"
        b.frame = CGRect(x: CGFloat(0) * (width), y: 0,width: width, height: size.height);
        conversion_view.addSubview(b)
        b.addSubview(myView!)
        
//        addBorder(myView!)
        let c = UIView()
        myView2?.frame = CGRect(x: 0, y: 0,width: width, height: size.height);
        myView2?.name_label.text = "Conversion.Campaign"
        c.frame = CGRect(x: CGFloat(1) * (width), y: 0,width: width, height: size.height);
        conversion_view.addSubview(c)
        c.addSubview(myView2!)
//        addBorder(myView2!)
        loadconversionChartsData()
        conversion_pagecontrol.numberOfPages = 2;
        conversion_pagecontrol.currentPage = 0
        //设置页控件点击事件
        conversion_pagecontrol.addTarget(self, action: "pageChanged:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func loadconversionChartsData(){
//        bean.value1 = "bbb"
        
        loade_shop_view(1)
        loade_shop_view(2)

        
    }
    
    func loadViewData(){
        self.pleaseWait()
        //SocialListeningServer/campaign/getEShopInfo.cic?customerId=124&shopName=test1&startDate=2015-11-11&endDate=2015-12-11
        //数据链接，解析
        let url = rootURL + "campaign/getEShopInfo.cic";
//        let customerId = NSUserDefaults.standardUserDefaults().valueForKey("customerId") as! Int;
        let parameters = [
            "customerId": customerId,
            "shopName": beans.name,
            "startDate": time1,
            "endDate": time2
            
//            "customerId": 124,
//            "shopName": "test1",
//            "startDate": "2015-11-11",
//            "endDate": "2015-12-11"
            
        ]
        Alamofire.request(.GET, url,parameters: parameters as! [String : NSObject]).responseJSON{
            data in
//            print(data)
            if(data.result.isSuccess){
                let json = data.result.value!;
                if (!NSJSONSerialization.isValidJSONObject(json)) {
                    Utils.alert_view(1008);
                }else{
//                    let jsonObj = Utils.stringToJson(json);
//                    for(var i = 0 ; i < jsonObj.count; i++){
//                        let temp = jsonObj[i]
//                        let bean = CampaignBean()
                        let result = json.objectForKey("result");
//                        print(result)
                        if result is NSNull {
                        }else{
                            if let _ = result{
                            let salesa = result!.objectForKey("sales") as! Int
                            let uva = result!.objectForKey("uv") as! Int
                            let buyera = result!.objectForKey("buyer") as! Int
                            let paymenta = result!.objectForKey("orders") as! Int
                            self.sales_label.text = "\(salesa)"
                            self.uv_label.text = "\(uva)"
                            self.buyer_label.text = "\(buyera)"
                            self.payment_label.text = "\(paymenta)"
                            self.spent_label.text = result!.objectForKey("spent") as? String
                            self.conversion_label.text = result!.objectForKey("conversion") as? String
                        }
                    }
                }
            }else{
                
            }
            self.clearAllNotice();
        }
    }
    
    func upPullLoadData(){
        //print("下拉刷新");
        removeAllData()
        loadViewData();
        showsalesview()
        showconversionview()
    }
    
    func removeAllData(){
        sales_label.text = ""
        uv_label.text = ""
        buyer_label.text = ""
        conversion_label.text = ""
        spent_label.text = ""
        json = []
        bean.value1 = ""
        bean.value2 = ""
        bean.value3 = ""
        bean.value4 = ""
        bean.value5 = ""
        bean.value6 = ""

    }
    
    
    //点击页控件时事件处理
    func pageChanged(sender:UIPageControl) {
        //根据点击的页数，计算scrollView需要显示的偏移量
        print("pagechanged");
    }
    
    //UIScrollViewDelegate方法，每次滚动结束后调用
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        if let _ = sales_view {
            if scrollView == sales_view {
                //通过scrollView内容的偏移计算当前显示的是第几页
                var page = Int(scrollView.contentOffset.x / sales_view.frame.size.width)
                //设置pageController的当前页
                if page > 2 {
                    page = 2;
                }
                sales_pagecontrol.currentPage = page
            }
        }
        if let _ = conversion_view {
            if scrollView == conversion_view {
                //通过scrollView内容的偏移计算当前显示的是第几页
                var page = Int(scrollView.contentOffset.x / conversion_view.frame.size.width)
                //print("page:\(page)");
                //设置pageController的当前页
                if page > 5 {
                    page = 5;
                }
                conversion_pagecontrol.currentPage = page
            }
        }
    }
    
    func scrollViewDidScroll(scrollView:UIScrollView){
        if scrollView == sv {
            let offsetY: CGFloat = scrollView.contentOffset.y
            //            print(offsetY)
            // 处理segmented_control
            if offsetY >= 0 {
                newY = offsetY;
                date_segment.frame = CGRect(x: date_segment.x, y: offsetY, width: AppWidth + 10, height: date_segment.height)
                //                    able.frame = CGRect(x: 0, y: 100, width: AppWidth, height: 140)
                //                    able2.frame = CGRect(x: 0, y: 100+140, width: AppWidth+5, height: AppHeight)
                self.main_view.bringSubviewToFront(date_segment)
            } else {
                date_segment.frame = CGRect(x: date_segment.x, y: self.oldY, width: AppWidth + 10, height: date_segment.height)
                //                    able.frame = CGRect(x: 0, y: -offsetY+200, width: AppWidth, height: 140)
                //                    able2.frame = CGRect(x: 0, y: -offsetY+200+140, width: AppWidth+5, height: AppHeight)
            }
        }
    }
    
    func addBorder(view:UIView){
        view.layer.borderColor = UIColor.lightGrayColor().CGColor;
        view.layer.borderWidth = 0.5;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func daback(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
}