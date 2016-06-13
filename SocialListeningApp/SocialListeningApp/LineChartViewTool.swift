//
//  LineChartView.swift
//  SocialListeningApp
//
//  Created by chencharles on 16/2/18.
//  Copyright © 2016年 cicdata. All rights reserved.
//

import UIKit
import Charts

class LineChartViewTool: UIView,ChartViewInterface {
    
    var lineChartView: LineChartView = LineChartView();
    
    var lableText = "";
    
    var dataPoints:[String] = [];
    var values:[Double] = [];

    
    func setData(json:AnyObject,a:Int) -> NSDictionary{
        dataPoints.removeAll();
        values.removeAll();
        //self.removeFromSuperview();
        if (NSJSONSerialization.isValidJSONObject(json)) {
            let jsonObj = Utils.stringToJson(json);
            lableText = jsonObj.objectForKey("INDEX") as! String;
            let data = jsonObj.objectForKey("DATA");
//            if (NSJSONSerialization.isValidJSONObject(json)) {
                let id = data?.objectForKey("ID");
                let value = data?.objectForKey("VALUE1")
                if let _ = value {
                    
                    let ids = id!.componentsSeparatedByString(",");
                    let values = value!.componentsSeparatedByString(",");
                    for(var i = 0 ; i < ids.count ; i++){
                        let x = Utils.getDateStringByMils(Double(ids[i])!, formatStr: "dd/MM");
                        dataPoints.append(x);
                        self.values.append(Double(values[i])!);
                    }
            }
        }
        setChart(dataPoints,values: values);
        return [:]
    }
    
    
    func setChart(dataPoints:[String],values:[Double]){
        //print(dataPoints);
        lineChartView.gridBackgroundColor = UIColor.whiteColor();
        lineChartView.drawGridBackgroundEnabled = false;
        lineChartView.drawBordersEnabled = false;
        lineChartView.borderLineWidth = 0;
        
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        let chartDataSet = LineChartDataSet(yVals: dataEntries, label: lableText)
        let chartData = LineChartData(xVals: dataPoints, dataSet: chartDataSet)
        chartDataSet.colors=[UIColor(red: 57/255, green: 115/255, blue: 191/255, alpha: 1)]
        chartDataSet.circleColors = [UIColor.clearColor()]
        chartDataSet.circleHoleColor = UIColor(red: 57/255, green: 115/255, blue: 191/255, alpha: 1)
//        ChartDataSet.
        chartDataSet.drawCirclesEnabled = true
        chartDataSet.drawCircleHoleEnabled = true
        lineChartView.data = chartData
        
        lineChartView.frame.size.height = self.frame.size.height*0.95
        lineChartView.frame.size.width = self.frame.size.width*0.9
        lineChartView.descriptionText = ""
        lineChartView.xAxis.labelPosition = .Bottom
        lineChartView.borderColor = UIColor(red: 57/255, green: 115/255, blue: 191/255, alpha: 1)
        lineChartView.gridBackgroundColor = UIColor.whiteColor()
        lineChartView.doubleTapToZoomEnabled = false
        lineChartView.setScaleEnabled(false)
        lineChartView.rightAxis.drawLabelsEnabled = false
        lineChartView.xAxis.gridLineWidth = 0

        lineChartView.getAxis(chartDataSet.axisDependency).gridLineWidth = 0
//        lineChartView.xAxis.drawLabelsEnabled = false
        lineChartView.highlightPerTapEnabled = false
        lineChartView.highlightPerDragEnabled = false
        lineChartView.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        lineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .Linear)
        self.addSubview(lineChartView);
    }
}

