//
//  XWRefreshAutoNormalFooter.swift
//  XWSwiftRefresh
//
//  Created by Xiong Wei on 15/10/6.
//  Copyright © 2015年 Xiong Wei. All rights reserved.
//  新浪微博: @爱吃香干炒肉


import UIKit

/** footerView 带有菊花和状态文字的 */
public class XWRefreshAutoNormalFooter: XWRefreshAutoStateFooter {
    
    //MARK: 外部访问
    /** 菊花样式 */
    public var activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray {
        
        didSet{
            self.activityView.activityIndicatorViewStyle = activityIndicatorViewStyle
            self.setNeedsLayout()
        }
    }
    
    
    //MARK: 私有
    
    //菊花
    lazy var activityView:UIActivityIndicatorView = {
        
        [unowned self] in
        
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: self.activityIndicatorViewStyle)
        activityView.hidesWhenStopped = true
        self.addSubview(activityView)
        
        return activityView
        }()
    
    
    //MARK: 重写
    override func placeSubvies() {
        super.placeSubvies()
        //菊花
        var activityViewCenterX = self.xw_width * 0.5
        if !self.refreshingTitleHidden { activityViewCenterX -=  XWRefreshFooterActivityViewDeviation }
        let activityViewCenterY = self.xw_height * 0.5
        self.activityView.center = CGPointMake(activityViewCenterX, activityViewCenterY)
    }
    
    override var state:XWRefreshState{
        didSet{
            if oldValue == state { return }
                
                
            if  state == XWRefreshState.NoMoreData || state == XWRefreshState.Idle {
                
                self.activityView.stopAnimating();
                //print("stopAnimating....");
                //self.frame.size.width = 0;
                //self.activityView.hidden = true;

            }else if state == XWRefreshState.Refreshing  {
                //self.addSubview(activityView);
                //let tableView:UITableView = self.superview as! UITableView;
                //(tableView.tableFooterView = self);
                //self.hidden = false;
                //self.activityView.hidden = false;
                //self.frame.size.width = 100;

                //print("startAnimating....");
                //();

                self.activityView.startAnimating()
            }else{
               // self.removeFromSuperview();
                
            }
        }
    }

    

}
