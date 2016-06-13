//
//  StackedBarsExample.swift
//  Examples
//  一个柱状图多种颜色／数据
//  Created by ischuetz on 15/05/15.
//  Copyright (c) 2015 ivanschuetz. All rights reserved.
//

import UIKit
import SwiftCharts

class StackedBarsViewTool: UIView,ChartViewInterface {
    
    private var chart: Chart? // arc
    
    let sideSelectorHeight: CGFloat = 50
    
    var colors: [UIColor] = [];

    private var linesMarkShow = false;

    var linesMark:[String] = [];

    
    private var labelNotice = ChartMarkView();
    var labelText = "Fans Gender";
    
    
    
    var barModes:[ChartStackedBarModel] = [];
    
    private var maxV:Double = 0;
    private var minV:Double = 0;
    private var step:Double = 20;
    
    
    private let paddingTop = 10;
    private let paddingLeft = 50;
    private let textWidth = 70;
    private let viewHeight = 15;
    
    private var beichu = 1;
    
    func setData(json:AnyObject,a:Int) -> NSDictionary{
        maxV = 0;
        minV = 0;
        //colors.removeAll();
        barModes.removeAll();
        
        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFontSmall)
        let zero = ChartAxisValueDouble(0)

        if (NSJSONSerialization.isValidJSONObject(json)) {
            
            let INDEX = json.objectForKey("INDEX");
            
            if let _ = INDEX?.count{
                showChart(horizontal: false);
                return [:];
            }
            
            let index = INDEX as! String;
            let data = json.objectForKey("DATA");

            // 有几节柱子
            let indexs = index.componentsSeparatedByString(",");
            let ids = (data?.objectForKey("ID") as! String).componentsSeparatedByString(",");
            
            if ids.count >= 14 {
                beichu = 2;
            }
            if ids.count >= 20 {
                beichu = 4;
            }
            
            //print("beichu:\(beichu)");
            
            
            if colors.isEmpty {
                for (var i = 0 ; i < indexs.count; i++) {
                    linesMark.append(indexs[i]);
//                    let red = Double(arc4random_uniform(256))
//                    let green = Double(arc4random_uniform(256))
//                    let blue = Double(arc4random_uniform(256))
//                    let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 0.9)
//                    colors.append(color);
                }
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
            
            
            
            

            for (var j = 0 ; j < ids.count; j++) {
                
                // 定义X轴
                var x = "";//Utils.getDateStringByMils(Int(ids[j])!, formatStr: "dd/MM");
                if j % beichu == 0 {
                    x = Utils.getDateStringByMils(Double(ids[j])!, formatStr: "dd/MM");
                }
                var items:[ChartStackedBarItemModel] = [];
                
                var tempY:Double = 0;
                for (var i = indexs.count - 1 ; i >= 0; i--) {
                    let values = (data?.objectForKey("VALUE\(i+1)") as! String).componentsSeparatedByString(",");
                    let val = Double(values[j])!;
                    tempY += val;
                    
                                        
                    let item = ChartStackedBarItemModel(quantity: val, bgColor: colors[i]);
                    items.append(item);
                }
                
                if tempY > maxV {
                    maxV = tempY;
                }
                
                
                let model = ChartStackedBarModel(constant: ChartAxisValueString(x,order: (j+1),labelSettings: labelSettings), start: zero, items: items);
                
                barModes.append(model);
                
                
            }
            
            if !ids.isEmpty {
                doJsMaxV(ids.count);
            }

        }
        
        
        showChart(horizontal: false);
        return [:]
    }
    
    private func doJsMaxV(count:Int){
        //print("maxV:\(maxV),count:\(count)");
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
    
    
    private func showCharts(horizontal horizontal: Bool) -> Chart {
        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont);
        
        
        //let zero = ChartAxisValueDouble(0)

        /*
        let color0 = UIColor.grayColor().colorWithAlphaComponent(0.6)
        let color1 = UIColor.blueColor().colorWithAlphaComponent(0.6)
        let color2 = UIColor.redColor().colorWithAlphaComponent(0.6)
        let color3 = UIColor.greenColor().colorWithAlphaComponent(0.6)
        
        let barModels = [
            ChartStackedBarModel(constant: ChartAxisValueString("A", order: 1, labelSettings: labelSettings), start: zero, items: [
                ChartStackedBarItemModel(quantity: 20, bgColor: color0),
                ChartStackedBarItemModel(quantity: 60, bgColor: color1),
                ChartStackedBarItemModel(quantity: 30, bgColor: color2),
                ChartStackedBarItemModel(quantity: 20, bgColor: color3)
                ]),
            ChartStackedBarModel(constant: ChartAxisValueString("B", order: 2, labelSettings: labelSettings), start: zero, items: [
                ChartStackedBarItemModel(quantity: 40, bgColor: color0),
                ChartStackedBarItemModel(quantity: 30, bgColor: color1),
                ChartStackedBarItemModel(quantity: 10, bgColor: color2),
                ChartStackedBarItemModel(quantity: 30, bgColor: color3)
                ]),
            ChartStackedBarModel(constant: ChartAxisValueString("C", order: 3, labelSettings: labelSettings), start: zero, items: [
                ChartStackedBarItemModel(quantity: 30, bgColor: color0),
                ChartStackedBarItemModel(quantity: 50, bgColor: color1),
                ChartStackedBarItemModel(quantity: 20, bgColor: color2),
                ChartStackedBarItemModel(quantity: 10, bgColor: color3)
                ]),
            ChartStackedBarModel(constant: ChartAxisValueString("D", order: 4, labelSettings: labelSettings), start: zero, items: [
                ChartStackedBarItemModel(quantity: 10, bgColor: color0),
                ChartStackedBarItemModel(quantity: 30, bgColor: color1),
                ChartStackedBarItemModel(quantity: 50, bgColor: color2),
                ChartStackedBarItemModel(quantity: 5, bgColor: color3)
                ])
        ]
        
        */
        
        let (axisValues1, axisValues2) = (
            0.stride(through: maxV, by: step).map {ChartAxisValueDouble(Double($0), labelSettings: labelSettings)},
            [ChartAxisValueString("", order: 0, labelSettings: labelSettings)] + barModes.map{$0.constant} + [ChartAxisValueString("", order: barModes.count + 1, labelSettings: labelSettings)]
        )
        let (xValues, yValues) = horizontal ? (axisValues1, axisValues2) : (axisValues2, axisValues1)
        
        let xModel = ChartAxisModel(axisValues: xValues);//, axisTitleLabel: ChartAxisLabel(text: "Axis title", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues);//, axisTitleLabel: ChartAxisLabel(text: "Axis title", settings: labelSettings.defaultVertical()))
        
        let position = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
        let chartFrame = position;//ExamplesDefaults.chartFrame(self.frame)
        //
        
        //let frame = ExamplesDefaults.chartFrame(self.view.bounds)
        //let chartFrame = self.chart?.frame ?? CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height - sideSelectorHeight)
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: ExamplesDefaults.chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxis, yAxis, innerFrame) = (coordsSpace.xAxis, coordsSpace.yAxis, coordsSpace.chartInnerFrame)
        
        var barWidth:CGFloat = 20;
        if barModes.count > 10 {
            barWidth = 10;
        }
        if barModes.count > 20 {
            barWidth = 5;
        }
            
        
        
        let chartStackedBarsLayer = ChartStackedBarsLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, barModels: barModes, horizontal: horizontal, barWidth: barWidth, animDuration: 0.5)
        
        let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.blackColor(), linesWidth: ExamplesDefaults.guidelinesWidth)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, settings: settings)
        
        return Chart(
            frame: chartFrame,
            layers: [
                xAxis,
                yAxis,
                guidelinesLayer,
                chartStackedBarsLayer
            ]
        )
    }
    
    
    
    private func chart(horizontal horizontal: Bool) -> Chart {
        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont)
        
        let color0 = UIColor.grayColor().colorWithAlphaComponent(0.6)
        let color1 = UIColor.blueColor().colorWithAlphaComponent(0.6)
        let color2 = UIColor.redColor().colorWithAlphaComponent(0.6)
        let color3 = UIColor.greenColor().colorWithAlphaComponent(0.6)
        
        let zero = ChartAxisValueDouble(0)
        let barModels = [
            ChartStackedBarModel(constant: ChartAxisValueString("A", order: 1, labelSettings: labelSettings), start: zero, items: [
                ChartStackedBarItemModel(quantity: 20, bgColor: color0),
                ChartStackedBarItemModel(quantity: 60, bgColor: color1),
                ChartStackedBarItemModel(quantity: 30, bgColor: color2),
                ChartStackedBarItemModel(quantity: 20, bgColor: color3)
                ]),
            ChartStackedBarModel(constant: ChartAxisValueString("B", order: 2, labelSettings: labelSettings), start: zero, items: [
                ChartStackedBarItemModel(quantity: 40, bgColor: color0),
                ChartStackedBarItemModel(quantity: 30, bgColor: color1),
                ChartStackedBarItemModel(quantity: 10, bgColor: color2),
                ChartStackedBarItemModel(quantity: 30, bgColor: color3)
                ]),
            ChartStackedBarModel(constant: ChartAxisValueString("C", order: 3, labelSettings: labelSettings), start: zero, items: [
                ChartStackedBarItemModel(quantity: 30, bgColor: color0),
                ChartStackedBarItemModel(quantity: 50, bgColor: color1),
                ChartStackedBarItemModel(quantity: 20, bgColor: color2),
                ChartStackedBarItemModel(quantity: 10, bgColor: color3)
                ]),
            ChartStackedBarModel(constant: ChartAxisValueString("D", order: 4, labelSettings: labelSettings), start: zero, items: [
                ChartStackedBarItemModel(quantity: 10, bgColor: color0),
                ChartStackedBarItemModel(quantity: 30, bgColor: color1),
                ChartStackedBarItemModel(quantity: 50, bgColor: color2),
                ChartStackedBarItemModel(quantity: 5, bgColor: color3)
                ]),
            ChartStackedBarModel(constant: ChartAxisValueString("E", order: 5, labelSettings: labelSettings), start: zero, items: [
                ChartStackedBarItemModel(quantity: 10, bgColor: color0),
                ChartStackedBarItemModel(quantity: 30, bgColor: color1),
                ChartStackedBarItemModel(quantity: 50, bgColor: color2),
                ChartStackedBarItemModel(quantity: 9, bgColor: color3)
                ])
        ]
        
        let (axisValues1, axisValues2) = (
            0.stride(through: 150, by: 20).map {ChartAxisValueDouble(Double($0), labelSettings: labelSettings)},
            [ChartAxisValueString("", order: 0, labelSettings: labelSettings)] + barModels.map{$0.constant} + [ChartAxisValueString("", order: barModels.count + 1, labelSettings: labelSettings)]
        )
        let (xValues, yValues) = horizontal ? (axisValues1, axisValues2) : (axisValues2, axisValues1)
        
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "Axis title", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "Axis title", settings: labelSettings.defaultVertical()))
        
        let position = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
        let chartFrame = position;//ExamplesDefaults.chartFrame(self.frame)
        //
        
        //let frame = ExamplesDefaults.chartFrame(self.view.bounds)
        //let chartFrame = self.chart?.frame ?? CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height - sideSelectorHeight)
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: ExamplesDefaults.chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxis, yAxis, innerFrame) = (coordsSpace.xAxis, coordsSpace.yAxis, coordsSpace.chartInnerFrame)
        
        let chartStackedBarsLayer = ChartStackedBarsLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, barModels: barModels, horizontal: horizontal, barWidth: 40, animDuration: 0.5)
        
        let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.blackColor(), linesWidth: ExamplesDefaults.guidelinesWidth)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, settings: settings)
        
        return Chart(
            frame: chartFrame,
            layers: [
                xAxis,
                yAxis,
                guidelinesLayer,
                chartStackedBarsLayer
            ]
        )
    }
    
    func doTest() {
        self.chart?.clearView()
        self.backgroundColor = UIColor.whiteColor();
        
        
        
        let chart = self.chart(horizontal: true)
        self.addSubview(chart.view)
        self.chart = chart
        
        if let chart = self.chart {
            let sideSelector = DirSelector(frame: CGRectMake(0, chart.frame.origin.y + chart.frame.size.height, self.frame.size.width, self.sideSelectorHeight), controller: self)
            self.addSubview(sideSelector)
        }
    }
    
    func showChart(horizontal horizontal: Bool) {
        self.chart?.clearView()
        self.backgroundColor = UIColor.whiteColor();
        
        
        
        let chart = self.showCharts(horizontal: horizontal)
        
        self.addSubview(chart.view)
        self.chart = chart
        
//        if let chart = self.chart {
//            let sideSelector = DirSelector(frame: CGRectMake(0, chart.frame.origin.y + chart.frame.size.height, self.frame.size.width, self.sideSelectorHeight), controller: self)
//            self.addSubview(sideSelector)
//        }
        
        if self.linesMarkShow == false {
            linesMarkShow = true;
            doAddLabel();
            
        }
    }
    

    
    class DirSelector: UIView {
        
        let horizontal: UIButton
        let vertical: UIButton
        
        weak var controller: StackedBarsViewTool?
        
        private let buttonDirs: [UIButton : Bool]
        
        init(frame: CGRect, controller: StackedBarsViewTool) {
            
            self.controller = controller
            
            self.horizontal = UIButton()
            self.horizontal.setTitle("Horizontal", forState: .Normal)
            self.vertical = UIButton()
            self.vertical.setTitle("Vertical", forState: .Normal)
            
            self.buttonDirs = [self.horizontal : true, self.vertical : false]
            
            super.init(frame: frame)
            
            self.addSubview(self.horizontal)
            self.addSubview(self.vertical)
            
            for button in [self.horizontal, self.vertical] {
                button.titleLabel?.font = ExamplesDefaults.fontWithSize(14)
                button.setTitleColor(UIColor.blueColor(), forState: .Normal)
                button.addTarget(self, action: "buttonTapped:", forControlEvents: .TouchUpInside)
            }
        }
        
        func buttonTapped(sender: UIButton) {
            let horizontal = sender == self.horizontal ? true : false
            controller?.showChart(horizontal: horizontal)
        }
        
        override func didMoveToSuperview() {
            let views = [self.horizontal, self.vertical]
            for v in views {
                v.translatesAutoresizingMaskIntoConstraints = false
            }
            
            let namedViews = views.enumerate().map{index, view in
                ("v\(index)", view)
            }
            
            let viewsDict = namedViews.reduce(Dictionary<String, UIView>()) {(var u, tuple) in
                u[tuple.0] = tuple.1
                return u
            }
            
            let buttonsSpace: CGFloat = Env.iPad ? 20 : 10
            
            let hConstraintStr = namedViews.reduce("H:|") {str, tuple in
                "\(str)-(\(buttonsSpace))-[\(tuple.0)]"
            }
            
            let vConstraits = namedViews.flatMap {NSLayoutConstraint.constraintsWithVisualFormat("V:|[\($0.0)]", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDict)}
            
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(hConstraintStr, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDict)
                + vConstraits)
        }
        
        required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    func doAddLabel(){
        
        
        if !colors.isEmpty {
            var i = 0;
            for mark in linesMark {
                let markNotice = ChartMarkView();
                markNotice.lineMark(colors[i], label: mark);
                markNotice.frame = CGRect(x: (paddingLeft  + 80*i), y: paddingTop, width: textWidth, height: viewHeight)
                self.addSubview(markNotice)
                
                i++;
            }

        }
        
        /*
        line1Notice.lineMark(line1Color, label: line1Mark)
        
        
        
        line1Notice.frame = CGRect(x: (paddingLeft + Int(barNotice.size.width)), y: paddingTop, width: textWidth, height: viewHeight)
        self.addSubview(line1Notice)
        
        if lineDatas.count > 1 {
        line2Notice.lineMark(line2Color, label: line2Mark)
        
        line2Notice.frame = CGRect(x: (paddingLeft + Int(barNotice.frame.width) + Int(line1Notice.frame.width)), y: paddingTop, width: textWidth, height: viewHeight)
        self.addSubview(line2Notice)
        }
        */
        
//        labelNotice.frame = CGRect(x: 10, y: self.frame.height - 12, width: 200, height: 20)
//        labelNotice.noticeMark(UIColor.blueColor(), label: labelText);
//        self.addSubview(labelNotice)
        
        
    }
}