//
//  GroupBarsDemo.swift
//  SocialListeningApp
//
//  Created by chencharles on 16/3/10.
//  Copyright © 2016年 cicdata. All rights reserved.
//

import Foundation

import Foundation
import UIKit
import SwiftCharts
import Alamofire





class GroupBarsDemo: NormalViewController {
    
    
    private var chart: GroupedBarsViewTool = GroupedBarsViewTool();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chart.frame = self.view.frame;
        //chart.showChart(horizontal: false);
        chart.frame.origin = CGPoint(x: 0, y: 64);
        chart.frame.size = CGSize(width: AppWidth, height: 300);

        self.view.addSubview(chart)
        
        loadBarLinesChartViewData(chart,barType: "",indexName: "");

    }
    
    
    func loadBarLinesChartViewData(chart:ChartViewInterface,barType:String,indexName:String){
        //数据链接
        
        
        let url = rootURL + "highcharts/getDataChart.cic";
        //http:192.168.4.172:16007/SocialListeningServer/highcharts/getDataChart.cic?para=jsonfile=stat_user_per|bean=statUserBarLine|barType=STAT_CHANNEL_PER_HOUR|mediaUserId=3245550107|mediaType=1|beginTime=2016-01-31|endTime=2016-02-29|groupId=undefined&chartType=userBarLine&clientId=101077
        
        let parameters = [
            "para": "jsonfile=stat_channel_m_bar|bean=statMBar|barType=STAT_STATUS_TAG_DAY|mediaUserId=3245550107|mediaType=1|beginTime=2016-01-13|endTime=2016-03-13|accountId=28582|tagIds=1293385,1371728,1306160,1394941,1394596",
            "chartType":"userBar",
            "indexName":"TopicAnalysis",
            "clientId": 101077
        ]
        
        Alamofire.request(.GET, url,parameters: parameters).responseJSON{
            data in
            if(data.result.isSuccess){
                let json = data.result.value!;
                chart.setData(json,a: 0)
            }else{
                Utils.alert_view(1011);
            }
        }
    }
    
}