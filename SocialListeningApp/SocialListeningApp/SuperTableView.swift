//
//  SuperTableView.swift
//  TTT
//
//  Created by chencharles on 16/2/1.
//  Copyright © 2016年 cicdata. All rights reserved.
//

import UIKit


class MainTableView: UITableView,TableDataCountDelegate {
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
    
    
    
    init(frame: CGRect, style: UITableViewStyle, dataSource: UITableViewDataSource?, delegate: UITableViewDelegate?) {
        super.init(frame: frame, style: style)
        self.delegate = delegate
        self.dataSource = dataSource
        separatorStyle = .None
        self.separatorStyle = UITableViewCellSeparatorStyle.SingleLine;
        backgroundColor = theme.SDBackgroundColor;

    }
    
    func addSearchBar(){
        if !addedSearchBar {
            if let _ = searchBar {
            }else{
                searchBar = UISearchBar();
                searchBar?.searchBarStyle = .Minimal;
                searchBar?.frame = CGRectMake(0, 0, self.frame.width, searchBarHeight);
            }
            self.tableHeaderView = searchBar;
            addedSearchBar = true;
            hiddenSearchBar(true);
        }
    }
    
    func removeSearchBar(){
        searchBar?.removeFromSuperview()
    }
    
    func clearSearchBar(){
        searchBar?.text = ""
    }
    
    func addNetworkError(){
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
        self.tableHeaderView = networkView

    }
    
    func removeNetworkError(){
        networkView?.removeFromSuperview()  
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
        
        if addedSearchBar {
            
            if count <= minTotalCount {
                if !showSearchBarWhenSamll{
                    self.setContentOffset(CGPointMake(0.0,searchBarHeight), animated: false)
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

protocol LoadDataDelegate{
    func refresh();
    func loadMore();
}


