//
//  BarChartViewTool.swift
//  SocialListeningApp
//
//  Created by chencharles on 16/2/18.
//  Copyright © 2016年 cicdata. All rights reserved.
//

import Foundation
import UIKit
import Charts

class BarChartViewTool: UIView,ChartViewInterface {
    
    var barChartView: BarChartView = BarChartView();
    
    var lableText = "";
    
    var dataPoints:[String] = [];
    var values:[Double] = [];
    
    
    func setData(json:AnyObject,a:Int) -> NSDictionary{
        
        dataPoints.removeAll();
        values.removeAll();
        
        if (NSJSONSerialization.isValidJSONObject(json)) {
            if a == 1{
//                print(json)
                lableText = "地域信息"
                if json is NSNull {
                }else{
                    for(var k = 0;k<json.count;k++){
                        let province = json[k].objectForKey("PROVINCE") as! String
                        let value = json[k].objectForKey("VALUE") as! Double
                        dataPoints.append(province);
                        self.values.append(value);
                    }
                }
            }else{
            let campaignId = json.objectForKey("error_code");
            if let _ = campaignId{
                let result = json.objectForKey("result");
                if result is NSNull {
                }else{
                    let age = result!.objectForKey("age")
                    lableText = "Age Analysis"
                    if age is NSNull || age == nil {
                    }else{
                    for(var i = 0 ; i < age!.count ; i++){
                        let age_name = age![i].objectForKey("name")
                        let age_uv = age![i].objectForKey("uv")
                        dataPoints.append(age_name as! String);
                        self.values.append(Double(age_uv as! String)!);
                        }
                    }
                }
            }else{
                let jsonObj = Utils.stringToJson(json);
//                print(json)
                lableText = jsonObj.objectForKey("INDEX") as! String;
                if lableText == "Number of Fans Distribution"{
                    let data = jsonObj.objectForKey("DATA");
                    if (NSJSONSerialization.isValidJSONObject(data!)) {
                        let id = data?.objectForKey("ID");
                        let value = data?.objectForKey("VALUE1")
                        if let _ = value {
                            if id?.count == 0 {
                            }else{
                                let id_number = ["0~99","100~499","500~999","1000~4999","5000+"]
                                let values = value!.componentsSeparatedByString(",");
                                dataPoints.append(id_number[0]);
                                self.values.append(Double(values[0])! + Double(values[1])! + Double(values[2])!);
                                dataPoints.append(id_number[1]);
                                self.values.append(Double(values[3])! + Double(values[4])! + Double(values[5])! + Double(values[6])!);
                                dataPoints.append(id_number[2]);
                                self.values.append(Double(values[7])!);
                                dataPoints.append(id_number[3]);
                                self.values.append(Double(values[8])! + Double(values[9])! + Double(values[10])! + Double(values[11])!);
                                dataPoints.append(id_number[4]);
                                if values.count == 13 {
                                    self.values.append(Double(values[12])!);
                                }else{
                                    self.values.append(Double(values[12])! + Double(values[13])!);
                                }
                            }
                        }
                    }
                }else{
                    let data = jsonObj.objectForKey("DATA");
                    if (NSJSONSerialization.isValidJSONObject(data!)) {
                        let id = data?.objectForKey("ID");
                        let value = data?.objectForKey("VALUE1")
                        if let _ = value {
                            if id?.count == 0 {
                            }else{
                                let ids = id!.componentsSeparatedByString(",");
                                let values = value!.componentsSeparatedByString(",");
                                for(var i = 0 ; i < ids.count ; i++){
                                    dataPoints.append(ids[i]);
                                    self.values.append(Double(values[i])!);
                                }
                            }
                        }
                    }
                }
                
            }
            
        }
        }
        setChart(dataPoints,values: values);
        return [:]
    }
    
    
    func setChart(dataPoints:[String],values:[Double]){
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        self.lableText = "";
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: self.lableText)
        let chartData = BarChartData(xVals: dataPoints, dataSet: chartDataSet)
        barChartView.data = chartData
        barChartView.descriptionText = ""
        chartDataSet.colors=[UIColor(red: 57/255, green: 203/255, blue: 120/255, alpha: 1)]
        barChartView.xAxis.labelPosition = .Bottom
        barChartView.frame.size.height = self.frame.size.height*0.95
        barChartView.frame.size.width = self.frame.size.width*0.9
        barChartView.gridBackgroundColor = UIColor.whiteColor()
        barChartView.doubleTapToZoomEnabled = false
        barChartView.setScaleEnabled(false)
        barChartView.rightAxis.drawLabelsEnabled = false
        barChartView.xAxis.gridLineWidth = 0
        barChartView.borderLineWidth = 0
        barChartView.legend.colors = [UIColor.whiteColor()]
//        barChartView.xAxisRenderer
//        barChartView.xAxis.spaceBetweenLabels = 1
        barChartView.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        self.addSubview(barChartView)
    }
}