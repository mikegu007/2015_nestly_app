//
//  BarsPlusMinusWithGradientExample.swift
//  SwiftCharts
//  正负非同级的柱状图
//  Created by ischuetz on 04/05/15.
//  Copyright (c) 2015 ivanschuetz. All rights reserved.
//

import UIKit
import SwiftCharts

class BarsWithGradientTool:UIView,ChartViewInterface {
    
    private var chart: Chart?; // arc
    /*
    KeyToValue(key:"U", val:-75),
    KeyToValue(key:"T", val:-65),
    KeyToValue(key:"S", val:-50),
    KeyToValue(key:"R", val:-45),
    
    
    ,
    KeyToValue(key:"E", val:50),
    KeyToValue(key:"D", val:60),
    KeyToValue(key:"C", val:65),
    KeyToValue(key:"B", val:70),
    KeyToValue(key:"A", val:75)
    
    */
    var vals: [KeyToValue] = [
       
        KeyToValue(key:"Q", val:-40),
        KeyToValue(key:"P", val:-30),
        KeyToValue(key:"O", val:-20),
        KeyToValue(key:"N", val:-10),
        KeyToValue(key:"M", val:-5),
        KeyToValue(key:"L", val:-0),
        KeyToValue(key:"K", val:10),
        KeyToValue(key:"J", val:15),
        KeyToValue(key:"I", val:20),
        KeyToValue(key:"H", val:30),
        KeyToValue(key:"G", val:35),
        KeyToValue(key:"F", val:40)
    ]
    
//    var posColor = UIColor.greenColor();
    var posColor = UIColor(red: 57/255, green: 203/255, blue: 120/255, alpha: 1)


    var negColor = UIColor.redColor()
//    var negColor = UIColor.grayColor().colorWithAlphaComponent(0.7);
    
    
    
    private var linesMarkShow = false;

    var linesMark:[String] = [];
    
    
    private let paddingTop = 10;
    private let paddingLeft = 50;
    private let textWidth = 70;
    private let viewHeight = 15;
    
    
    private var labelNotice = ChartMarkView();
    var labelText = "SENTIMENT";
    
    
    private var maxV:Double = 100;
    private var minV:Double = -100;
    private var step:Double = 100;
    
    private func doSplitNum(data:[KeyToValue]){
        for item in data {
            if minV > item.value {
            minV = item.value;
            }
            
            if minV < -100 {
                minV = -100;
            }
            
            if maxV < item.value {
                maxV = item.value;
            }
            
            if maxV > 100 {
                maxV = 100;
            }
        }
        
    }
    
    private func doJsMaxV(count:Int){
        if count > 0 {

            step = Double((maxV - minV) / Double(count))*4;
            
            step = Double(maxV / 10);//*Double(beichu);

            step = ceil(step);
            if step == 0 {
                step = 1;
            }
            maxV = maxV + step;
            maxV = ceil(maxV);

            minV = minV - step;
            minV = floor(minV);
            
        }

    }

    func setData(json:AnyObject,a:Int) -> NSDictionary{
        //maxV = 0;
        //minV = 0;
        vals.removeAll();
        if (NSJSONSerialization.isValidJSONObject(json)) {
            
            let jsonObj = Utils.stringToJson(json);
            
            let data = jsonObj.objectForKey("senment");
            linesMark.append("positive")
            linesMark.append("negative")
            
            if (NSJSONSerialization.isValidJSONObject(data!)) {
                //print("senment:\(data!)");
                for(var i = 0 ; i < data!.count ; i++){
                    var id_use = data![i]?.objectForKey("id") as! String;
                    let value = data![i].objectForKey("value1") as! String;
                    if id_use.characters.count > 10{
                        var id = id_use as NSString
                        id = id.substringToIndex(10)
                        id_use = id as String + ".."
                        
                    }
                    let keyv = KeyToValue();
                    keyv.key = id_use
                    keyv.value = Double(value)!;
 
                    vals.append(keyv)

                }
            }
        }
        doShowChart();
        return [:]
    }
    
    func doShowChart() {
        //let gradientPicker = GradientPicker(width: 200)

        self.backgroundColor = UIColor.whiteColor();
        
        
        self.chart?.clearView();
        //doSplitNum(vals);
        //doJsMaxV(vals.count)
        
        /*
        let (minVal, maxVal): (CGFloat, CGFloat) = vals.reduce((min: CGFloat(0), max: CGFloat(0))) {tuple, val in
            (min: min(tuple.value, val.val), max: max(tuple.max, val.val))
        }
        */
        
        //let length: Double = (maxV - minV);
        
        let zero = ChartAxisValueDouble(0)
        let bars: [ChartBarModel] = vals.enumerate().map {index, tuple in
            /*let percentage = (tuple.value - minV - 0.01) / length // FIXME without -0.01 bar with 1 (100 perc) is black
            let color = gradientPicker.colorForPercentage(CGFloat(percentage)).colorWithAlphaComponent(0.6)
            
            */
            
            var color = self.posColor;
            
            if tuple.value < 0 {
                color = self.negColor;
            }
            
            return ChartBarModel(constant: ChartAxisValueDouble(Double(index)), axisValue1: zero, axisValue2: ChartAxisValueDouble((tuple.value)), bgColor: color)
        }
        
        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont)
        let xValues = (minV).stride(through: maxV, by: step).map {ChartAxisValueDouble(Double($0), labelSettings: labelSettings)}
        let yValues =
        [ChartAxisValueString(order: -1)] +
            vals.enumerate().map {index, tuple in ChartAxisValueString(String(tuple.key), order: index, labelSettings: labelSettings)} +
            [ChartAxisValueString(order: vals.count)]
        
        //tuple.key
        let xModel = ChartAxisModel(axisValues: xValues);//, axisTitleLabel: ChartAxisLabel(text: "Axis title", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues);//, axisTitleLabel: ChartAxisLabel(text: "Axis title", settings: labelSettings.defaultVertical()))
//        let label_model = ChartAxisLabel(text: "aaa", settings: labelSettings.defaultVertical())
//        let yModel_test = ChartAxisModel(axisValues: yValues, axisTitleLabel: label_model)

        
        let position = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
        let chartFrame = position;//ExamplesDefaults.chartFrame(self.frame)
        
        //let chartFrame = ExamplesDefaults.chartFrame(self.frame)
        
        // calculate coords space in the background to keep UI smooth
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            let coordsSpace = ChartCoordsSpaceLeftTopSingleAxis(chartSettings: ExamplesDefaults.chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
            
            dispatch_async(dispatch_get_main_queue()) {
                
                let (xAxis, yAxis, innerFrame) = (coordsSpace.xAxis, coordsSpace.yAxis, coordsSpace.chartInnerFrame)
                
                let barsLayer = ChartBarsLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, bars: bars, horizontal: true, barSpacing:10, animDuration: 0.5)
                // barWidth: Env.iPad ? 40 : 16,
//                let settings = ChartGuideLinesLayerSettings(linesColor: UIColor.blackColor(), linesWidth: ExamplesDefaults.guidelinesWidth)
                let settings = ChartGuideLinesLayerSettings(linesColor: UIColor.whiteColor(), linesWidth: ExamplesDefaults.guidelinesWidth)

                let guidelinesLayer = ChartGuideLinesLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, axis: .X, settings: settings)
                
                // create x zero guideline as view to be in front of the bars
                let dummyZeroXChartPoint = ChartPoint(x: ChartAxisValueDouble(0), y: ChartAxisValueDouble(0))
                let xZeroGuidelineLayer = ChartPointsViewsLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: [dummyZeroXChartPoint], viewGenerator: {(chartPointModel, layer, chart) -> UIView? in
                    let width: CGFloat = 1
                    let v = UIView(frame: CGRectMake(chartPointModel.screenLoc.x - width / 2, innerFrame.origin.y, width, innerFrame.size.height))
//                    v.backgroundColor = UIColor(red: 1, green: 69 / 255, blue: 0, alpha: 1)
                    v.backgroundColor = UIColor(red:200/255,green:200/255,blue:200/255,alpha:1)

                    return v
                })
                
                let chart = Chart(
                    frame: chartFrame,
                    layers: [
                        xAxis,
                        yAxis,
                        guidelinesLayer,
                        barsLayer,
                        xZeroGuidelineLayer
                    ]
                )
                
                self.addSubview(chart.view)
                self.chart = chart
            }
        }
        
        if self.linesMarkShow == false {
            linesMarkShow = true;
            doAddLabel();
        }

    }

    
    func doAddLabel(){
        
        
        var i = 0;
        for mark in linesMark {
            let markNotice = ChartMarkView();
            if mark == "positive" {
                markNotice.labelMark(posColor, label: mark);
            }else{
                markNotice.labelMark(negColor, label: mark);
            }
            markNotice.frame = CGRect(x: (paddingLeft  + 80*i), y: paddingTop, width: textWidth, height: viewHeight)
            self.addSubview(markNotice)
            
            i++;
        }
        
//        labelNotice.frame = CGRect(x: 10, y: self.frame.height - 12, width: 200, height: 20)
//        labelNotice.noticeMark(UIColor.blueColor(), label: labelText);
//        self.addSubview(labelNotice)
        
    }
   
}


class GradientPicker {
    
    var gradientImg: UIImage
    
    lazy var imgData: UnsafePointer<UInt8> = {
        let provider = CGImageGetDataProvider(self.gradientImg.CGImage)
        let pixelData = CGDataProviderCopyData(provider)
        return CFDataGetBytePtr(pixelData)
    }()
    
    
    
    init(width: CGFloat) {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRectMake(0, 0, width, 1)
        gradient.colors = [UIColor.redColor().CGColor, UIColor.yellowColor().CGColor, UIColor.cyanColor().CGColor, UIColor.blueColor().CGColor]
        gradient.startPoint = CGPointMake(0, 0.5)
        gradient.endPoint = CGPointMake(1.0, 0.5)
        
        let imgHeight = 1
        let imgWidth = Int(gradient.bounds.size.width)
        
        let bitmapBytesPerRow = imgWidth * 4
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue).rawValue
        
        let context = CGBitmapContextCreate (nil,
            imgWidth,
            imgHeight,
            8,
            bitmapBytesPerRow,
            colorSpace,
            bitmapInfo)
        
        UIGraphicsBeginImageContext(gradient.bounds.size)
        gradient.renderInContext(context!)
        
        let gradientImg = UIImage(CGImage: CGBitmapContextCreateImage(context)!)
        
        UIGraphicsEndImageContext()
        self.gradientImg = gradientImg
    }
    
    func doInit(width: CGFloat){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRectMake(0, 0, width, 1)
        gradient.colors = [UIColor.redColor().CGColor, UIColor.yellowColor().CGColor, UIColor.cyanColor().CGColor, UIColor.blueColor().CGColor]
        gradient.startPoint = CGPointMake(0, 0.5)
        gradient.endPoint = CGPointMake(1.0, 0.5)
        
        let imgHeight = 1
        let imgWidth = Int(gradient.bounds.size.width)
        
        let bitmapBytesPerRow = imgWidth * 4
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue).rawValue
        
        let context = CGBitmapContextCreate (nil,
            imgWidth,
            imgHeight,
            8,
            bitmapBytesPerRow,
            colorSpace,
            bitmapInfo)
        
        UIGraphicsBeginImageContext(gradient.bounds.size)
        gradient.renderInContext(context!)
        
        let gradientImg = UIImage(CGImage: CGBitmapContextCreateImage(context)!)
        
        UIGraphicsEndImageContext()
        self.gradientImg = gradientImg
    }
    
    func colorForPercentage(percentage: CGFloat) -> UIColor {
        
        let data = self.imgData
        
        let xNotRounded = self.gradientImg.size.width * percentage
        let x = 4 * (floor(abs(xNotRounded / 4)))
        let pixelIndex = Int(x * 4)
        
        let color = UIColor(
            red: CGFloat(data[pixelIndex + 0]) / 255.0,
            green: CGFloat(data[pixelIndex + 1]) / 255.0,
            blue: CGFloat(data[pixelIndex + 2]) / 255.0,
            alpha: CGFloat(data[pixelIndex + 3]) / 255.0
        )
        return color
    }
    /*
    required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
    }*/
    
    
    
}





