//
//  BarsPlusMinusAndLinesExample.swift
//  SwiftCharts
//  正负同级的柱状图
//  Created by ischuetz on 04/05/15.
//  Copyright (c) 2015 ivanschuetz. All rights reserved.
//

import UIKit
import SwiftCharts

class BarsChartViewTool: UIView,ChartViewInterface {
    
    private var chart: Chart? // arc
    
    // 正数柱状图颜色
    var posColor = UIColor.greenColor().colorWithAlphaComponent(0.5)
    // 负数住转图颜色
    var negColor = UIColor.redColor().colorWithAlphaComponent(0.5)
    
    var barsData: [KeyToValue] = [
        KeyToValue(key:"A", val:40,vall:-20),
        KeyToValue(key:"B", val:10,vall:-10),
        KeyToValue(key:"C", val:20,vall:-30),
        KeyToValue(key:"D", val:70,vall:-20),
        KeyToValue(key:"E", val:20,vall:-50),
        KeyToValue(key:"F", val:60,vall:-20),
        KeyToValue(key:"AG", val:90,vall:-60),
        KeyToValue(key:"AH", val:10,vall:-5)
    ]
    
    private var labelNotice = ChartMarkView();
    private var barNotice = ChartMarkView();
    private var bar2Notice = ChartMarkView();
   
    var labelText = "AAAAA";

    var barMark = "AAAAA";
    var bar2Mark = "BBBBB";
    
    private let paddingTop = 10;
    private let paddingLeft = 50;
    private let textWidth = 70;
    private let viewHeight = 15;
    
    
    private var maxV:Double = 0;
    private var minV:Double = 0;
    private var step:Double = 20;
    
    
    func setData(json:AnyObject,a:Int) -> NSDictionary{
        return [:]
    }

    private func doSplitNum(data:[KeyToValue]){
        for item in data {
            if minV > item.valuel {
                minV = item.valuel;
            }
            
            if maxV < item.value {
                maxV = item.value;
            }
        }
        
    }
    
    private func doJsMaxV(count:Int){
        step = Double((maxV) / Double(count));
        step = ceil(step);

        maxV = maxV + step;
        minV = minV - step;
        maxV = ceil(maxV);
        minV = floor(minV);

    }
    
    func doShowCharts(barData:[KeyToValue]){
        self.barsData = barData;
        doShowChart();
        
    }

    
    func doTest(){
        doShowChart();
    }
    
    func doShowChart() {
        
        doSplitNum(barsData);
        doJsMaxV(barsData.count);
        
        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont)
        
        self.backgroundColor = UIColor.whiteColor();
        
        
 
        // 正负数分割线
        let zero = ChartAxisValueDouble(0)
        // 设置两套柱状图（默认删除负的）
        let bars: [ChartBarModel] = barsData.enumerate().flatMap {index, tuple in
            [
                ChartBarModel(constant: ChartAxisValueDouble(index), axisValue1: zero, axisValue2: ChartAxisValueDouble(tuple.valuel), bgColor: self.negColor),
                
                ChartBarModel(constant: ChartAxisValueDouble(index), axisValue1: zero, axisValue2: ChartAxisValueDouble(tuple.value), bgColor: self.posColor)
            ]
        }
        
        
        //Y轴值得递增规律
        let yValues = (minV).stride(through: maxV, by: step).map {ChartAxisValueDouble(Double($0), labelSettings: labelSettings)}
        //X轴的标签
        let xValues =
        [ChartAxisValueString(order: -1)] +
            barsData.enumerate().map {index, tuple in ChartAxisValueString(tuple.key, order: index, labelSettings: labelSettings)} +
            [ChartAxisValueString(order: barsData.count)]
        
        
        let xModel = ChartAxisModel(axisValues: xValues)
        let yModel = ChartAxisModel(axisValues: yValues)
        
        let position = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);

        let chartFrame = position;//ExamplesDefaults.chartFrame(self.frame)
        //
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: ExamplesDefaults.chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxis, yAxis, innerFrame) = (coordsSpace.xAxis, coordsSpace.yAxis, coordsSpace.chartInnerFrame)
        
        let barsLayer = ChartBarsLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, bars: bars, horizontal: false, barWidth: Env.iPad ? 40 : 25, animDuration: 0.5)
        
        // labels layer
        // create chartpoints for the top and bottom of the bars, where we will show the labels
        let labelChartPoints = bars.map {bar in
            ChartPoint(x: bar.constant, y: bar.axisValue2)
        }
        let formatter = NSNumberFormatter()
        formatter.maximumFractionDigits = 2
        // 展示设置
        let labelsLayer = ChartPointsViewsLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: labelChartPoints, viewGenerator: {(chartPointModel, layer, chart) -> UIView? in
            let label = HandlingLabel()
            let posOffset: CGFloat = 10
            
            let pos = chartPointModel.chartPoint.y.scalar > 0
            
            let yOffset = pos ? -posOffset : posOffset
            //柱状图数值显示格式
            label.text = "\(formatter.stringFromNumber(chartPointModel.chartPoint.y.scalar)!)%"
            label.font = ExamplesDefaults.labelFont
            label.sizeToFit()
            label.center = CGPointMake(chartPointModel.screenLoc.x, pos ? innerFrame.origin.y : innerFrame.origin.y + innerFrame.size.height)
            label.alpha = 0
            
            label.movedToSuperViewHandler = {[weak label] in
                UIView.animateWithDuration(0.3, animations: {
                    label?.alpha = 1
                    label?.center.y = chartPointModel.screenLoc.y + yOffset
                })
            }
            return label
            
            }, displayDelay: 0.5) // show after bars animation
        
        
        
        // show a gap between positive and negative bar
        let dummyZeroYChartPoint = ChartPoint(x: ChartAxisValueDouble(0), y: ChartAxisValueDouble(0))
        let yZeroGapLayer = ChartPointsViewsLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: [dummyZeroYChartPoint], viewGenerator: {(chartPointModel, layer, chart) -> UIView? in
            let height: CGFloat = 2
            let v = UIView(frame: CGRectMake(innerFrame.origin.x + 2, chartPointModel.screenLoc.y - height / 2, innerFrame.origin.x + innerFrame.size.width, height))
            v.backgroundColor = UIColor.whiteColor()
            return v
        })
        //print("chartFrame:\(chartFrame)");
        
        let chart = Chart(
            frame: chartFrame,
            layers: [
                xAxis,
                yAxis,
                barsLayer,
                labelsLayer,
                yZeroGapLayer
            ]
        )
        //                yZeroGapLayer,
        
        
        self.addSubview(chart.view)
        self.chart = chart
        
        doAddLabel();
    }
    

    
    func doAddLabel(){
        
        barNotice.barMark(posColor, label: barMark)
        bar2Notice.barMark(negColor, label: bar2Mark)
        
        barNotice.frame = CGRect(x: paddingLeft, y: paddingTop, width: textWidth, height: viewHeight)
        
        self.addSubview(barNotice)
        
        bar2Notice.frame = CGRect(x: (paddingLeft + Int(barNotice.size.width)), y: paddingTop, width: textWidth, height: viewHeight)
        self.addSubview(bar2Notice)
        
        
        
        labelNotice.labelMark(UIColor.brownColor(), label: labelText);
        //print(self.frame.height);
        labelNotice.frame = CGRect(x: 50, y: self.frame.height - 12, width: 100, height: 20)
        self.addSubview(labelNotice)
        
        
    }
    
}
