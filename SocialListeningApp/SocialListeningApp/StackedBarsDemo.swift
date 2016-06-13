//
//  StackedBarsDemo.swift
//  SocialListeningApp
//
//  Created by chencharles on 16/3/10.
//  Copyright © 2016年 cicdata. All rights reserved.
//

import Foundation
import UIKit
import SwiftCharts
import Alamofire

class StackedBarsDemo: NormalViewController {
    
    
    private var chart: StackedBarsViewTool = StackedBarsViewTool();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chart.frame = self.view.frame;
        //chart.showChart(horizontal: false);
        chart.frame.size = CGSize(width: AppWidth, height: 200);

        chart.frame.origin = CGPoint(x: 0, y: 64);

        self.view.backgroundColor = UIColor.whiteColor();
        self.view.addSubview(chart)
        
        
        loadBarLinesChartViewData(chart,barType: "",indexName: "");
    }
    
    
    func loadBarLinesChartViewData(chart:ChartViewInterface,barType:String,indexName:String){
        //数据链接
        
        let time1 = "2016-03-04";//Utils.getDateString(-7);
        let time2 = "2016-03-10";//Utils.getDateString(-1);
        let mediaUserId = 22
        
        let url = rootURL + "wechatAccount/showNewFansGenderOrCity.cic";
        //http:192.168.4.172:16007/SocialListeningServer/wechatAccount/showNewFansGenderOrCity.cic?dayId=7&wechatUserId=166&beginTime=2016-02-25&endTime=2016-03-02&statType=day&sign=1&clientId=101077
        
        let parameters = [
            "dayId": 30,
            "wechatUserId":mediaUserId,
            "beginTime":time2,
            "endTime":time1,
            "statType":"day",
            "sign":1,
            "clientId": 101077
        ]
        
        Alamofire.request(.GET, url,parameters: parameters as! [String : AnyObject]).responseJSON{
            data in
            //print(data)
            if(data.result.isSuccess){
                let json = data.result.value!;
                chart.setData(json,a: 0)
            }else{
                Utils.alert_view(1011);
            }
        }
    }
    
}