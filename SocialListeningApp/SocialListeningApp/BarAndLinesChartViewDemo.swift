//
//  NotNumericExample.swift
//  SwiftCharts
//
//  Created by ischuetz on 04/05/15.
//  Copyright (c) 2015 ivanschuetz. All rights reserved.
//

import UIKit
import SwiftCharts
import Alamofire

class BarAndLinesChartViewDemo: NormalViewController {
    
    private var chart: BarAndLinesChartViewTool?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view2 = UIView();
        view2.frame = self.view.frame;

        self.view.addSubview(view2)
        self.view.backgroundColor = UIColor.whiteColor();
        
        chart = BarAndLinesChartViewTool();
        chart!.frame = view2.frame;
        chart!.frame.origin = CGPoint(x: 0, y: 64);
        chart!.frame.size = CGSize(width: AppWidth, height: 300);

        //chart?.frame.origin.y = 70;
        //chart!.doTest();
        
        view2.addSubview(chart!)
        
        //loadBarLinesChartViewData(chart!,barType: "STAT_CHANNEL_PER_HOUR",indexName: "");
        
        //loadBarLinesChartViewData2(chart!,barType: "STAT_CHANNEL_PER_HOUR",indexName: "");

        loadBarLinesChartViewData3(chart!,barType: "STAT_CHANNEL_PER_HOUR",indexName: "");

    }
    
    
    func loadBarLinesChartViewData2(chart:ChartViewInterface,barType:String,indexName:String){
        //数据链接
        
        
        let url = rootURL + "highcharts/getDataChart.cic";
        //http:192.168.4.172:16007/SocialListeningServer/highcharts/getDataChart.cic?para=jsonfile=stat_user_per|bean=statUserBarLine|barType=STAT_CHANNEL_PER_HOUR|mediaUserId=3245550107|mediaType=1|beginTime=2016-01-31|endTime=2016-02-29|groupId=undefined&chartType=userBarLine&clientId=101077
        
        let parameters = [
            "para": "jsonfile=stat_user_per|bean=statUserBarLine|barType=STAT_CHANNEL_PER_HOUR|mediaUserId=3245550107|mediaType=1|beginTime=2016-02-31|endTime=2016-03-10|groupId=undefined",
            "chartType":"userBarLine",
            "indexName":indexName,
            "clientId": 101077
        ]
        
        Alamofire.request(.GET, url,parameters: parameters as? [String : AnyObject]).responseJSON{
            data in
            if(data.result.isSuccess){
                let json = data.result.value!;
                chart.setData(json,a: 0)
            }else{
                Utils.alert_view(1011);
            }
        }
    }
    
    func loadBarLinesChartViewData(chart:ChartViewInterface,barType:String,indexName:String){
        //数据链接
        
        var time1 = "2016-02-25";//Utils.getDateString(-7);
        var time2 = "2016-03-02";//Utils.getDateString(-1);
        var mediaUserId = 166
        let url = rootURL + "wechatAccount/showGraphicStatistics.cic";
        //http:192.168.4.172:16007/SocialListeningServer/highcharts/getDataChart.cic?para=jsonfile=stat_user_per|bean=statUserBarLine|barType=STAT_CHANNEL_PER_HOUR|mediaUserId=3245550107|mediaType=1|beginTime=2016-01-31|endTime=2016-02-29|groupId=undefined&chartType=userBarLine&clientId=101077
        
        let parameters = [
            "dayId": 14,
            "wechatUserId":mediaUserId,
            "beginTime":time1,
            "endTime":time2,
            "statType":"day",
            "sign":1,
            "clientId": 101077
        ]
        
        Alamofire.request(.GET, url,parameters: parameters as? [String : AnyObject]).responseJSON{
            data in
            if(data.result.isSuccess){
                let json = data.result.value!;
                chart.setData(json,a: 0)
            }else{
                Utils.alert_view(1011);
            }
        }
    }
    
    
    func loadBarLinesChartViewData3(chart:ChartViewInterface,barType:String,indexName:String){
        //数据链接
        
        
        let url = rootURL + "slccAction/getSlccData.cic";
        //http:192.168.4.172:16007/SocialListeningServer/wechatAccount/showNewFansGenderOrCity.cic?dayId=7&wechatUserId=166&beginTime=2016-02-25&endTime=2016-03-02&statType=day&sign=1&clientId=101077
        
        let parameters = [
            "pageId": 79,
            "type":11
        ]
        
        Alamofire.request(.GET, url,parameters: parameters).responseJSON{
            data in
            //print(data);
            if(data.result.isSuccess){
                let json = data.result.value!;
                chart.setData(json,a: 0)
            }else{
                Utils.alert_view(1011);
            }
        }
    }
    
}


