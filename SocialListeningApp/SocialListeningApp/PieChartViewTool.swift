//
//  PieChartViewTool.swift
//  SocialListeningApp
//
//  Created by chencharles on 16/2/18.
//  Copyright © 2016年 cicdata. All rights reserved.
//


import Foundation
import UIKit
import Charts

class PieChartViewTool: UIView,ChartViewInterface {
    
    var pieChartView: PieChartView = PieChartView();
    
    var y_yals:[String] = []
    
    var lableText = "";

    var dataPoints:[String] = [];
    var values:[Double] = [];
    
    var return_values = [:]
    
    func setData(json:AnyObject,a:Int) -> NSDictionary{
        dataPoints.removeAll();
        values.removeAll();
        pieChartView.removeFromSuperview();
        pieChartView = PieChartView();
        if (NSJSONSerialization.isValidJSONObject(json)) {
//            print(json)
        let campaignId = json.objectForKey("error_code");
        if let _ = campaignId{
            let result = json.objectForKey("result");
            if result is NSNull {
            }else{
                if a == 1{
                    let genderper = result!.objectForKey("genderper")
                    if genderper is NSNull {
                    }else{
//                        print(genderper)
                        var genderper_string = genderper as! String
                        genderper_string.removeAtIndex(genderper_string.endIndex.predecessor())
//                        print(Double(genderper_string))
                        dataPoints.append("男");
                        dataPoints.append("女");
                        self.values.append(Double(genderper_string)!);
                        self.values.append(100-Double(genderper_string)!);

//                    }
                    }
                }
                if a == 2{
                    let education = result!.objectForKey("education")
                    if education is NSNull {
                    }else{
                        for(var i = 0 ; i < education!.count ; i++){
                        let education_name = education![i].objectForKey("name")
                        let education_uv = education![i].objectForKey("uv")
                        dataPoints.append(education_name as! String);
                        self.values.append(Double(education_uv as! String)!);
                        }
                    }
                }
                if a == 3{
                    let personalincome = result!.objectForKey("personalincome")
//                    print(personalincome)
                    if personalincome is NSNull {
                    }else{
                        for(var i = 0 ; i < personalincome!.count ; i++){
                        let personalincome_name = personalincome![i].objectForKey("name")
                        let personalincome_uv = personalincome![i].objectForKey("uv")
//                        print(personalincome_uv)
                        dataPoints.append(personalincome_name as! String);
                        self.values.append(Double(personalincome_uv as! String)!);
                        }
                    }
                }
                if a == 4{
                    let familyincome = result!.objectForKey("familyincome")
                    if familyincome is NSNull {
                    }else{
                        for(var i = 0 ; i < familyincome!.count ; i++){
                        let familyincome_name = familyincome![i].objectForKey("name")
                        let familyincome_uv = familyincome![i].objectForKey("uv")
                        dataPoints.append(familyincome_name as! String);
                        self.values.append(Double(familyincome_uv as! String)!);
                        }
                    }
                }
                if a == 5{
                    let name = result!.objectForKey("name") as! NSArray
                    let imp_sales = result!.objectForKey("imp_sales")
                    if imp_sales is NSNull {
                    }else{
                        for(var i = 0 ; i < name.count ; i++){
                            let result_name = name[i]
                        var imp:AnyObject
                        if name.count == 1{
                             imp = imp_sales!.objectForKey("imp")!
                            self.values.append(imp[0] as! Double);

                        }else{
                             imp = imp_sales![i].objectForKey("imp")!
                            self.values.append(Double(imp as! String)!);

                        }
                            dataPoints.append(result_name as! String);
                        }
                    }
                }
                
                if a == 6{
                    let result = json.objectForKey("result");
                    if result is NSNull {
                    }else{
//                        print(json)
                        let crowdConvert = result!.objectForKey("crowdConvert")
                        if crowdConvert is NSNull {
                        }else{
                            let target = crowdConvert!.objectForKey("target")
                            if target is NSNull {
                            }else{
                                let imp_target = target!.objectForKey("imp") as! String
                                if imp_target == "-"{
                                self.values.append(0.0);
                                }else{
                                self.values.append(Double(imp_target)!)
                                }
                                dataPoints.append("Target");
                            }
                            let stable = crowdConvert!.objectForKey("stable")
                            if stable is NSNull {
                            }else{
                                let imp_stable = stable!.objectForKey("imp") as! String
                                if imp_stable == "-"{
                                    self.values.append(0.0);
                                }else{
                                    self.values.append(Double(imp_stable)!)
                                }
                                dataPoints.append("Stable");
                            }
                        }
                    }
                }
                
                if a == 7{
                    let result = json.objectForKey("result");
                    if result is NSNull {
                    }else{
                        let crowdConvert = result!.objectForKey("crowdConvert")
                        if crowdConvert is NSNull {
                        }else{
                            let target = crowdConvert!.objectForKey("target")
                            if target is NSNull {
                            }else{
                                let imp_target = target!.objectForKey("uv") as! String
                                if imp_target == "-"{
                                    self.values.append(0.0);
                                }else{
                                    self.values.append(Double(imp_target)!)
                                }
                                dataPoints.append("Target");
                            }
                            let stable = crowdConvert!.objectForKey("stable")
                            if stable is NSNull {
                            }else{
                                let imp_stable = stable!.objectForKey("uv") as! String
                                if imp_stable == "-"{
                                    self.values.append(0.0);
                                }else{
                                    self.values.append(Double(imp_stable)!)
                                }
                                dataPoints.append("Stable");
                            }
                        }
                    }
                }
                
                
            }
        }else{
                let jsonObj = Utils.stringToJson(json);
                let key = jsonObj.objectForKey("KEY");
                let data = jsonObj.objectForKey("DATA");
                let senment = jsonObj.objectForKey("senment");
                if let _ = senment {
                    if (NSJSONSerialization.isValidJSONObject(senment!)) {
                        for(var i = 0 ; i < senment!.count ; i++){
                            let id = senment![i]?.objectForKey("id") as! String;
                            let value = senment![i].objectForKey("value2") as! String;
                            dataPoints.append(id);
                            values.append(Double(value)!);

                        }
                    }
                }else {
                    if let _ = data {
                        if (NSJSONSerialization.isValidJSONObject(data!)) {
                            if let _ = key{
                                let keys = (key as! String).componentsSeparatedByString(",");
                                if keys.count > 1 {
                                    for(var i = 0 ; i < data!.count ; i++){
                                        let id = data![i]?.objectForKey("ID");
                                        if id?.count == 0 {
                                            break;
                                        }
                                        let value = data![i].objectForKey("VALUE")
                                        if let _ = value {
                                            dataPoints.append(id as! String);
                                            self.values.append(Double(value as! String)!);

                                        }
                                    }
                                }else{
                                    let id = data!.objectForKey("ID");
                                    let value = data!.objectForKey("VALUE")
                                    if let _ = value {
                                        dataPoints.append(id as! String);
                                        self.values.append(Double(value as! String)!);
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
        }
        return_values = [
            "piecharts_name":dataPoints,
            "piecharts_values":values
        ]
        setChart(dataPoints,values:values);
        return return_values
    }
    
    
    func setChart(dataPoints:[String],values:[Double]){
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: self.lableText)
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        
        var colors: [UIColor] = []

        let color = UIColor(red: 57/255, green: 203/255, blue: 120/255, alpha: 1)
        let color2 = UIColor(red: 255/255, green: 96/255, blue: 67/255, alpha: 1)
        let color3 = UIColor(red: 255/255, green: 153/255, blue: 50/255, alpha: 1)
        let color4 = UIColor(red: 103/255, green: 201/255, blue: 250/255, alpha: 1)
        let color4_1 = UIColor(red: 230/255, green: 80/255, blue: 123/255, alpha: 1)
        let color4_2 = UIColor(red: 102/255, green: 204/255, blue: 204/255, alpha: 1)
        let color5 = UIColor(red: 218/255, green: 218/255, blue: 218/255, alpha: 1)
        colors.append(color)
        colors.append(color2)
        colors.append(color3)
        colors.append(color4)
        colors.append(color4_1)
        colors.append(color4_2)
        colors.append(color5)

        pieChartDataSet.colors = colors
        pieChartView.frame = self.frame;//.size.height = self.frame.size.height*0.95
        pieChartView.highlightPerTapEnabled = false
//        pieChartView.descriptionTextPosition = CGPoint(x: 0, y: self.bounds.height - 100)
        pieChartView.descriptionText = ""
        pieChartView.drawCenterTextEnabled = true
//        pieChartView.centerText = "aaaaaaaaaaaa"
        pieChartDataSet.drawValuesEnabled = false
        pieChartView.legend.labels = [nil]
        pieChartView.legend.colors = [nil]
        pieChartView.drawSliceTextEnabled = false
        pieChartView.usePercentValuesEnabled = false
//        pieChartView.drawMarkers = true
//        pieChartData.highlightEnabled = false
        //pieChartView.drawHoleEnabled = false
        pieChartView.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
//        pieChartView.layer.borderWidth = 1
//        pieChartView.layer.borderColor = UIColor(red: 105/255.0, green: 105/255.0, blue: 105/255.0, alpha: 0.1).CGColor
        self.addSubview(pieChartView)
    }
    
    func array_changed(a:[Double]) -> [Double] {
        var b:[Double] = []
        b = a.sort(>)
        return b
    }
}