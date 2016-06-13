//
//  BarsPlusMinusAndLinesExample.swift
//  SwiftCharts
//
//  Created by ischuetz on 04/05/15.
//  Copyright (c) 2015 ivanschuetz. All rights reserved.
//

import UIKit
import SwiftCharts
import Alamofire

class AreasChartViewDemo: NormalViewController {
    
    
    private var chart: AreasChartViewTool = AreasChartViewTool();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chart.frame = self.view.frame;
        
        chart.frame.origin = CGPoint(x: 0, y: 64);
        chart.frame.size = CGSize(width: AppWidth, height: 300);

        //chart.doTest();
        
        self.view.addSubview(chart)
        
        loadAreaChartViewData(chart,barType: "STAT_CHANNEL_PER_HOUR",indexName: "");
        
    }
    
    func loadAreaChartViewData(chart:ChartViewInterface,barType:String,indexName:String){
                //数据链接
        
        let time1 = "2016-03-04";//Utils.getDateString(-7);
        let time2 = "2016-03-10";//Utils.getDateString(-1);
        let mediaUserId = 22
        let url = rootURL + "wechatAccount/showWechatGraphicShareArea.cic";
        //http:192.168.4.172:16007/SocialListeningServer/wechatAccount/showWechatGraphicShareArea.cic?dayId=7&wechatUserId=166&beginTime=2016-02-25&endTime=2016-03-02&statType=day&sign=1&clientId=101077
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
    
}
