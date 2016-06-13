//
//  CampaignDetail.swift
//  SocialListeningApp
//
//  Created by ciccic on 16/4/8.
//  Copyright © 2016年 cicdata. All rights reserved.
//

import Foundation
import UIKit
import Charts
import Alamofire


class CampaignDetail: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var screen_height: NSLayoutConstraint!
    
    @IBOutlet weak var sv: UIScrollView!
    
    let navtitle:UILabel? = UILabel()
    
    @IBOutlet weak var overview: UIScrollView!
    
    @IBOutlet weak var overview_border: UIView!
    
    @IBOutlet weak var taview: UIScrollView!

    @IBOutlet weak var taview_border: UIView!
    
    @IBOutlet weak var geoview: UIScrollView!
    
    @IBOutlet weak var geoview_border: UIView!
    
    @IBOutlet weak var over_pageControl: UIPageControl!
    
    @IBOutlet weak var ta_pageControl: UIPageControl!
    
    @IBOutlet weak var geo_pageControl: UIPageControl!
    
    var bean = CampaignBean()

    @IBOutlet weak var imp_label: UILabel!
    
    @IBOutlet weak var click_label: UILabel!
    
    @IBOutlet weak var uv_label: UILabel!
    
    @IBOutlet weak var tauv_label: UILabel!
    
    @IBOutlet weak var ctr_label: UILabel!
    
    @IBOutlet weak var cpm_label: UILabel!
    
    @IBOutlet weak var cpc_label: UILabel!
    
    @IBOutlet weak var cpuv_label: UILabel!
    
    @IBOutlet weak var e_com_label: UILabel!
    
    @IBOutlet weak var delivery_label: UILabel!
    

    @IBOutlet weak var from_label: UILabel!
    
    @IBOutlet weak var to_label: UILabel!
    
    @IBOutlet weak var platform_label: UILabel!
    
    @IBOutlet weak var border_view: UIView!
    
    @IBOutlet weak var content_view: UIView!
    
    @IBOutlet weak var view11: UIView!
    
    @IBOutlet weak var view22: UIView!
    @IBOutlet weak var view23: UIView!
    @IBOutlet weak var view21: UIView!
    @IBOutlet weak var view31: UIView!
    @IBOutlet weak var view41: UIView!
    @IBOutlet weak var view12: UIView!
    @IBOutlet weak var view13: UIView!
    @IBOutlet weak var view32: UIView!
    @IBOutlet weak var view33: UIView!
    
    
    @IBOutlet weak var cpmnorm: UILabel!
    @IBOutlet weak var cpcnorm: UILabel!
    @IBOutlet weak var cpuvnorm: UILabel!
    @IBOutlet weak var ctrnorm: UILabel!
    
    @IBOutlet weak var date_segment: UIView!
    
    @IBOutlet weak var cam_main_view: UIView!
    var oldY:CGFloat = 0.0;
    var newY:CGFloat = 0.0;
    
    @IBOutlet weak var platfrom_view: UIView!
    
    private var platform = 2;
    
    @IBOutlet weak var platfrom_label: UILabel!
    
    private var e_shop_changed = 1
    
    @IBOutlet weak var e_shop_button: UIBarButtonItem!
    
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
        screen_height.constant = 1850
        self.automaticallyAdjustsScrollViewInsets = false
        sv.delegate = self
        //navigationbar
        navtitle!.text = bean.name
        navtitle!.textColor = UIColor.blackColor()
        navtitle!.frame = CGRectMake(0, 0, 10, 20)
        navigationItem.titleView = navtitle
        from_label.text = bean.time1.stringByReplacingOccurrencesOfString("-", withString: "/", options: NSStringCompareOptions.LiteralSearch, range: nil)
        to_label.text = bean.time2.stringByReplacingOccurrencesOfString("-", withString: "/", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        platform_label.text = String(bean.platform)
        addviewborder()
        showDetailInfo()
        showoverview()
        showtaview()
        showgeoview()
        oldY = date_segment.frame.origin.y;
        newY = oldY;
        let tag2 = UITapGestureRecognizer(target: self, action: "paltfrom_changed");
        platfrom_view.addGestureRecognizer(tag2)
        
        xwDelay(1) { () -> Void in
            self.e_shop_view()
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func paltfrom_changed(){
        let alertController:UIAlertController=UIAlertController()
        
        alertController.addAction(UIAlertAction(title: "PC", style: UIAlertActionStyle.Default){
            (alertAction)->Void in
            self.platfrom_label.text = "PC"
            self.platform = 0
            self.upPullLoadData()
            })
        alertController.addAction(UIAlertAction(title: "Mobile", style: UIAlertActionStyle.Default){
            (alertAction)->Void in
            self.platfrom_label.text = "Mobile"
            self.platform = 1
            self.upPullLoadData()
            
            })
        alertController.addAction(UIAlertAction(title: "P+M", style: UIAlertActionStyle.Default){
            (alertAction)->Void in
            self.platfrom_label.text = "P+M"
            self.platform = 2
            self.upPullLoadData()
            
            })
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel,handler:nil))
        
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func upPullLoadData(){
        //print("下拉刷新");
//        beans.removeAll();
        remove_view_all()
        showDetailInfo()
        loadoverChartsData();
        loadtaChartsData()
        loadgeoChartsData()
        xwDelay(1) { () -> Void in
            self.e_shop_view()
        }
    }
    
    func remove_view_all(){
        imp_label.text  = ""
        click_label.text  = ""
        uv_label.text  = ""
        tauv_label.text  = ""
        ctr_label.text  = ""
        cpm_label.text  = ""
        cpc_label.text  = ""
        cpuv_label.text  = ""
        e_com_label.text  = ""
        delivery_label.text  = ""
        
        cpmnorm.text = ""
        cpcnorm.text = ""
        cpuvnorm.text = ""
        ctrnorm.text = ""
    }
    
    func showDetailInfo(){
        imp_label.text  = String(bean.imp)
        click_label.text  = String(bean.click)
        uv_label.text  = String(bean.uv)
        tauv_label.text  = String(bean.tauv)
        ctr_label.text  = bean.ctr
        cpm_label.text  = String(bean.cpm)
        cpc_label.text  = String(bean.cpc)
        cpuv_label.text  = String(bean.cpuv)
        e_com_label.text  = bean.e_com
        delivery_label.text  = bean.delivery

        cpmnorm.text = String(bean.cpmNorm)
        cpcnorm.text = String(bean.cpcNorm)
        cpuvnorm.text = String(bean.cpuvNorm)
        ctrnorm.text = String(bean.ctrNorm)

    }
    
    let view1chart1 = GroupedBarsViewTool();
    let pieview1_2 = PieChartViewTool()
    let pieview1_3 = PieChartViewTool()
    let my_View5 = NSBundle.mainBundle().loadNibNamed("PieCharts_tuglie", owner: nil, options: nil).last as? PieCharts_tuglie
    let my_View6 = NSBundle.mainBundle().loadNibNamed("PieCharts_tuglie", owner: nil, options: nil).last as? PieCharts_tuglie

//    let myView = NSBundle.mainBundle().loadNibNamed("Campaign_imp_uv_View", owner: nil, options: nil).last as? Campaign_imp_uv_view

    func showoverview(){
        
        //关闭滚动条显示
        overview.showsHorizontalScrollIndicator = false
        overview.showsVerticalScrollIndicator = false
        overview.scrollsToTop = false
        overview.bounces=false
        
        //协议代理，在本类中处理滚动事件
        overview.delegate = self
        //滚动时只能停留到某一页
        overview.pagingEnabled = true
        
        let width = AppWidth - 22;
        
        //设置scrollView的内容总尺寸
        overview.contentSize = CGSizeMake(
            CGFloat(width) * CGFloat(3),
            CGRectGetHeight(self.overview.bounds)
        )
        let size = overview.bounds.size;
        view1chart1.frame = CGRect(x: CGFloat(0) * (width), y: 20,width: width, height: size.height - 20);
        let view1chart1_label = UILabel()
        view1chart1_label.font = UIFont.systemFontOfSize(14)

        view1chart1_label.frame = CGRect(x: CGFloat(0) * (width) + 5, y: 0,width: width, height: 20)
        view1chart1_label.text = "Achievement"
        
        pieview1_2.frame = CGRect(x: CGFloat(1) * (width), y: 20,width: width, height: 235 - 20);
        let my_e = UIView()
        my_View5?.frame = CGRect(x: 0, y: 0,width: width, height: 200);
        my_e.frame = CGRect(x: CGFloat(1) * (width), y: 236,width: width, height: 200)
        my_e.addSubview(my_View5!)
        let pieview1_2_label = UILabel()
        pieview1_2_label.font = UIFont.systemFontOfSize(14)

        pieview1_2_label.frame = CGRect(x: CGFloat(1) * (width) + 5, y: 0,width: width, height: 20)
        pieview1_2_label.text = "Audience conversion(IMP)"
        
        pieview1_3.frame = CGRect(x: CGFloat(2) * (width), y: 20,width: width, height: 235 - 20);
        let my_f = UIView()
        my_View6?.frame = CGRect(x: 0, y: 0,width: width, height: 200);
        my_f.frame = CGRect(x: CGFloat(2) * (width), y: 236,width: width, height: 200)
        my_f.addSubview(my_View6!)
        let pieview1_3_label = UILabel()
        pieview1_3_label.font = UIFont.systemFontOfSize(14)

        pieview1_3_label.frame = CGRect(x: CGFloat(2) * (width) + 5, y: 0,width: width, height: 20)
        pieview1_3_label.text = "Audience conversion(UV)"

//        let b = UIView()
//        myView?.frame = CGRect(x: 0, y: 0,width: width, height: size.height);
//        b.frame = CGRect(x: CGFloat(1) * (width), y: 0,width: width, height: size.height);
//        b.addSubview(myView!)
        loadoverChartsData();
        overview.addSubview(view1chart1)
        overview.addSubview(pieview1_2)
        overview.addSubview(my_e)
        overview.addSubview(pieview1_3)
        overview.addSubview(my_f)
        
        overview.addSubview(view1chart1_label)
        overview.addSubview(pieview1_2_label)
        overview.addSubview(pieview1_3_label)

//        overview.addSubview(b)
//        addBorder(view1chart1)
//        addBorder(myView!)
        over_pageControl.numberOfPages = 3;
        over_pageControl.currentPage = 0
        //设置页控件点击事件
        over_pageControl.addTarget(self, action: "pageChanged:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    
    let pieview2_1 = PieChartViewTool()
    let barview2_2 = BarChartViewTool()
    let pieview2_3 = PieChartViewTool()
    let pieview2_4 = PieChartViewTool()
    let pieview2_5 = PieChartViewTool()

    let my_View = NSBundle.mainBundle().loadNibNamed("PieCharts_tuglie", owner: nil, options: nil).last as? PieCharts_tuglie
    let my_View2 = NSBundle.mainBundle().loadNibNamed("PieCharts_tuglie", owner: nil, options: nil).last as? PieCharts_tuglie
    let my_View3 = NSBundle.mainBundle().loadNibNamed("PieCharts_tuglie", owner: nil, options: nil).last as? PieCharts_tuglie
    let my_View4 = NSBundle.mainBundle().loadNibNamed("PieCharts_tuglie", owner: nil, options: nil).last as? PieCharts_tuglie
    
    
    func showtaview(){
        
        //关闭滚动条显示
        taview.showsHorizontalScrollIndicator = false
        taview.showsVerticalScrollIndicator = false
        taview.scrollsToTop = false
        taview.bounces=false
        
        //协议代理，在本类中处理滚动事件
        taview.delegate = self
        //滚动时只能停留到某一页
        taview.pagingEnabled = true
        
        let width = AppWidth - 22;
        
        //设置scrollView的内容总尺寸
        taview.contentSize = CGSizeMake(
            CGFloat(width) * CGFloat(5),
            CGRectGetHeight(self.taview.bounds)
        )
        let size = taview.bounds.size;
        
        pieview2_1.frame = CGRect(x: CGFloat(0) * (width), y: 20,width: width, height: 235 - 20);
        let my_a = UIView()
        my_View?.frame = CGRect(x: 0, y: 0,width: width, height: 200);
        my_a.frame = CGRect(x: CGFloat(0) * (width), y: 235,width: width, height: 200);
        my_a.addSubview(my_View!)
        let pieview2_1_label = UILabel()
        pieview2_1_label.font = UIFont.systemFontOfSize(14)

        pieview2_1_label.frame = CGRect(x: CGFloat(0) * (width) + 5, y: 0,width: width, height: 20)
        pieview2_1_label.text = "Gender analysis"
        
        barview2_2.frame = CGRect(x: CGFloat(1) * (width), y: 20,width: width, height: size.height);
        let barview2_2_label = UILabel()
        barview2_2_label.font = UIFont.systemFontOfSize(14)

        barview2_2_label.frame = CGRect(x: CGFloat(1) * (width) + 5, y: 0,width: width, height: 20)
        barview2_2_label.text = "Age analysis"
        
        pieview2_3.frame = CGRect(x: CGFloat(2) * (width), y: 20,width: width, height: 235 - 20);
        let pieview2_3_label = UILabel()
        pieview2_3_label.font = UIFont.systemFontOfSize(14)

        pieview2_3_label.frame = CGRect(x: CGFloat(2) * (width) + 5, y: 0,width: width, height: 20)
        pieview2_3_label.text = "Education"
        let my_b = UIView()
        my_View2?.frame = CGRect(x: 0, y: 0,width: width, height: 200);
        my_b.frame = CGRect(x: CGFloat(2) * (width), y: 236,width: width, height: 200)
        my_b.addSubview(my_View2!)
        
        pieview2_4.frame = CGRect(x: CGFloat(3) * (width), y: 20,width: width, height: 235 - 20);
        let pieview2_4_label = UILabel()
        pieview2_4_label.font = UIFont.systemFontOfSize(14)

        pieview2_4_label.frame = CGRect(x: CGFloat(3) * (width) + 5, y: 0,width: width, height: 20)
        pieview2_4_label.text = "Personal income"
        let my_c = UIView()
        my_View3?.frame = CGRect(x: 0, y: 0,width: width, height: 200);
        my_c.frame = CGRect(x: CGFloat(3) * (width), y: 236,width: width, height: 200)
        my_c.addSubview(my_View3!)
        
        pieview2_5.frame = CGRect(x: CGFloat(4) * (width), y: 20,width: width, height: 235 - 20);
        let pieview2_5_label = UILabel()
        pieview2_5_label.font = UIFont.systemFontOfSize(14)

        pieview2_5_label.frame = CGRect(x: CGFloat(4) * (width) + 5, y: 0,width: width, height: 20)
        pieview2_5_label.text = "Family income"
        let my_d = UIView()
        my_View4?.frame = CGRect(x: 0, y: 0,width: width, height: 200);
        my_d.frame = CGRect(x: CGFloat(4) * (width), y: 236,width: width, height: 200)
        my_d.addSubview(my_View4!)

        loadtaChartsData()
        taview.addSubview(my_a)
        taview.addSubview(pieview2_1)
        taview.addSubview(barview2_2)
        taview.addSubview(pieview2_3)
        taview.addSubview(my_b)

        taview.addSubview(pieview2_4)
        taview.addSubview(my_c)

        taview.addSubview(pieview2_5)
        taview.addSubview(my_d)
        
        taview.addSubview(pieview2_1_label)
        taview.addSubview(barview2_2_label)
        taview.addSubview(pieview2_3_label)
        taview.addSubview(pieview2_4_label)
        taview.addSubview(pieview2_5_label)

        
//        addBorder(pieview2_1)
//        addBorder(barview2_2)
//        addBorder(pieview2_3)
//        addBorder(pieview2_4)
//        addBorder(pieview2_5)


        ta_pageControl.numberOfPages = 5;
        ta_pageControl.currentPage = 0
        //设置页控件点击事件
        ta_pageControl.addTarget(self, action: "pageChanged:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    let barview3_1 = BarChartViewTool()

    func showgeoview(){
        
        //关闭滚动条显示
        geoview.showsHorizontalScrollIndicator = false
        geoview.showsVerticalScrollIndicator = false
        geoview.scrollsToTop = false
        geoview.bounces=false
        
        //协议代理，在本类中处理滚动事件
        geoview.delegate = self
        //滚动时只能停留到某一页
        geoview.pagingEnabled = true
        
        let width = AppWidth - 22;
        
        //设置scrollView的内容总尺寸
        geoview.contentSize = CGSizeMake(
            CGFloat(width) * CGFloat(1),
            CGRectGetHeight(self.geoview.bounds)
        )
        let size = overview.bounds.size;
        
        //        view1chart1.frame = CGRect(x: CGFloat(0) * (width), y: 0,
        //            width: width, height: size.height);
        //
        barview3_1.frame = CGRect(x: CGFloat(0) * (width), y: 20,width: width, height: size.height - 20);
        let barview3_1_label = UILabel()
        barview3_1_label.font = UIFont.systemFontOfSize(14)

        barview3_1_label.frame = CGRect(x: CGFloat(0) * (width) + 5, y: 0,width: width, height: 20)
        barview3_1_label.text = " "
        loadgeoChartsData()
        geoview.addSubview(barview3_1)
        geoview.addSubview(barview3_1_label)

        //        view1tableview3.frame = CGRect(x: CGFloat(2) * (width), y: 0,
        //            width: width, height: size.height);
        //
        //        loadAccountChartsData();
        //
        //
        //        overview.addSubview(view1chart1)
        //        overview.addSubview(view1chart2)
        
        
        geo_pageControl.numberOfPages = 1;
        geo_pageControl.currentPage = 0
        //设置页控件点击事件
        geo_pageControl.addTarget(self, action: "pageChanged:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func loadoverChartsData(){
        
        //        self.pleaseWait();
        view1chart1.labelText = "Achivevment";
        loadGroupedBarsChartViewData(view1chart1)
        loadPieChartViewData_over(pieview1_2,b: 6,which: 5)
        loadPieChartViewData_over(pieview1_3,b: 7,which: 6)
//        loadcampaign_charts_view()
        
    }
    func loadtaChartsData(){
        loadPieChartViewData(pieview2_1,b: 1,which: 1)
        loadBarChartViewData(barview2_2,pageTpe: 2)
        loadPieChartViewData(pieview2_3,b: 2,which: 2)
        loadPieChartViewData(pieview2_4,b: 3,which: 3)
        loadPieChartViewData(pieview2_5,b: 4,which: 4)

    }
    func loadgeoChartsData(){
        loadBarChartViewData(barview3_1,pageTpe: 1)

        
    }
    
    func loadGroupedBarsChartViewData(chart:ChartViewInterface){
        
        let url = rootURL + "campaign/getCampaignDetail.cic";
        let parameters = [
            "campaignId": bean.id,
//            "campaignId": 2003270,
//            "platFrom":0,
            "platFrom":platform,
            "pageType":0,
            
        ]
//        print(bean.id)
        
        Alamofire.request(.GET, url,parameters: parameters).responseJSON{
            data in
//            print(data)
            if(data.result.isSuccess){
                let json = data.result.value!;
                chart.setData(json,a: 0)
            }else{
                chart.setData("{}",a: 0)
                
            }
        }
        
    }
    
    let bean_campaign = E_shopBean()

    
    func loadPieChartViewData_over(chart:ChartViewInterface,b:Int,which:Int){
        self.pleaseWait()
        removeChartsData2()
        //SocialListeningServer/campaign/getEShopInfo.cic?customerId=128&shopName=test1&startDate=2015-11-11&endDate=2015-12-11
        //数据链接，解析
        let url = rootURL + "campaign/getCampaignDetail.cic";
        let parameters = [
            "campaignId": bean.id,
//            "platFrom":0,
            "platFrom":platform,
            "pageType":0,
            
        ]
        Alamofire.request(.GET, url,parameters: parameters as [String : NSObject]).responseJSON{
            data in
//                                    print(data)
            if(data.result.isSuccess){
                let json = data.result.value!;
                if (!NSJSONSerialization.isValidJSONObject(json)) {
                    Utils.alert_view(1008);
                }else{
                    let json = data.result.value!;
                    chart.setData(json,a: b)
                    if which == 5{
                        var pie_data = [:]
                        pie_data = chart.setData(json,a: b)
                        let pie_name = pie_data.objectForKey("piecharts_name") as! NSArray
                        let pie_values = pie_data.objectForKey("piecharts_values") as! NSArray
                        var pie_all_values = 0.0
                        for(var j = 0 ; j < pie_name.count; j++){
                            pie_all_values += pie_values[j] as! Double
                        }
                        if pie_name.count > 0{
                            if NSString(format: "%.2f", pie_values[0] as! Double * 100 / pie_all_values) as String == "nan"{
                            }else{
                                self.my_View5?.name_label1.text = pie_name[0] as? String
                                self.my_View5?.number_label1.text =  (NSString(format: "%.2f", pie_values[0] as! Double * 100 / pie_all_values) as String) + "%"
                                self.my_View5?.image1.hidden = false
                            }
                            
                        }
                        if pie_name.count > 1{
                            if NSString(format: "%.2f", pie_values[1] as! Double * 100 / pie_all_values) as String == "nan"{
                            }else{
                                self.my_View5?.name_label2.text = pie_name[1] as? String
                                self.my_View5?.number_label2.text =  (NSString(format: "%.2f", pie_values[1] as! Double * 100 / pie_all_values) as String) + "%"
                                self.my_View5?.image2.hidden = false}
                            
                        }
                    }
                    
                    if which == 6{
                        var pie_data = [:]
                        pie_data = chart.setData(json,a: b)
                        let pie_name = pie_data.objectForKey("piecharts_name") as! NSArray
                        let pie_values = pie_data.objectForKey("piecharts_values") as! NSArray
                        var pie_all_values = 0.0
                        for(var j = 0 ; j < pie_name.count; j++){
                            pie_all_values += pie_values[j] as! Double
                        }
                        if pie_name.count > 0{
                            if NSString(format: "%.2f", pie_values[0] as! Double * 100 / pie_all_values) as String == "nan"{
                            }else{
                                self.my_View6?.name_label1.text = pie_name[0] as? String
                                self.my_View6?.number_label1.text =  (NSString(format: "%.2f", pie_values[0] as! Double * 100 / pie_all_values) as String) + "%"
                                self.my_View6?.image1.hidden = false
                            }
                        }
                        if pie_name.count > 1{
                            if NSString(format: "%.2f", pie_values[1] as! Double * 100 / pie_all_values) as String == "nan"{
                            }else{
                            self.my_View6?.name_label2.text = pie_name[1] as? String
                            self.my_View6?.number_label2.text =  (NSString(format: "%.2f", pie_values[1] as! Double * 100 / pie_all_values) as String) + "%"
                            self.my_View6?.image2.hidden = false
                            }
                        }
                    }
                    
                    
                }
            }else{
                
            }
            self.clearAllNotice();
        }
    }
    
    func removeChartsData2(){
        my_View5?.image1.hidden = true
        my_View5?.image2.hidden = true
        my_View5?.image3.hidden = true
        my_View5?.image4.hidden = true
        my_View5?.name_label1.text = ""
        my_View5?.name_label2.text = ""
        my_View5?.name_label3.text = ""
        my_View5?.name_label4.text = ""
        my_View5?.number_label1.text = ""
        my_View5?.number_label2.text = ""
        my_View5?.number_label3.text = ""
        my_View5?.number_label4.text = ""
        
        my_View6?.image1.hidden = true
        my_View6?.image2.hidden = true
        my_View6?.image3.hidden = true
        my_View6?.image4.hidden = true
        my_View6?.name_label1.text = ""
        my_View6?.name_label2.text = ""
        my_View6?.name_label3.text = ""
        my_View6?.name_label4.text = ""
        my_View6?.number_label1.text = ""
        my_View6?.number_label2.text = ""
        my_View6?.number_label3.text = ""
        my_View6?.number_label4.text = ""
    }
    
    func loadPieChartViewData(chart:ChartViewInterface,b:Int,which:Int){
        //数据链接
        
        removeChartsData()
        let url = rootURL + "campaign/getCampaignDetail.cic";
        let parameters = [
            "campaignId": bean.id,
//            "campaignId":2003270,
            "platFrom":0,
            "pageType":2,
            
        ]
//        print(bean.id)
        Alamofire.request(.GET, url,parameters: parameters).responseJSON{
            data in
//            print(data)
            
            if(data.result.isSuccess){
                let json = data.result.value!;
                chart.setData(json,a: b)
                if which == 1{
//                    print(data)
                    var pie_data = [:]
                    pie_data = chart.setData(json,a: b)
                    let pie_name = pie_data.objectForKey("piecharts_name") as! NSArray
                    let pie_values = pie_data.objectForKey("piecharts_values") as! NSArray
                    var pie_all_values = 0.0
                    for(var j = 0 ; j < pie_name.count; j++){
                        pie_all_values += pie_values[j] as! Double
                    }
                    if pie_name.count > 0{
                        self.my_View?.name_label1.text = pie_name[0] as? String
                        self.my_View?.number_label1.text =  (NSString(format: "%.2f", pie_values[0] as! Double * 100 / pie_all_values) as String) + "%"
                        self.my_View?.image1.hidden = false
                        
                    }
                    if pie_name.count > 1{
                        self.my_View?.name_label2.text = pie_name[1] as? String
                        self.my_View?.number_label2.text =  (NSString(format: "%.2f", pie_values[1] as! Double * 100 / pie_all_values) as String) + "%"
                        self.my_View?.image2.hidden = false
                        
                    }
                    if pie_name.count > 2{
                        self.my_View?.name_label3.text = pie_name[2] as? String
                        self.my_View?.number_label3.text =  (NSString(format: "%.2f", pie_values[2] as! Double * 100 / pie_all_values) as String) + "%"
                        self.my_View?.image3.hidden = false
                        
                    }
                    if pie_name.count > 3{
                        self.my_View?.name_label4.text = pie_name[3] as? String
                        self.my_View?.number_label4.text =  (NSString(format: "%.2f", pie_values[3] as! Double * 100 / pie_all_values) as String) + "%"
                        self.my_View?.image4.hidden = false
                        
                    }
                    
                }else if which == 2{
                    var pie_data = [:]
                    pie_data = chart.setData(json,a: b)
                    let pie_name = pie_data.objectForKey("piecharts_name") as! NSArray
                    let pie_values = pie_data.objectForKey("piecharts_values") as! NSArray
                    var pie_all_values = 0.0
                    for(var j = 0 ; j < pie_name.count; j++){
                        pie_all_values += pie_values[j] as! Double
                    }
                    if pie_name.count > 0{
                        self.my_View2?.name_label1.text = pie_name[0] as? String
                        self.my_View2?.number_label1.text =  (NSString(format: "%.2f", pie_values[0] as! Double * 100 / pie_all_values) as String) + "%"
                        self.my_View2?.image1.hidden = false
                        
                    }
                    if pie_name.count > 1{
                        self.my_View2?.name_label2.text = pie_name[1] as? String
                        self.my_View2?.number_label2.text =  (NSString(format: "%.2f", pie_values[1] as! Double * 100 / pie_all_values) as String) + "%"
                        self.my_View2?.image2.hidden = false
                        
                    }
                    if pie_name.count > 2{
                        self.my_View2?.name_label3.text = pie_name[2] as? String
                        self.my_View2?.number_label3.text =  (NSString(format: "%.2f", pie_values[2] as! Double * 100 / pie_all_values) as String) + "%"
                        self.my_View2?.image3.hidden = false
                        
                    }
                    if pie_name.count > 3{
                        self.my_View2?.name_label4.text = pie_name[3] as? String
                        self.my_View2?.number_label4.text =  (NSString(format: "%.2f", pie_values[3] as! Double * 100 / pie_all_values) as String) + "%"
                        self.my_View2?.image4.hidden = false
                        
                    }
                }else if which == 3{
                    var pie_data = [:]
                    pie_data = chart.setData(json,a: b)
                    let pie_name = pie_data.objectForKey("piecharts_name") as! NSArray
                    let pie_values = pie_data.objectForKey("piecharts_values") as! NSArray
                    var pie_all_values = 0.0
                    for(var j = 0 ; j < pie_name.count; j++){
                        pie_all_values += pie_values[j] as! Double
                    }
                    if pie_name.count > 0{
                        self.my_View3?.name_label1.text = pie_name[0] as? String
                        self.my_View3?.number_label1.text =  (NSString(format: "%.2f", pie_values[0] as! Double * 100 / pie_all_values) as String) + "%"
                        self.my_View3?.image1.hidden = false
                        
                    }
                    if pie_name.count > 1{
                        self.my_View3?.name_label2.text = pie_name[1] as? String
                        self.my_View3?.number_label2.text =  (NSString(format: "%.2f", pie_values[1] as! Double * 100 / pie_all_values) as String) + "%"
                        self.my_View3?.image2.hidden = false
                        
                    }
                    if pie_name.count > 2{
                        self.my_View3?.name_label3.text = pie_name[2] as? String
                        self.my_View3?.number_label3.text =  (NSString(format: "%.2f", pie_values[2] as! Double * 100 / pie_all_values) as String) + "%"
                        self.my_View3?.image3.hidden = false
                        
                    }
                    if pie_name.count > 3{
                        self.my_View3?.name_label4.text = pie_name[3] as? String
                        self.my_View3?.number_label4.text =  (NSString(format: "%.2f", pie_values[3] as! Double * 100 / pie_all_values) as String) + "%"
                        self.my_View3?.image4.hidden = false
                        
                    }
                }else if which == 4{
                    var pie_data = [:]
                    pie_data = chart.setData(json,a: b)
                    let pie_name = pie_data.objectForKey("piecharts_name") as! NSArray
                    let pie_values = pie_data.objectForKey("piecharts_values") as! NSArray
                    var pie_all_values = 0.0
                    for(var j = 0 ; j < pie_name.count; j++){
                        pie_all_values += pie_values[j] as! Double
                    }
                    if pie_name.count > 0{
                        self.my_View4?.name_label1.text = pie_name[0] as? String
                        self.my_View4?.number_label1.text =  (NSString(format: "%.2f", pie_values[0] as! Double * 100 / pie_all_values) as String) + "%"
                        self.my_View4?.image1.hidden = false
                        
                    }
                    if pie_name.count > 1{
                        self.my_View4?.name_label2.text = pie_name[1] as? String
                        self.my_View4?.number_label2.text =  (NSString(format: "%.2f", pie_values[1] as! Double * 100 / pie_all_values) as String) + "%"
                        self.my_View4?.image2.hidden = false
                        
                    }
                    if pie_name.count > 2{
                        self.my_View4?.name_label3.text = pie_name[2] as? String
                        self.my_View4?.number_label3.text =  (NSString(format: "%.2f", pie_values[2] as! Double * 100 / pie_all_values) as String) + "%"
                        self.my_View4?.image3.hidden = false
                        
                    }
                    if pie_name.count > 3{
                        self.my_View4?.name_label4.text = pie_name[3] as? String
                        self.my_View4?.number_label4.text =  (NSString(format: "%.2f", pie_values[3] as! Double * 100 / pie_all_values) as String) + "%"
                        self.my_View4?.image4.hidden = false
                        
                    }
                }
            }else{
                
            }
        }
    }
    
    func removeChartsData(){
        my_View?.image1.hidden = true
        my_View?.image2.hidden = true
        my_View?.image3.hidden = true
        my_View?.image4.hidden = true
        my_View?.name_label1.text = ""
        my_View?.name_label2.text = ""
        my_View?.name_label3.text = ""
        my_View?.name_label4.text = ""
        my_View?.number_label1.text = ""
        my_View?.number_label2.text = ""
        my_View?.number_label3.text = ""
        my_View?.number_label4.text = ""
        
        my_View2?.image1.hidden = true
        my_View2?.image2.hidden = true
        my_View2?.image3.hidden = true
        my_View2?.image4.hidden = true
        my_View2?.name_label1.text = ""
        my_View2?.name_label2.text = ""
        my_View2?.name_label3.text = ""
        my_View2?.name_label4.text = ""
        my_View2?.number_label1.text = ""
        my_View2?.number_label2.text = ""
        my_View2?.number_label3.text = ""
        my_View2?.number_label4.text = ""
        
        my_View3?.image1.hidden = true
        my_View3?.image2.hidden = true
        my_View3?.image3.hidden = true
        my_View3?.image4.hidden = true
        my_View3?.name_label1.text = ""
        my_View3?.name_label2.text = ""
        my_View3?.name_label3.text = ""
        my_View3?.name_label4.text = ""
        my_View3?.number_label1.text = ""
        my_View3?.number_label2.text = ""
        my_View3?.number_label3.text = ""
        my_View3?.number_label4.text = ""
        
        my_View4?.image1.hidden = true
        my_View4?.image2.hidden = true
        my_View4?.image3.hidden = true
        my_View4?.image4.hidden = true
        my_View4?.name_label1.text = ""
        my_View4?.name_label2.text = ""
        my_View4?.name_label3.text = ""
        my_View4?.name_label4.text = ""
        my_View4?.number_label1.text = ""
        my_View4?.number_label2.text = ""
        my_View4?.number_label3.text = ""
        my_View4?.number_label4.text = ""
    }
    
    func loadBarChartViewData(chart:ChartViewInterface,pageTpe:Int){
        
        //数据链接
        let url = rootURL + "campaign/getCampaignDetail.cic";
        let parameters = [
            "campaignId": bean.id,
            "platForm":platform,

//            "campaignId":2019707,
//            "platForm":2,
            "pageType":pageTpe,
            
        ]
        
        Alamofire.request(.GET, url,parameters: parameters).responseJSON{
            data in
//            if pageTpe == 1{
//                print(data)
//                print(self.bean.id)
//                print(self.platform)
//                print(pageTpe)
//            }
            if(data.result.isSuccess){
                let json = data.result.value!;
                chart.setData(json,a: pageTpe)
            }else{
                
            }
        }
    }
    
    func e_shop_view(){
        //campaign/getEShopList.cic?customerId=128&campaignId=2012111&pageNum=1&pageSize=20
        //数据链接，解析
        let url = rootURL + "campaign/getEShopList.cic";
        let customerId = NSUserDefaults.standardUserDefaults().valueForKey("customerId") as! Int;
        let parameters = [
                        "customerId": customerId,
                        "campaignId": bean.id,
                        "pageNum": 1,
                        "pageSize": 20,
            
//            "customerId": 124,
//            "campaignId": 2012112,
//            "pageNum": 1,
//            "pageSize": 20
            
        ]
        Alamofire.request(.GET, url,parameters: parameters as [String : NSObject]).responseJSON{
            data in
//                        print(data)
            if(data.result.isSuccess){
                let json = data.result.value!;
                if (!NSJSONSerialization.isValidJSONObject(json)) {
//                    Utils.alert_view(1008);
                }else{
                    let jsonObj = Utils.stringToJson(json);
                    if jsonObj.count == 0{
                        self.e_shop_changed = 1
                        self.e_shop_button.tintColor = UIColor.lightGrayColor()
                    }else{
                        self.e_shop_changed = 0
                    }
                }
            }else{
               print("e_shop_load_fail")
            }
            self.clearAllNotice();
        }
    }
    
    //点击页控件时事件处理
    func pageChanged(sender:UIPageControl) {
        //根据点击的页数，计算scrollView需要显示的偏移量
        print("pagechanged");
    }
    
    //UIScrollViewDelegate方法，每次滚动结束后调用
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        if let _ = overview {
            if scrollView == overview {
                //通过scrollView内容的偏移计算当前显示的是第几页
                var page = Int(scrollView.contentOffset.x / overview.frame.size.width)
                //设置pageController的当前页
                if page > 3 {
                    page = 3;
                }
                over_pageControl.currentPage = page
            }
        }
        if let _ = taview {
            if scrollView == taview {
                //通过scrollView内容的偏移计算当前显示的是第几页
                var page = Int(scrollView.contentOffset.x / taview.frame.size.width)
                //print("page:\(page)");
                //设置pageController的当前页
                if page > 5 {
                    page = 5;
                }
                ta_pageControl.currentPage = page
            }
        }
        if let _ = geoview {
            if scrollView == geoview {
                //通过scrollView内容的偏移计算当前显示的是第几页
                var page = Int(scrollView.contentOffset.x / geoview.frame.size.width)
                //print("page:\(page)");
                //设置pageController的当前页
                if page > 2 {
                    page = 2;
                }
                geo_pageControl.currentPage = page
            }
        }
    }
    
    func scrollViewDidScroll(scrollView:UIScrollView){
        if scrollView == sv {
            let offsetY: CGFloat = scrollView.contentOffset.y
//            print(offsetY)
            // 处理segmented_control
            if offsetY >= 80 {
                newY = offsetY;
                date_segment.frame = CGRect(x: date_segment.x, y: offsetY, width: AppWidth, height: date_segment.height)
                //                    able.frame = CGRect(x: 0, y: 100, width: AppWidth, height: 140)
                //                    able2.frame = CGRect(x: 0, y: 100+140, width: AppWidth+5, height: AppHeight)
                self.cam_main_view.bringSubviewToFront(date_segment)
            } else {
                date_segment.frame = CGRect(x: date_segment.x, y: self.oldY, width: AppWidth, height: date_segment.height)
                //                    able.frame = CGRect(x: 0, y: -offsetY+200, width: AppWidth, height: 140)
                //                    able2.frame = CGRect(x: 0, y: -offsetY+200+140, width: AppWidth+5, height: AppHeight)
            }
        }
    }
    
    func addviewborder(){
        addBorder(border_view)
        addBorder(date_segment)
//        addBorder(content_view)
        addBorder(overview_border)
        addBorder(taview_border)
        addBorder(geoview_border)
        addBorder(view11)
        addBorder(view12)
        addBorder(view13)
        addBorder(view21)
        addBorder(view22)
        addBorder(view23)
        addBorder(view31)
        addBorder(view32)
        addBorder(view33)
        addBorder(view41)

    }
    
    
    func addBorder(view:UIView){
        view.layer.borderColor = UIColor.lightGrayColor().CGColor;
        view.layer.borderWidth = 0.5;
    }
    
    @IBAction func daback(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func e_shop(sender: AnyObject) {
        if e_shop_changed == 0{
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil);
            let campaign = storyBoard.instantiateViewControllerWithIdentifier("E_Shop") as! E_Shop
            campaign.bean = bean
            let nav = UINavigationController(rootViewController: campaign);
            self.presentViewController(nav, animated: true, completion: nil)
        }else{
        }
    }
    
}