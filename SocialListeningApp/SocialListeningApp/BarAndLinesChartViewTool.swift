//
//  BarAndLinesChartViewTool
//  SwiftCharts
//  柱状图和线条结合的图表显示，最多支持两条线
//  Created by ischuetz on 04/05/15.
//  Copyright (c) 2015 ivanschuetz. All rights reserved.
//

import UIKit
import SwiftCharts

class BarAndLinesChartViewTool: UIView,ChartViewInterface {
    
    private var chart: Chart? // arc
    private let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont)
    
    // 正数柱状图颜色
    var posColor = UIColor.blueColor();//.colorWithAlphaComponent(0.8)
    
    var colors: [UIColor] = []

    private var labelNotice = ChartMarkView();
    
    var labelText = "";
    // 是否显示柱状图
    var barsEmpty = false;

    var barMark:[String] = []
    
    private var linesMarkShow = false;
    var linesMark:[String] = []
    
    
    private let paddingTop = 10;
    private let paddingLeft = 50;
    private let textWidth = 70;
    private let viewHeight = 15;

    private var barsData: [KeyToValue] = [
        KeyToValue(key:"A", val:40),
        KeyToValue(key:"B", val:50),
        KeyToValue(key:"C", val:35),
        KeyToValue(key:"D", val:40),
        KeyToValue(key:"E", val:30),
        KeyToValue(key:"F", val:47),
        KeyToValue(key:"G", val:60),
        KeyToValue(key:"H", val:48)
    ]
    
    
    private var lineData: [KeyToValue] = [
        KeyToValue(key:"A", val:10),
        KeyToValue(key:"B", val:20),
        KeyToValue(key:"C", val:20),
        KeyToValue(key:"D", val:10),
        KeyToValue(key:"E", val:20),
        KeyToValue(key:"F", val:23),
        KeyToValue(key:"G", val:10),
        KeyToValue(key:"H", val:45)
    ]
    
    private var lineData2: [KeyToValue] = [
        KeyToValue(key:"A", val:10),
        KeyToValue(key:"B", val:40),
        KeyToValue(key:"C", val:20),
        KeyToValue(key:"D", val:20),
        KeyToValue(key:"E", val:20),
        KeyToValue(key:"F", val:33),
        KeyToValue(key:"G", val:0),
        KeyToValue(key:"H", val:55)
    ]
    
    private var lineDatas:[[KeyToValue]] = [];

    

    
    private var maxV:Double = 0;
    private var minV:Double = 0;
    private var step:Double = 20;
    
    
    private var beichu = 1;

  
    func setData(json:AnyObject,a:Int) -> NSDictionary{
        
        maxV = 0;
        minV = 0;
        
        barsData.removeAll();
        lineDatas.removeAll();
        lineData.removeAll();
        lineData2.removeAll();
        linesMark.removeAll();
        barMark.removeAll()
        
        //colors.removeAll();

        
        if (NSJSONSerialization.isValidJSONObject(json)) {
//            print(json)
            let jsonObj = Utils.stringToJson(json);
            if a == 1 {
                labelText = "UV";
                barMark.append("成交金额")
                linesMark.append("UV");
//                print(jsonObj);
                // 只有两条线
                let result = json.objectForKey("result");
                if result is NSNull {
                }else{
                    if result == nil{
                    }else{
//                    print(result)
                let vos = result!.objectForKey("vos");
                    if vos is NSNull {
                    }else{
                        if vos?.count >= 10 {
                            beichu = 2;
                        }
                        if vos?.count >= 20 {
                            beichu = 4;
                        }
                for(var i = 0 ; i < vos?.count; i++){
                    let line = KeyToValue();
                    let value = KeyToValue();
                    var vos_date = vos![i].objectForKey("date") as! String
                    vos_date = Utils.kSubStringFromIndex(vos_date,from: 5)
                    if i % self.beichu == 0 {
                        value.key = vos_date
                        line.key = vos_date
//                        print(line.key)
                    }
                    line.value = Double(vos![i].objectForKey("paymoney") as! String)! / Double(beichu)
                    value.value = Double(vos![i].objectForKey("uv") as! String)! / Double(beichu)
                    lineData.append(line);
                    barsData.append(value);
                    }
                        }
                    }
                }
                lineDatas.append(lineData)
            }else if a == 3{
//                print(jsonObj)
                labelText = jsonObj.objectForKey("INDEX") as! String;
                let data = jsonObj.objectForKey("DATA");
                let id = data?.objectForKey("ID");
                let value1 = data?.objectForKey("VALUE1")
                if let _ = value1 {
                    let ids = id!.componentsSeparatedByString(",");
                    let values = value1!.componentsSeparatedByString(",");
                    if ids.count >= 10 {
                        beichu = 2;
                    }
                    if ids.count >= 20 {
                        beichu = 4;
                    }
                    for(var i = 0 ; i < ids.count ; i++){
                        let line = KeyToValue();
                        let x = Utils.getDateStringByMils(Double(ids[i])!, formatStr: "dd/MM");
                        if i % self.beichu == 0 {
                            line.key = x ;
                        }
                        line.value = Double(values[i])! / Double(beichu)
                        lineData.append(line);
                    }
                }
                lineDatas.append(lineData)
                
            }else if a == 2{
                labelText = "BUYERS & SALES";
                barMark.append("sales")
                linesMark.append("Buyers");
//                                print(jsonObj);
                // 只有两条线
                let result = json.objectForKey("result");
                if result is NSNull {
                }else{
                    if let _ = result {
                    let date = result!.objectForKey("date");
                        if date is NSNull {}else{
                    let buyers_salse = result!.objectForKey("buyers_sales");
                    let buyers_salse2 = result!.objectForKey("buyers_sales")
                    print(buyers_salse2)
                    if buyers_salse is NSNull || buyers_salse2?.count == 0 {
                            }else{
//                            if let _ = buyers_salse![0]{
                    
                    let sales = buyers_salse![0].objectForKey("sales")
                    let buyer = buyers_salse![0].objectForKey("buyer")
                    
                    if date?.count >= 10 {
                        beichu = 2;
                    }
                    if date?.count >= 20 {
                        beichu = 4;
                    }
                    for(var i = 0 ; i < date?.count; i++){
                        let line = KeyToValue();
                        let value = KeyToValue();
                        var line_date = date![i] as! String;
                        line_date = Utils.kSubStringFromIndex(line_date,from: 5)
                        if i % self.beichu == 0 {
                            value.key = line_date
                            line.key = line_date
                        }
                        line.value = sales![i] as! Double
                        value.value = buyer![i] as! Double
                        lineData.append(line);
                        barsData.append(value);
                    }
                        }}}
                }
                lineDatas.append(lineData)            
            }else{
            
            let indexText = jsonObj.objectForKey("INDEX");
            let type = jsonObj.objectForKey("TYPE");
            if let _ = type {
                //print(json);
                let data = jsonObj.objectForKey("DATA");
                labelText = "Tweet Time Effectiveness Analysis";
                if data?.count >= 1 {
                    barMark.append("Tweet")
                    linesMark.append("Retweeted");
                }
                if data?.count >= 10 {
                    beichu = 2;
                }
                if data?.count >= 20 {
                    beichu = 4;
                }
                for(var i = 0 ; i < data?.count; i++){
                    let temp = data![i];
                    let value = KeyToValue();
                    if i % 6 == 0 {
                        value.key = temp.objectForKey("TIME") as! String;
                    }else{
                        value.key = "";
                    }
                    value.value = Double(temp.objectForKey("VALUE1") as! String)!;
                    barsData.append(value);
                    let line = KeyToValue();
                    line.key = value.key;
                    if let _ = temp.objectForKey("VALUE2"){
                        let value2 = Double(temp.objectForKey("VALUE2") as! String)!;
                        line.value = value2;
                    }
                    lineData.append(line)
                }
                if !lineData.isEmpty {
                    lineDatas.append(lineData);
                }
            }else{
                if let _ = indexText {
                    labelText = "Account Engagement Analysis";
                    let data = jsonObj.objectForKey("DATA");
                    barMark.append("New Fans")
                    linesMark.append("Reads");
                    linesMark.append("Shares");
                    if (NSJSONSerialization.isValidJSONObject(data!)) {
                        let id = data?.objectForKey("ID") as! String;
                        let ids = id.componentsSeparatedByString(",");
                        if ids.count <= 1 {
                        }else{
                            let value1 = data?.objectForKey("VALUE1") as! String;// 新增粉丝  柱状图
                            let value2 = data?.objectForKey("VALUE2") as! String;// 阅读数 线1
                            let value3 = data?.objectForKey("VALUE3") as! String;// 分享数 线2
                            let values = value1.componentsSeparatedByString(",");
                            let values2 = value2.componentsSeparatedByString(",");
                            let values3 = value3.componentsSeparatedByString(",");
                            if ids.count >= 10 {
                                beichu = 2;
                            }
                            if ids.count >= 20 {
                                beichu = 4;
                            }
                            for(var i = 0 ; i < ids.count ; i++){
                                let x = Utils.getDateStringByMils(Double(ids[i])!, formatStr: "dd/MM");
                                let value = KeyToValue();
                                let line = KeyToValue();
                                let line2 = KeyToValue();
                                if i % self.beichu == 0 {
                                    value.key = x;
                                }
                                value.value = Double(values[i])!;
                                barsData.append(value);
                                line.key = x;
                                let value2 = Double(values2[i])!;
                                let beichu:Double = 1;
                                line.value = value2 / beichu;
                                //line.value = Double(values2[i])!;
                                lineData.append(line);
                                line2.key = x;
                                let values33 = Double(values3[i])!;
                                line2.value = values33 / beichu;
                                lineData2.append(line2);
                            }
                            lineDatas.append(lineData)
                            lineDatas.append(lineData2)
                        }
                    }
                }else{
                    labelText = "TREND";
                    linesMark.append("Average");
                    linesMark.append("Rams");
                    //print(jsonObj);
                    // 只有两条线
                    let time = jsonObj.objectForKey("time");
                    let avgnum = jsonObj.objectForKey("avg_num");
                    let defnum = jsonObj.objectForKey("def_num");
                    beichu = 2;
                    for(var i = 0 ; i < time?.count; i++){
                        let line = KeyToValue();
                        let line2 = KeyToValue();
                        if i % 2 == 0{
                            line.key = time![i].objectForKey("value1") as! String;
                        }
                        line.value = Double(avgnum![i].objectForKey("value1") as! String)!;
                        lineData.append(line);
                        line2.key = line.key;
                        line2.value = Double(defnum![i].objectForKey("value1") as! String)!;
                        lineData2.append(line2);
                    }
                    lineDatas.append(lineData)
                    lineDatas.append(lineData2)
                    }
                }
            }
        }
        doShowCharts(barsData,lineDatas: lineDatas);
        return [:]
    }

    
    
    private func doSplitNum(data:[KeyToValue]){
        
        for item in data {
            /*if minV > item.value {
                minV = item.value;
            }*/
            if maxV < item.value {
                maxV = item.value;
            }
        }

    }
    
    private func doJsMaxV(count:Int){
        if count > 0 {
            step = Double(maxV / Double(count))*Double(beichu);
            
            step = Double(maxV / 10);//*Double(beichu);

            step = ceil(step);
            
            if step == 0 {
                step = 1;
            }
            maxV = maxV + step;
            
            maxV = ceil(maxV);
        }
    }
    
    
    func doShowCharts(barData:[KeyToValue],lineDatas:[[KeyToValue]]){
        self.barsData = barData;
        self.lineDatas = lineDatas;
        self.backgroundColor = UIColor.whiteColor();
        self.chart?.view.removeFromSuperview();

        doShowChartsAndLines();
        
    }
    
    func doTest(){
        lineDatas.removeAll();
        //barsData.removeAll();

        self.lineDatas.append(lineData)
        self.lineDatas.append(lineData2)
        self.backgroundColor = UIColor.whiteColor();
        
        self.chart?.view.removeFromSuperview();
        
        /*if lineDatas.count == 1 {
            doShowChartsOneLine();
        }else{
            doShowChartsTwoLines();
        }*/
        
        doShowChartsAndLines();

    }
    
    
    func doShowChartsAndLines(){
      
        if !barsData.isEmpty {
            doSplitNum(barsData);
        }
        
        for data in lineDatas{
            doSplitNum(data);
        }
        
        if barsData.isEmpty {
            barsEmpty = true;
            if !lineDatas.isEmpty {
                barsData = lineDatas[0];

            }
        }
        
        doJsMaxV(barsData.count);
        
        
        
        // 正负数分割线
        let zero = ChartAxisValueDouble(0)
        // 设置两套柱状图（默认删除负的）
        let bars: [ChartBarModel] = barsData.enumerate().flatMap {index, tuple in
            [
                
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
        //ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues)
        //        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "", settings: labelSettings.defaultVertical()))
        
        let position = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        let chartFrame = position;//ExamplesDefaults.chartFrame(self.frame)
        
        //
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: ExamplesDefaults.chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxis, yAxis, innerFrame) = (coordsSpace.xAxis, coordsSpace.yAxis, coordsSpace.chartInnerFrame)
        
        var barWidth:CGFloat = 25;
        if barsData.count > 10 {
            barWidth = 10;
        }
        if barsData.count > 20 {
            barWidth = 5;
        }
        
        let barsLayer = ChartBarsLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, bars: bars, horizontal: false, barWidth: Env.iPad ? 40 : barWidth, animDuration: 0.5)
        
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
            label.text = "\(formatter.stringFromNumber(chartPointModel.chartPoint.y.scalar)!)"
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
        
        

        var lines:[ChartLayer] = [ChartLayer]();

        if !barsEmpty{
            lines.append(barsLayer);
            //lines.append(labelsLayer);
        }
        
        if colors.isEmpty {
//            for _ in 0..<lineDatas.count {
//                let red = Double(arc4random_uniform(256))
//                let green = Double(arc4random_uniform(256))
//                let blue = Double(arc4random_uniform(256))
//                let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 0.9)
//                colors.append(color)
//            }
            let color1 = UIColor(red: 57/255, green: 203/255, blue: 120/255, alpha: 1)
            let color2 = UIColor(red: 255/255, green: 96/255, blue: 67/255, alpha: 1)
            let color3 = UIColor(red: 255/255, green: 153/255, blue: 50/255, alpha: 1)
            let color4 = UIColor(red: 103/255, green: 201/255, blue: 250/255, alpha: 1)
            let color4_1 = UIColor(red: 230/255, green: 80/255, blue: 123/255, alpha: 1)
            let color4_2 = UIColor(red: 102/255, green: 204/255, blue: 204/255, alpha: 1)
            let color5 = UIColor(red: 218/255, green: 218/255, blue: 218/255, alpha: 1)
            colors.append(color1)
            colors.append(color2)
            colors.append(color3)
            colors.append(color4)
            colors.append(color4_1)
            colors.append(color4_2)
            colors.append(color5)
        }
        // print("colors count:\(colors.count)");
        
        var index = 0;
        //print(lineDatas.count);
        for lineData in lineDatas{
            //print("index:\(index)");
            let color = colors[index]
            // line layer
            let lineChartPoints = lineData.enumerate().map {index, tuple in ChartPoint(x: ChartAxisValueDouble(index), y: ChartAxisValueDouble(tuple.value))}
            let lineModel = ChartLineModel(chartPoints: lineChartPoints, lineColor: color, lineWidth: 2, animDuration: 0.5, animDelay: 1)
            let lineLayer = ChartPointsLineLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, lineModels: [lineModel])
            
            let circleViewGenerator = {(chartPointModel: ChartPointLayerModel, layer: ChartPointsLayer, chart: Chart) -> UIView? in
                let circleView = ChartPointEllipseView(center: chartPointModel.screenLoc, diameter: 6)
                circleView.animDuration = 0.5
                
                circleView.fillColor = color;//self.line1Color

                return circleView
            }
            let lineCirclesLayer = ChartPointsViewsLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: lineChartPoints, viewGenerator: circleViewGenerator, displayDelay: 1.5, delayBetweenItems: 0.05)
            

            lines.append(lineLayer)
            lines.append(lineCirclesLayer);
            index++;

        }
        
        
        // show a gap between positive and negative bar
        let dummyZeroYChartPoint = ChartPoint(x: ChartAxisValueDouble(0), y: ChartAxisValueDouble(0))
        let yZeroGapLayer = ChartPointsViewsLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: [dummyZeroYChartPoint], viewGenerator: {(chartPointModel, layer, chart) -> UIView? in
            let height: CGFloat = 2
            let v = UIView(frame: CGRectMake(innerFrame.origin.x + 2, chartPointModel.screenLoc.y - height / 2, innerFrame.origin.x + innerFrame.size.height, height))
            v.backgroundColor = UIColor.whiteColor()
            return v
        })
        
        let chart = Chart(
            frame: chartFrame,
            layers: [
                xAxis,
                yAxis
            ]
        )
        chart.addLayers(lines)
        self.addSubview(chart.view)
        self.chart = chart
//        if self.linesMarkShow == false {
//            linesMarkShow = true;
            doAddLabel();
//        }
        
    }
    
    
    
    func doAddLabel(){
        var barNotice = ChartMarkView();
        if barsEmpty == false{
            barNotice.barMark(posColor, label: barMark[0]);
            barNotice.frame = CGRect(x: paddingLeft, y: paddingTop, width: textWidth, height: viewHeight)
            self.addSubview(barNotice)
            barNotice.reloadInputViews()
        }
            var i = 0;
            for mark in linesMark {
                let markNotice = ChartMarkView();
                markNotice.lineMark(colors[i], label: mark);
                markNotice.frame = CGRect(x: (paddingLeft + Int(barNotice.size.width) + 80*i), y: paddingTop, width: textWidth, height: viewHeight)
                self.addSubview(markNotice)
                i++;
            }
//        }
        
        
//        labelNotice.frame = CGRect(x: 10, y: self.frame.height - 12, width: 200, height: 20)
//        labelNotice.noticeMark(UIColor.blueColor(), label: labelText);
//        //print(self.frame.height);
//        self.addSubview(labelNotice)
        

    }
    
    
    
}
