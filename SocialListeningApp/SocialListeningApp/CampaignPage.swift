//
//  CampaignPage.swift
//  SocialListeningApp
//
//  Created by chencharles on 16/2/25.
//  Copyright © 2016年 cicdata. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class CampaignPage: MainUIViewController,UISearchBarDelegate,IntentDelegate,SelectIndexDelegate{

    private let brand = UILabel();
    
    var beans = [CampaignBean]();

    
    private var searchBar:UISearchBar!;
    
    private var viewWidth = AppWidth;
    private var viewHeight = AppHeight;

    @IBOutlet weak var campaign_tableview: UITableView!
    
    @IBOutlet weak var date_segment_border: UIView!
    
    private var keywordHaveNextPage = false;
    
    var selectedCellIndexPaths:[NSIndexPath] = []
    
    private var CampaignPageIndex = 1;

    private let pageSize = 20;
    
    var CampaignName:String = "";
    
    private var time1 = "";
    private var time2 = "";
    private var platform = 2;


    @IBOutlet weak var from_label: UIView!
    
    @IBOutlet weak var from_changed_label: UILabel!

    @IBOutlet weak var platfrom_label: UIView!
    
    @IBOutlet weak var platfrom_changed_label: UILabel!
    
    @IBOutlet weak var to_label: UIView!
    
    @IBOutlet weak var to_changed_label: UILabel!
    
//    private var event_text = 0
    var minTotalCount:Int = 0;

    
    var contentLabel:UILabel? = UILabel();
    
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
        addBorder(date_segment_border)
        time1 = "2016-01-01"
        time2 = Utils.getDateString(-1);

        let changed_to_label = time2.stringByReplacingOccurrencesOfString("-", withString: "/", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let changed_from_label = time1.stringByReplacingOccurrencesOfString("-", withString: "/", options: NSStringCompareOptions.LiteralSearch, range: nil)
        to_changed_label.text = changed_to_label
        from_changed_label.text = changed_from_label
        platfrom_changed_label.text = "P+M"
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent;
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changetitle:", name: "changeBrand", object: nil)

        
        brand.text = BrandName;
        brand.textColor = UIColor.whiteColor();
        brand.frame = CGRectMake(0, 0, 10, 20)
        brand.textAlignment = NSTextAlignment.Center
        navigationItem.titleView = brand;
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: UIBarButtonItemStyle.Plain, target: self, action: "doShowView");
        navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()

        searchBar = UISearchBar();
        searchBar.delegate = self;
        searchBar.searchBarStyle = .Minimal;
        searchBar.frame = CGRectMake(0, 0, viewWidth, 44);
        searchBar.backgroundColor = UIColor.whiteColor()
//        createData()
        configureTableView()
        addRefreshHeaher()
        addLoadFooter()
        xwDelay(1) { () -> Void in
//            self.loadViewData()
        }
        choose_changed()
        addErrorContent()
    }
    func choose_changed(){
        let tag1 = UITapGestureRecognizer(target: self, action: "date_changed_from");
        let tag2 = UITapGestureRecognizer(target: self, action: "paltfrom_changed");
        let tag3 = UITapGestureRecognizer(target: self, action: "date_changed_to");
        from_label.addGestureRecognizer(tag1);
        platfrom_label.addGestureRecognizer(tag2)
        to_label.addGestureRecognizer(tag3);
    }
    
    func date_changed_from(){
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
        let minDate = dateFormatter.dateFromString("2000-01-01")
//        let minDate = dateFormatter.dateFromString("2015-01-01")

        datePicker.maximumDate = maxDate
        datePicker.minimumDate = minDate
        // 设置默认时间
        datePicker.date = dateFormatter.dateFromString(time1)!
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default){
            (alertAction)->Void in
            let text_string = dateFormatter.stringFromDate(datePicker.date)
            let filtered = text_string.stringByReplacingOccurrencesOfString("-", withString: "/", options: NSStringCompareOptions.LiteralSearch, range: nil)
            self.from_changed_label.text = filtered
            self.from_changed_label.adjustsFontSizeToFitWidth = true
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
        let maxDate = dateFormatter.dateFromString(Utils.getDateString(-1))
        let minDate = dateFormatter.dateFromString(time1)
        datePicker.maximumDate = maxDate
        datePicker.minimumDate = minDate
        // 设置默认时间
        datePicker.date = maxDate!
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default){
            (alertAction)->Void in
            let text_string = dateFormatter.stringFromDate(datePicker.date)
            let filtered = text_string.stringByReplacingOccurrencesOfString("-", withString: "/", options: NSStringCompareOptions.LiteralSearch, range: nil)
            self.to_changed_label.text = filtered
            self.to_changed_label.adjustsFontSizeToFitWidth = true
            self.time2 = text_string
            self.upPullLoadData()
            })
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel,handler:nil))
        alertController.view.addSubview(datePicker)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    
    func paltfrom_changed(){
        let alertController:UIAlertController=UIAlertController()
        
        alertController.addAction(UIAlertAction(title: "PC", style: UIAlertActionStyle.Default){
            (alertAction)->Void in
            self.platfrom_changed_label.text = "PC"
            self.platform = 0
            self.upPullLoadData()
            })
        alertController.addAction(UIAlertAction(title: "Mobile", style: UIAlertActionStyle.Default){
            (alertAction)->Void in
            self.platfrom_changed_label.text = "Mobile"
            self.platform = 1
            self.upPullLoadData()
            })
        alertController.addAction(UIAlertAction(title: "P+M", style: UIAlertActionStyle.Default){
            (alertAction)->Void in
            self.platfrom_changed_label.text = "P+M"
            self.platform = 2
            self.upPullLoadData()

            })
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel,handler:nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func loadViewData(){
//                print(event_text);
//        if event_text != 1001{
//            Utils.alert_view(self.event_text);
//            campaign_tableview.headerView?.endRefreshing()
//            return;
//        }
//        campaign_tableview.separatorStyle = .None
        self.pleaseWait()
        //campaign/getBrandCampaignService.cic?customerId=128&brandId=1&platForm=2&pageNum=1&pageSize=20&campaignName=&startDate=&endDate=
        //数据链接，解析
        
        let url = rootURL + "campaign/getBrandCampaignService.cic";
        let customerId = NSUserDefaults.standardUserDefaults().valueForKey("customerId") as! Int;
//        let acctId = NSUserDefaults.standardUserDefaults().valueForKey("userId") as! Int;
        
        let parameters = [
            "customerId": customerId,
            "brandId": BrandId,
            "platForm": platform,
            "pageNum": CampaignPageIndex,
            "pageSize": 20,
            "campaignName": CampaignName,
            "startDate": time1,
            "endDate": time2
        ]
//        print("bug")
//        print(customerId)
//        print(BrandId)
//        print(platform)
//        print(CampaignPageIndex)
//        print(pageSize)
//        print(CampaignName)
//        print(time1)
//        print(time2)
        
        Alamofire.request(.GET, url,parameters: parameters as? [String : AnyObject] ).responseJSON{
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
                        let bean = CampaignBean()
                        let a = temp.objectForKey("startDate") as! NSNumber
                        let b = temp.objectForKey("endDate") as! NSNumber

                        bean.baseinfo = temp.objectForKey("baseInfo")
                        bean.id = temp.objectForKey("campaignId") as! Int;
                        bean.name = temp.objectForKey("campaignName") as! String;
                        bean.imp = bean.baseinfo!.objectForKey("imp") as! Int;
                        bean.click = bean.baseinfo!.objectForKey("click") as! Int;
                        bean.uv = bean.baseinfo!.objectForKey("uv") as! Int;
                        bean.tauv = bean.baseinfo!.objectForKey("tauv") as! Int;
                        let x = Utils.getDateStringByMils(Double(a), formatStr: "yyyy/MM/dd");
                        let y = Utils.getDateStringByMils(Double(b), formatStr: "yyyy/MM/dd");

                        bean.time1 = x
                        bean.time2 = y

                        bean.platform = self.platfrom_changed_label.text!
                        if let _ = bean.baseinfo!.objectForKey("ctr"){
                            let ctrStr = bean.baseinfo!.objectForKey("ctr");
                            if ctrStr is NSNull || ctrStr as! String == ""{
                                bean.ctr = "0%"
                            }else{
                                //bean.ctr = bean.baseinfo!.objectForKey("ctr") as! String
                                bean.ctr = ctrStr as! String;
                            }
                        }
                        bean.cpm = bean.baseinfo!.objectForKey("cpm") as! Double;
                        bean.cpc = bean.baseinfo!.objectForKey("cpc") as! Double;
                        bean.cpuv = bean.baseinfo!.objectForKey("cpuv") as! Double;
                        if let _ = bean.baseinfo!.objectForKey("eConversion"){
                            let eComStr = bean.baseinfo!.objectForKey("eConversion")
                            if eComStr is NSNull || eComStr as! String == ""{
                                bean.e_com = "0%"
                            }else{
                                bean.e_com = eComStr as! String
                            }
                        }
                        if let _ = bean.baseinfo!.objectForKey("delivery"){
                            let deliStr = bean.baseinfo!.objectForKey("delivery")
//                            print("delistr : \(deliStr)")
                            if deliStr is NSNull || deliStr as! String == ""{
                                bean.delivery = "0%"
                            }else{
                                bean.delivery = deliStr as! String
                            }
                        }
                        bean.cpmNorm = bean.baseinfo!.objectForKey("cpmNorm") as! Double;
                        bean.cpcNorm = bean.baseinfo!.objectForKey("cpcNorm") as! Double;
                        bean.cpuvNorm = bean.baseinfo!.objectForKey("cpuvNorm") as! Double;
                        bean.ctrNorm = bean.baseinfo!.objectForKey("ctrNorm") as! Double;
                        self.beans.append(bean);
                    }
                    if self.pageSize == jsonObj.count {
                        self.keywordHaveNextPage = true;
                    }else{
                        self.keywordHaveNextPage = false
                    }
                    self.campaign_tableview.footerView?.endRefreshing()
                    if self.beans.count == 0 {
                        self.campaign_tableview.headerView?.endRefreshing()
                    }else{
                        self.campaign_tableview.reloadData();
                        self.campaign_tableview.headerView?.endRefreshing()
                    }
                }
            }else{

            }
            self.clearAllNotice();
        }
    }
    

    func upPullLoadData(){
        //print("下拉刷新");
        CampaignPageIndex = 1
        beans.removeAll();
        keywordHaveNextPage = false;
        loadViewData();
        self.campaign_tableview.reloadData();
    }
    
    
    func addRefreshHeaher(){
        let headerView = XWRefreshNormalHeader(target: self, action: "upPullLoadData");
        campaign_tableview.headerView = headerView;
    }
    
    func addLoadFooter(){
            let footerView = XWRefreshAutoNormalFooter(target: self, action: "loadMore");
//            footerView.delegate = self;
            footerView.totalCount = minTotalCount;
            campaign_tableview.footerView = footerView;
    }
    
    func loadMore(){
        print("上拉加载更多");
        if keywordHaveNextPage {
            campaign_tableview.footerView?.hidden = false
            self.CampaignPageIndex++;
            loadViewData()
            campaign_tableview.footerView?.endRefreshing()
        }else{
            campaign_tableview.footerView?.hidden = true
        }
    }
    
    func aaa(){
        campaign_tableview.contentOffset.y = campaign_tableview.contentOffset.y - 20
    }
    
    // MARK: Custom Functions
    func configureTableView() {
        campaign_tableview.delegate = self
        campaign_tableview.dataSource = self
        campaign_tableview.tableFooterView = UIView(frame: CGRectZero)
        campaign_tableview.tableHeaderView = searchBar
        campaign_tableview.registerNib(UINib(nibName: "CampaignCell", bundle: nil), forCellReuseIdentifier: "campaign_cell")

    }
    
    func changetitle(bean:NSNotification){
        let temp = bean.object as! BrandBean;
        brand.text = temp.name;
        BrandName = temp.name;
        BrandId = temp.id;
        keywordHaveNextPage = true
        if BrandId > 0 {
            beans.removeAll();
            campaign_tableview.reloadData()
            keywordHaveNextPage = false;
            CampaignPageIndex = 1;
            loadViewData()
        }
        
    }
    
    func doShowView() {
        
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil);
        let one = storyBoard.instantiateViewControllerWithIdentifier("BrandList") as! BrandList;
        one.intentDelegate = self;
        let nav = UINavigationController(rootViewController: one);
        self.presentViewController(nav, animated: true, completion: nil)
        
    }
    
    func getIntentValue(value:AnyObject){
        BrandName = value as! String;
        let label = self.navigationItem.titleView as! UILabel;
        label.text = BrandName;
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //print("出现了");
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent;
        isShow = true;
    }
    
    override func viewDidDisappear(animated: Bool) {
        //print("消失了");
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default;
        isShow = false;
    }
    
    func addBorder(view:UIView){
        view.layer.borderColor = UIColor.lightGrayColor().CGColor;
        view.layer.borderWidth = 0.5;
    }
    
    func addErrorContent(){
        xwDelay(0.1) { () -> Void in
            let contentLabel = self.contentLabel;
            contentLabel?.frame.size = CGSize(width: 200, height: 44)
            contentLabel?.textAlignment = NSTextAlignment.Center
            contentLabel?.center = CGPoint(x: AppWidth/2, y: AppHeight/2)
            contentLabel?.text = "No content"
            contentLabel?.font = UIFont(name: "Helvetica", size: 16)
            contentLabel?.textColor = UIColor.lightGrayColor()
            contentLabel?.hidden = true
            self.view.addSubview(contentLabel!)
        }
    }

}

///MARK:- UITableViewDelegate和UITableViewDataSource
extension CampaignPage: UITableViewDelegate, UITableViewDataSource {
    

    //个数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if beans.count == 0{
            contentLabel?.hidden = false
        }else{
            contentLabel?.hidden = true
        }
        if beans.count < 8{
            campaign_tableview.footerView?.hidden = true
        }
        
        return beans.count;
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
       
        let bean = beans[indexPath.row];
        if bean.isExpanded {
            return 120;
        }
        return 60
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
            let identifier = "campaign_cell"
            let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? CampaignCell
            campaign_tableview.separatorStyle = UITableViewCellSeparatorStyle.SingleLine;

//            cell!.campaign_label.text = "aaa"
            cell!.layer.masksToBounds = true
            cell?.model = beans[indexPath.row];
            cell?.selectDelegate = self;
            cell?.sel = indexPath;
            return cell!

        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        xwDelay(0.2) { () -> Void in
        let bean = self.beans[indexPath.row];
            self.doShowWeibo(bean)
        }
    }
    
    func doShowWeibo(bean:CampaignBean){
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil);
        let campaign = storyBoard.instantiateViewControllerWithIdentifier("CampaignDetail") as! CampaignDetail
        campaign.bean = bean
        let nav = UINavigationController(rootViewController: campaign);
        self.presentViewController(nav, animated: true, completion: nil)
        
    }
    
    
    func didSelectIndex(bean:CampaignBean,sel:NSIndexPath){
        
        if bean.isExpanded {
            bean.isExpanded = false;

        }else{
            bean.isExpanded = true;
        }
        

        
        campaign_tableview.reloadSections(NSIndexSet(index: sel.section), withRowAnimation: UITableViewRowAnimation.Automatic)

    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar){
        print("开始编辑")
        
    }// called when text starts editing
    
    
    // 输入框内容改变触发事件
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print("过滤：\(searchText)");
        CampaignName = searchText;
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


}
