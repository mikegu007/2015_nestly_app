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


class EarnedPage: MainUIViewController,DoubleTextViewDelegate,LoadDataDelegate,UISearchBarDelegate,IntentDelegate{
    
    var networkView:UIView?
    var networkImg:UIImageView?
    var networkLabel:UILabel?
    
    @IBOutlet weak var viewNormal: UIView!
    
    @IBOutlet weak var switchBtn: DoubleTextView!
    
    var mainScrollView:UIScrollView!;
    
    var tableView1:MainTableView!;
    //初始化
    let layout = UICollectionViewFlowLayout()
    var collection_view:SuperCollectionView!;
    
    // 记录切换到哪个tab
    private var currIndex = 0;
    // -1 都没有权限 0 第一个有权限 1 第二个有权限 2 都有权限
    private var ownedType = 2;
    
    private var event_text = 1001
    
    private var selectRow:NSIndexPath?;
    
    var keywords = [AccountBean]();
    var slcc = [AccountBean]();
    private let brand = UILabel();
    private var keywordPageIndex = 1;
    private var slccPageIndex = 1;
    
    private var keywordHaveNextPage = true;
    private var slccHaveNextPage = false;
    
    private let pageSize = 20;
    // SLCC数据加载次数，首次加载隐藏search Bar
    private var loadCount = 1;

    var keywordName:String = "";
    var slccName:String = "";
    private var searchBar:UISearchBar!;
    
    var contentLabel1:UILabel?
    var contentLabel2:UILabel?

    private var viewWidth = AppWidth;
    private var viewHeight = AppHeight;
    
    private var keywordTableContentOff:CGFloat = CGFloat()
    private var collectionContentOff:CGFloat = CGFloat()
    
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
        
        //changetitle
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changetitle:", name: "changeBrand", object: nil)
        
        //网络判断
        NSNotificationCenter.defaultCenter().addObserver(self,selector: "reachabilityChanged:",name: ReachabilityChangedNotification,object: nil)

        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: UIBarButtonItemStyle.Plain, target: self, action: "doShowView");
        
        switchBtn.backgroundColor = UIColor.colorWith(249, green: 249, blue: 249, alpha: 1);
        
        brand.text = BrandName;
        brand.textColor = UIColor.whiteColor();
        brand.frame = CGRectMake(0, 0, 10, 20)
        brand.textAlignment = NSTextAlignment.Center
        navigationItem.titleView = brand;
        navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        
        print("is :\(portraitFlag)");
        
        setMainScrollView();
        
        set1TableView();
        
       
        searchBar = UISearchBar();
        searchBar.delegate = self;
        searchBar.searchBarStyle = .Minimal;
        searchBar.frame = CGRectMake(0, 0, viewWidth, 44);
        searchBar.backgroundColor = UIColor.whiteColor();
        
        
        setCollectionView();
//        addLoadFooter()
        
        let weiboTab = NSUserDefaults.standardUserDefaults().valueForKey("6");
        let wechatTab = NSUserDefaults.standardUserDefaults().valueForKey("7");
        
        var weiboStr = ""//Keyword
        var wechatStr = ""//Visual
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
        
        //ownedType = 0;
        
        //属性配置
        if ownedType == 1 {
            currIndex = 1;
        }else{
            currIndex = 0;
        }
        //属性配置
        switchBtn.initTitle(weiboStr, rigthText: wechatStr,clickIndex: ownedType)
        if ownedType != 2 {
            mainScrollView.scrollEnabled = false;
        }
        
        
        addErrorContent();

       
    }
    
    
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        if reachability.isReachable() {
            if reachability.isReachableViaWiFi() {
                print("Earned Reachable via WiFi")
                event_text = 1001
                setSearchBar()

            } else {
                print("Earned Reachable via Cellular")
                event_text = 1001
                setSearchBar()

            }
        } else {
            print("Earned Not reachable")
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
        collection_view.removeNetworkError()
        //collection_view.addSearchBar();
//        collection_view.reloadItemsAtIndexPaths(collection_view.indexPathsForVisibleItems())
        collection_view.reloadData();
    }
    
    func setNetworkError(){
        tableView1.removeSearchBar()
        tableView1.addNetworkError()
        collection_view.removeSearchBar()
        //collection_view.addNetworkError()
        //collection_view.reloadData();
//        collection_view.reloadItemsAtIndexPaths(collection_view.indexPathsForVisibleItems())
        collection_view.reloadData();
//[self.photosCollection reloadItemsAtIndexPaths:[self.photosCollection indexPathsForVisibleItems]];
    }
    
    
    override func viewDidAppear(animated: Bool) {
        print("aa portraitFlag:\(portraitFlag)");
        if keywordTableContentOff > 100{
            tableView1.contentOffset.y = keywordTableContentOff
        }
        if collectionContentOff > 100{
//            collection_view.contentOffset.y = collectionContentOff
        }
        // 进来就是横屏
        if portraitFlag {
            UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent;
            self.tabBarController?.tabBar.hidden = true
            
        }else{
            UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent;
            self.tabBarController?.tabBar.hidden = false
        }
        
        setViewsSize();
        
        isShow = true;
        
       
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
        self.collection_view.addSubview(contentLabel2!)
    }
    
    func doNone(){
        
    }
    
    
    func changetitle(bean:NSNotification){
        
        let temp = bean.object as! BrandBean;
        brand.text = temp.name;
        BrandName = temp.name;
        BrandId = temp.id;
        //print("changetitle");
        
        if BrandId > 0 {
            slcc.removeAll();
            keywords.removeAll();
            
            keywordHaveNextPage = true;
            slccHaveNextPage = false;
            
            keywordPageIndex = 1;
            slccPageIndex = 1;
            
            loadCount = 1;
            
            //keyword一次性加载次数
            for(var k = 0; k < 12; k++ ){
                if keywordHaveNextPage {
                    self.loadView1Data()
                    keywordPageIndex++

                }else{
                    self.clearAllNotice();
                }
            }
            loadView2Data();
        }
        
    }
    
    
    func createWeiboAccount(tag:String){
        for var i = 0 ; i < 10 ; i++ {
            let bean = AccountBean();
            bean.name = "tom\(i)\(tag)";
            
            if i % 2 == 0{
                bean.img = "test2";
                bean.imageurl = "http://pica.nipic.com/2007-11-09/200711912453162_2.jpg";
            }else{
                bean.img = "test";
                bean.imageurl = "http://pic14.nipic.com/20110522/7411759_164157418126_2.jpg";
            }
            keywords.append(bean);
        }
    }
    

    
    override func tabBarTitle(index:Int){
        print("AA isShow:\(isShow),index:\(index)");
        if isShow {
            // 横屏
            if index == 0 {
                self.tabBarController?.tabBar.hidden = true
                UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent;
                UIApplication.sharedApplication().statusBarHidden = false;
                // 竖屏
            }else{
                UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent;
                self.tabBarController?.tabBar.hidden = false
                
            }
            
            setViewsSize();
        }
    }
    
    private func setViewsSize(){
        if portraitFlag{
            viewWidth = AppHeight;
            viewHeight = AppWidth - NavigationH;
        }else{
            viewWidth = AppWidth;
            viewHeight = AppHeight - NavigationH - TabBarH;
        }
        
        mainScrollView.frame.size = CGSize(width: viewWidth, height: viewHeight)
        mainScrollView.contentSize = CGSizeMake(viewWidth * 2.0, 0)

        
        if  mainScrollView.scrollEnabled == true{
            switchBtn.clickBtn(currIndex);

        }
        
        if currIndex == 1 {
            mainScrollView.setContentOffset(CGPointMake(viewWidth * CGFloat(currIndex), 0), animated: true)
        }
        
        searchBar.frame = CGRectMake(0, 0, viewWidth, 44);

        tableView1.frame.size = CGSize(width: viewWidth, height: mainScrollView.height)
        collection_view.frame = CGRectMake(viewWidth,0, viewWidth, mainScrollView.height)

    }
    
    private func setMainScrollView() {
        self.automaticallyAdjustsScrollViewInsets = false
        mainScrollView = UIScrollView(frame: CGRectMake(0, 40, AppWidth, AppHeight - NavigationH - TabBarH))
        mainScrollView.backgroundColor = theme.SDBackgroundColor
        mainScrollView.contentSize = CGSizeMake(AppWidth * 2.0, 0)
        mainScrollView.bounces = true
        mainScrollView.showsHorizontalScrollIndicator = false
        mainScrollView.showsVerticalScrollIndicator = false
        mainScrollView.pagingEnabled = true
        mainScrollView.delegate = self
        viewNormal.addSubview(mainScrollView)
    }
    
    private func set1TableView() {
        tableView1 = MainTableView(frame: CGRectMake(0, 0, AppWidth, mainScrollView.height), style: .Grouped, dataSource: self, delegate: self)
        tableView1.delegate = self
        tableView1.dataSource = self
        tableView1.addSearchBar();
        tableView1.searchBar?.delegate = self;
        tableView1.addRefreshHeaher();
        let totalCount = Int((AppHeight - NavigationH - TabBarH - 40) / 80);
        //print("tableView1 totalCount:\(totalCount)");
        tableView1.minTotalCount = totalCount;
        tableView1.addLoadFooter();
        tableView1.loadDataDelegate = self;
        tableView1.hiddenSearchBar(false);
        
        mainScrollView.addSubview(tableView1)
        
    }
    

    
    private func setCollectionView() {
        self.collection_view = SuperCollectionView(frame: CGRectMake(AppWidth, 0, AppWidth, mainScrollView.height), collectionViewLayout: layout)
    
        let totalCount = Int((AppHeight - NavigationH - TabBarH - 40) / 100);

        self.collection_view.minTotalCount = totalCount*2;
        self.collection_view.addRefreshHeaher();
        self.collection_view.loadDataDelegate = self;

        //代理
        collection_view.delegate = self
        collection_view.dataSource = self
        //相关配置
        let collectionwidth = (AppWidth/2)
        collection_view.backgroundColor = UIColor.whiteColor()
        layout.itemSize = CGSizeMake(collectionwidth, 100)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        mainScrollView.addSubview(collection_view)
        
        //collection_view.setContentOffset(CGPointMake(0.0,-11), animated: false)

        
        layout.headerReferenceSize = CGSizeMake(AppWidth, 44);
        
        //cell的注册
        collection_view.registerNib(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collection_cell")
        //header的注册
        collection_view.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headView")
        
        
        //collection_view.add
    }
    
    
    func endRefreshing(table:MainTableView){
        table.reloadData();
        table.headerView?.endRefreshing()
//        table.footerView?.endRefreshing()
    }
    
    func loadView1Data(){
        
        if ownedType == -1 || ownedType == 1{
            self.endRefreshing(self.tableView1);
            return;
        }
        
        print("初始化加载数据keyword");
        if event_text != 1001{
            Utils.alert_view(self.event_text);
            self.endRefreshing(self.tableView1);
            return;
        }
        self.pleaseWait()

        //数据链接，解析
        let url = rootURL + "brand/getBrandService.cic";
        let parameters = [
            "brandId": BrandId,
            "serviceType":3,
            "pageNum":keywordPageIndex,
            "pageSize":pageSize,
            "userName":keywordName
        ]
//        print("brandId=\(BrandId)")
//        print("pageNum=\(keywordPageIndex)")
//        print("pageSize=\(pageSize)")
//        print("userName=\(keywordName)")


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
                        bean.name = temp.objectForKey("channelName") as! String;
                        bean.id = temp.objectForKey("channelId") as! Int;
                        bean.clientId = temp.objectForKey("iwmcClientid") as! Int;
                        self.keywords.append(bean);
                    }
                    if self.pageSize == jsonObj.count {
                        self.keywordHaveNextPage = true;
                    }else{
                        self.keywordHaveNextPage = false
                        }
                    self.endRefreshing(self.tableView1);
                }
            }else{
                if self.event_text == 1003{
                }else{
//                    Utils.alert_view(1011);
                    print("Connection error")
                }            }
            
            self.clearAllNotice();
        }
//        print(keywordPageIndex)

        
    }
    
    
    
    func loadView2Data(){
        
        if ownedType == 0 || ownedType == -1{
                        
            return;
        }
        print("初始化加载数据slcc");
        if event_text != 1001{
            Utils.alert_view(self.event_text);
//            self.endRefreshing(self.tableView1);
            return;
        }
        self.pleaseWait()

        //数据链接，解析
        let url = rootURL + "brand/getBrandService.cic";
        let parameters = [
            "brandId": BrandId,
            "serviceType":4,
            "pageNum":slccPageIndex,
            "pageSize":pageSize,
            "userName":slccName
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
                        bean.name = temp.objectForKey("visualName") as! String;
                        bean.id = temp.objectForKey("visualId") as! Int;
                        bean.slccClientId = temp.objectForKey("slccClientid") as! Int;
                        self.slcc.append(bean);
                    }
                    
                    if self.pageSize == jsonObj.count {
                        self.slccHaveNextPage = true;
                    }else{
                        self.slccHaveNextPage = false
                    }
                    //print("slcc data reload..slcc count :\(self.slcc.count)");
                    

                    dispatch_async(dispatch_get_main_queue()){
                        self.collection_view.reloadData();
                    }
                    if self.slccPageIndex == 1 {
                        if self.collection_view.minTotalCount < jsonObj.count {
                            self.collection_view.addLoadFooter();
                        }
                    }

                    self.loadCount++;
                    
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
        //print("下拉刷新");
        keywordPageIndex = 1;
        keywordHaveNextPage = true;
        keywords.removeAll();
        for(var k = 0; k < 12; k++ ){
            if keywordHaveNextPage {
                self.loadView1Data()
                keywordPageIndex++
            }else{
                self.clearAllNotice();
            }
        }
        
    }
    
    func loadSLCCData(){
        slccHaveNextPage = false;
        slccPageIndex = 1;
        slcc.removeAll();
        loadView2Data();
        collection_view.headerView?.endRefreshing();
    }
    
    func refresh(){
        if currIndex == 0{
            upPullLoadData();

        }else{
            loadSLCCData();
        }
    }
    
//    func addLoadFooter(){
//        let footerView = XWRefreshAutoNormalFooter(target: self, action: "loadMore1");
//        tableView1.footerView = footerView;
//    }
//    
//    func loadMore1(){
//        print("上拉加载更多2");
//        for(var k = 0; k < 200; k++ ){
//            if keywordHaveNextPage {
////                print(keywordHaveNextPage)
//                keywordPageIndex++
//                self.loadView1Data()
//            }else{
//                return
//            }
//        }
//    }
    func loadMore1(){
        print("上拉加载更多");
        self.pleaseWait()
        if self.currIndex == 0{
            for(var k = 0; k < 200; k++ ){
                if keywordHaveNextPage {
                    keywordPageIndex++
                    self.loadView1Data()
                }else{
                    self.clearAllNotice();
                    return
                }
            }

            
        }else{
            if slccHaveNextPage {
                slccPageIndex++;
                loadView2Data();
                collection_view.footerView?.endRefreshing();
            }
        }
    }
    
    func loadMore(){}
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
 
    
    
    func doShowView() {

        if keywordName != "" || slccName != ""{
            searchBar.text = ""
            tableView1.clearSearchBar()
            keywordName = ""
            slccName = ""
            //upPullLoadData()
        }
        
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil);
        let one = storyBoard.instantiateViewControllerWithIdentifier("BrandList") as! BrandList;
        one.intentDelegate = self;
        let nav = UINavigationController(rootViewController: one);
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    func doubleTextView(doubleTextView: DoubleTextView, didClickBtn btn: UIButton, forIndex index: Int){
        //print("forIndex:\(String(index))");
        currIndex = index;
        //if portraitFlag {
            
        //}
        mainScrollView.setContentOffset(CGPointMake(viewWidth * CGFloat(index), 0), animated: true)
    }
}



/// MARK: UImainScrollViewDelegate
extension EarnedPage: UIScrollViewDelegate {
    
    // MARK: - UImainScrollViewDelegate 监听mainScrollView的滚动事件
    func scrollViewDidEndDecelerating(mainScrollView: UIScrollView) {
        if mainScrollView == self.mainScrollView {
            let index = Int(mainScrollView.contentOffset.x / (AppWidth))
            //print("tab index:\(index)");
            self.currIndex = index;
            switchBtn.changeBtnStyleIndex(index)
        }
        if mainScrollView == collection_view{
            collectionContentOff = collection_view.contentOffset.y
        }
    }
    
    
    
}

///MARK:- UITableViewDelegate和UITableViewDataSource
extension EarnedPage: UITableViewDelegate, UITableViewDataSource {

    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == tableView1 {
//            print("weiboAccounts.count:\(keywords.count)");
            if event_text == 1003{
            }else{
                if(keywords.count == 0){
                    contentLabel1?.hidden = false
                }else{
                    contentLabel1?.hidden = true
                }
            }
            return keywords.count;
        }
        return 0;
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if tableView == tableView1 {
            return 60;
        }
        
        return 100;
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView == tableView1 { 
            
            let identifier = "themeCell"
            
            var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? KeywordTableCell
            if cell == nil {
                cell = NSBundle.mainBundle().loadNibNamed("KeywordTableCell", owner: nil, options: nil).last as? KeywordTableCell
            }
            let bean = keywords[indexPath.row];
            cell!.model = bean;
            return cell!;
            
        }
        return UITableViewCell()
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        xwDelay(0.2) { () -> Void in
        if let _ = self.tableView1 {
            if  tableView == self.tableView1 {
            let bean = self.keywords[indexPath.row];
                self.doShowKeyword(bean)
            }
        }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    func doShowKeyword(bean:AccountBean){
        //UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default;
        
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil);
        let keyword = storyBoard.instantiateViewControllerWithIdentifier("KeywordInfo") as! KeywordInfo;
        keyword.bean = bean
        let nav = UINavigationController(rootViewController: keyword);
        self.presentViewController(nav, animated: true, completion: nil)
        
        //self.navigationController?.pushViewController(one, animated: true);
        
    }
    
    func doShowVisual(bean:AccountBean){
        // UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default;
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil);
//        let category_review = storyBoard.instantiateViewControllerWithIdentifier("category_review") as! CategoryReview;
        let category_review = storyBoard.instantiateViewControllerWithIdentifier("category_reviewinfo") as! CategoryReviewInfo
        category_review.bean = bean
        category_review.portraitFlag = portraitFlag;
        let nav = UINavigationController(rootViewController: category_review);
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath){
        selectRow = indexPath;
        
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == tableView1{
            keywordTableContentOff = tableView1.contentOffset.y
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
        print("过滤：(searchText)")
        if currIndex == 0{
            keywordName = searchText;
        }else{
            slccName = searchText;
        }
        // 开始搜索所有数据
        if searchText == "" {
            refresh();
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
        refresh();
    }
    
    func getIntentValue(value:AnyObject){
        BrandName = value as! String;
        let label = self.navigationItem.titleView as! UILabel;
        label.text = BrandName;
        
    }
    
    


}

///MARK:- UICollectionViewDelegate和UICollectionViewDataSource
extension EarnedPage: UICollectionViewDelegate, UICollectionViewDataSource {
    // CollectionView行数
    func collectionView(collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int {
        if event_text == 1003{
        }else{
            if loadCount == 2 {
                collection_view.setContentOffset(CGPoint(x: 0, y: 44), animated: true);
            }
            if(slcc.count == 0){
                contentLabel2?.hidden = false
            }else{
                contentLabel2?.hidden = true
            }
        }
        return slcc.count
    }
    // 获取单元格
     func collectionView(collectionView: UICollectionView,cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collection_cell", forIndexPath: indexPath) as! CollectionViewCell
        let bean = slcc[indexPath.row];
        cell.model = bean
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView
    
    {
        var cell = UICollectionReusableView();
        if kind == UICollectionElementKindSectionHeader{
            
            cell = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "headView", forIndexPath: indexPath)
            cell.frame.size = CGSizeMake(viewWidth, 44);
            if event_text == 1003{
                searchBar.removeFromSuperview()
                cell.addSubview(collection_view.addNetworkError())
            }else{
                collection_view.addNetworkError().removeFromSuperview()
                cell.addSubview(searchBar);
                cell.layoutSubviews();
            }
            
        }
        
        return cell;
    }
    //点击
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        xwDelay(0.2) { () -> Void in
        if !self.slcc.isEmpty {
            let bean = self.slcc[indexPath.row];
            self.doShowVisual(bean)
            }
        }

    }
    
    

    
}