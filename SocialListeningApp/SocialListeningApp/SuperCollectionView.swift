//
//  SuperTableView.swift
//  TTT
//
//  Created by chencharles on 16/2/1.
//  Copyright © 2016年 cicdata. All rights reserved.
//

import UIKit


class SuperCollectionView: UICollectionView,TableDataCountDelegate {
    var networkView:UIView?
    var networkImg:UIImageView?
    var networkLabel:UILabel?
    var searchBar:UISearchBar?;
    var loadDataDelegate:LoadDataDelegate?;
    /** 如果列表数据不超过minTotalCount，将footview隐藏*/
    var minTotalCount:Int = 0;
    var searchBarHeight:CGFloat = 44;
    var addedHeader = false;
    var addedFooter = false;
    var addedSearchBar = false;
    var showSearchBarWhenSamll = false;
    var showSearchBarWhenBig = false;
    
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        //super.init(frame: frame, style: style)

        super.init(frame: frame, collectionViewLayout: layout);
    }
    

    
    func addSearchBar(){
//        if !addedSearchBar {
            addedSearchBar = true;
            //hiddenSearchBar(true);
//        }
    }
    
    func removeSearchBar(){
        searchBar?.removeFromSuperview()
    }
    
    func removeNetworkError(){
        networkView?.removeFromSuperview()
    }
    
    func addNetworkError() -> UIView{
        networkView = UIView()
        networkView?.frame = CGRectMake(0, 0, self.frame.width, 44);
//        networkView?.backgroundColor = UIColor.redColor()
        networkView?.backgroundColor = UIColor(red: 255/255, green: 223/255, blue: 223/255, alpha: 0.5)
        networkImg = UIImageView(frame: CGRectMake(20, 8, 30, 30))
        networkImg?.image = UIImage(named: "err")!
        networkLabel = UILabel(frame: CGRect(x: 70,y: 0,width: self.frame.width,height: 44))
        networkLabel?.text = "Network error,please try again later"
        networkLabel?.font = UIFont(name: "Helvetica", size: 14)
        networkView?.addSubview(networkImg!)
        networkView?.addSubview(networkLabel!)
       // self.tableHeaderView = networkView
        return networkView!
        
    }
    
    func hiddenSearchBar(flag:Bool){
        if addedSearchBar {
            if flag == true{
                self.setContentOffset(CGPointMake(0.0,searchBarHeight), animated: false)
                // 如果数据量比较少，searchaBar还是会显示。此时就可以设置table
                // self.frame.origin.y = -searchBarHeight;
            }else{
                self.setContentOffset(CGPointMake(0.0,0.0), animated: false)
            }
            
        }
        
    }
    
    
    func addRefreshHeaher(){
        if !addedHeader {
            let headerView = XWRefreshNormalHeader(target: self, action: "upPullLoadData");
            self.headerView = headerView;
            addedHeader = true;
        }
        
    }
    
    func upPullLoadData(){
        loadDataDelegate?.refresh();
    }
    
    func addLoadFooter(){
        if !addedFooter {
            let footerView = XWRefreshAutoNormalFooter(target: self, action: "downPlullLoadData");
            footerView.totalCount = minTotalCount;
            footerView.delegate = self;
            self.footerView = footerView;
            addedFooter = true;
        }
    }
    
    func downPlullLoadData(){
        loadDataDelegate?.loadMore();
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func doSendDataCount(count:Int){
        
        if addedSearchBar == true {
            //print("supe collection view:\(count)");
            if count <= minTotalCount {
                if !showSearchBarWhenSamll{
                    self.setContentOffset(CGPointMake(0.0,searchBarHeight), animated: true)
                    showSearchBarWhenSamll = true;
                }
                
            }else{
                if !showSearchBarWhenBig {
                    self.setContentOffset(CGPointMake(0.0,searchBarHeight), animated: false)
                    showSearchBarWhenBig = true;
                }
                
            }
        }
        
    }
    
}



