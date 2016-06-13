//
//  E_Shop.swift
//  SocialListeningApp
//
//  Created by ciccic on 16/4/8.
//  Copyright © 2016年 cicdata. All rights reserved.
//

import Foundation
import UIKit
import Charts
import Alamofire


class E_Shop: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var eShop_tableview: UITableView!
    
    var addedSearchBar = false;
    
    private let navtitle = UILabel();
    
    var searchBar:UISearchBar?;
    
    var beans = [CampaignBean]();
    var bean = CampaignBean()
    
    private var CampaignPageIndex = 1;
    
    private let pageSize = 20;

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
        //navigationbar
        navtitle.text = "e-Shop"
        navtitle.textColor = UIColor.blackColor()
        navtitle.frame = CGRectMake(0, 0, 10, 20)
        navigationItem.titleView = navtitle
        //eshop_tableview
        eShop_tableview.delegate = self;
        eShop_tableview.dataSource = self;
        eShop_tableview.separatorStyle = UITableViewCellSeparatorStyle.SingleLine;
        eShop_tableview.tableFooterView = UIView(frame: CGRectZero)
        self.automaticallyAdjustsScrollViewInsets = false
        addRefreshHeaher();
        addSearchBar()
        loadViewData()
    }
    func addRefreshHeaher(){
        let headerView = XWRefreshNormalHeader(target: self, action: "upPullLoadData");
        eShop_tableview.headerView = headerView;
    }
    
    func addSearchBar(){
        searchBar = UISearchBar();
        searchBar?.searchBarStyle = .Minimal;
        searchBar?.frame = CGRectMake(0, 0, AppWidth, 40);
        eShop_tableview.tableHeaderView = searchBar;
        addedSearchBar = true;
        hiddenSearchBar(true);
    }
    
    func hiddenSearchBar(flag:Bool){
        if addedSearchBar {
            if flag == true{
                eShop_tableview.setContentOffset(CGPointMake(0.0,40), animated: false)
                // 如果数据量比较少，searchaBar还是会显示。此时就可以设置table
                // self.frame.origin.y = -searchBarHeight;
            }else{
                eShop_tableview.setContentOffset(CGPointMake(0.0,0.0), animated: false)
            }
            
        }
        
    }
    
    func loadViewData(){
        //        print(event_text);
        //        if event_text != 1001{
        //            Utils.alert_view(self.event_text);
        //            campaign_tableview.headerView?.endRefreshing()
        //            return;
        //        }
        self.pleaseWait()
        //campaign/getEShopList.cic?customerId=128&campaignId=2012111&pageNum=1&pageSize=20
        //数据链接，解析
        let url = rootURL + "campaign/getEShopList.cic";
        let customerId = NSUserDefaults.standardUserDefaults().valueForKey("customerId") as! Int;
        let parameters = [
                        "customerId": customerId,
                        "campaignId": bean.id,
                        "pageNum": CampaignPageIndex,
                        "pageSize": pageSize,

//            "customerId": 124,
//            "campaignId": 2012112,
//            "pageNum": 1,
//            "pageSize": 20
//            
        ]
        Alamofire.request(.GET, url,parameters: parameters as [String : NSObject]).responseJSON{
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
                        let beanss = CampaignBean()
                        beanss.time1 = self.bean.time1
                        beanss.time2 = self.bean.time2
                        beanss.id = temp.objectForKey("id") as! Int;
                        beanss.name = temp.objectForKey("shopName") as! String;
                        beanss.customid = self.bean.id
                        self.beans.append(beanss);
                    }
                    if self.beans.count == 0 {
                    }else{
                        self.eShop_tableview.reloadData();
                        self.eShop_tableview.headerView?.endRefreshing()
                    }
                }
            }else{
            }
            self.clearAllNotice();
        }
    }
    
    //获取tableviewcell个数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return beans.count
        
    }
    //tableviewcell内容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let identifier = "eshop_cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier)
//        if cell == nil {
//            cell = NSBundle.mainBundle().loadNibNamed("BrandTableCell", owner: nil, options: nil).last as? BrandTableCell
//        }
        let tablebean = beans[indexPath.row];
        cell?.textLabel?.text = tablebean.name

        return cell!
        
    }
    //tableViewCell点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        xwDelay(0.2) { () -> Void in
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil);
        let campaign = storyBoard.instantiateViewControllerWithIdentifier("E_ShopDetail") as! E_ShopDetail
        let e_shopbean = self.beans[indexPath.row]
        campaign.beans = e_shopbean

        let nav = UINavigationController(rootViewController: campaign);
        self.presentViewController(nav, animated: true, completion: nil)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    
    func upPullLoadData(){
        //print("下拉刷新");
        CampaignPageIndex = 1
        beans.removeAll();
        loadViewData();
    }
    
    
    func loadMore(){
        // print("上拉加载更多");
        
            self.CampaignPageIndex++;
            let table:UITableView = self.eShop_tableview;
            table.reloadData()
            table.footerView?.endRefreshing()
        
    }



    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func daback(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
}