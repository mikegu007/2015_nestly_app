//
//  Bar2Demo.swift
//  SocialListeningApp
//
//  Created by chencharles on 16/2/24.
//  Copyright © 2016年 cicdata. All rights reserved.
//

import Foundation
import Alamofire
import UIKit


class Bar2Demo: NormalViewController {
    
    private var chart: BarsWithGradientTool = BarsWithGradientTool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chart.frame.size = CGSize(width: AppWidth, height: 200);
        chart.frame.origin = CGPoint(x: 0, y: 64);
        //self.view.backgroundColor = UIColor.whiteColor();
        chart.frame.size = CGSize(width: AppWidth, height: 300);

        //chart.doTest();
        
        self.view.addSubview(chart)
        loadBarLinesChartViewData(chart,barType: "",indexName: "");
    }
    
    
    //http:192.168.4.172:16007/SocialListeningServer/slccAction/getSlccData.cic?pageId=79&type=11
    
    
    func loadBarLinesChartViewData(chart:ChartViewInterface,barType:String,indexName:String){
        //数据链接
        
       
        let url = rootURL + "slccAction/getSlccData.cic";
        //http:192.168.4.172:16007/SocialListeningServer/wechatAccount/showNewFansGenderOrCity.cic?dayId=7&wechatUserId=166&beginTime=2016-02-25&endTime=2016-03-02&statType=day&sign=1&clientId=101077
        
        let parameters = [
            "pageId": 79,
            "type":11
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