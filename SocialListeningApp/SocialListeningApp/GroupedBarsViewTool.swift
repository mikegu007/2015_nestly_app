//
//  GroupedBarsExample.swift
//  Examples
//  分组柱状图
//  Created by ischuetz on 19/05/15.
//  Copyright (c) 2015 ivanschuetz. All rights reserved.
//

import UIKit
import SwiftCharts

class GroupedBarsViewTool: UIView,ChartViewInterface {
    
    private var chart: Chart?
    
    private let dirSelectorHeight: CGFloat = 50
    
    let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont)

    var groupColors:[UIColor] = []
    
    private var linesMarkShow = false;

    var linesMark:[String] = [];
    
    
    private let paddingTop = 10;
    private let paddingLeft = 50;
    private let textWidth = 70;
    private let viewHeight = 15;
    
    private var labelNotice = ChartMarkView();
    var labelText = "Acheivement";
    
    
    private var maxV:Double = 0;
    private var minV:Double = 0;
    private var step:Double = 20;
    
    
    var groupsData: [(title: String, [KeyToValue])] = [
        ("A", [
            KeyToValue(val:0, vall:40),
            KeyToValue(val:0, vall:50),
            KeyToValue(val:0, vall:35)
            ]),
        ("B", [
            KeyToValue(val:0, vall:20),
            KeyToValue(val:0, vall:30),
            KeyToValue(val:0, vall:25)
            ]),
        ("C", [
            KeyToValue(val:0, vall:30),
            KeyToValue(val:10, vall:50),
            KeyToValue(val:0, vall:5)
            ]),
        ("D", [
            KeyToValue(val:10, vall:50),
            KeyToValue(val:0, vall:30),
            KeyToValue(val:0, vall:25)
            ])
    ]
    
    func setData(json:AnyObject,a:Int) -> NSDictionary{
        maxV = 0;
        minV = 0;
        groupsData.removeAll();
        linesMark.removeAll();
        
        if (NSJSONSerialization.isValidJSONObject(json)) {
//            print(json);
            
            let campaignId = json.objectForKey("error_code");
            if let _ = campaignId{
                let result = json.objectForKey("result");
                if result is NSNull {
                }else{
                    let mediaRanking = result?.objectForKey("mediaRanking");
                    if mediaRanking is NSNull{
                    }else{
                    if groupColors.isEmpty {
                        linesMark.append("IMP");
                        linesMark.append("UV");
                        
                        for (var i = 0 ; i < 2; i++) {
                            
                            let red = Double(arc4random_uniform(256))
                            let green = Double(arc4random_uniform(256))
                            let blue = Double(arc4random_uniform(256))
                            
                            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 0.9)
                            groupColors.append(color);
                            
                        }
                    }
                    
                    for (var i = 0; i < mediaRanking?.count; i++){
                        let temp = mediaRanking![i];
                        var midea = temp.objectForKey("media") as! String;
                        midea = Utils.mySubStringFromIndex(midea, from: 8)
                        var imp = Double(String(temp.objectForKey("impression")));
                        var uv = Double(String(temp.objectForKey("uv")));
                        
                        imp = 10;
                        uv = 20;
                        
                        var vals:[KeyToValue] = [];
                        
                        
                        if imp > maxV {
                            maxV = imp!;
                            if uv > maxV {
                                maxV = uv!;
                            }
                        }
                        
                        let impValue = KeyToValue()
                        let uvValue = KeyToValue()
                        
                        impValue.valuel = imp!;
                        uvValue.valuel = uv!;
                        
                        
                        vals.append(impValue);
                        vals.append(uvValue);
                        
                        
                        let item = (title: midea, vals);
                        groupsData.append(item);
                    }
                    
                    if !groupsData.isEmpty {
                        doJsMaxV(groupsData.count);
                    }
                    
                    
                    showChart(horizontal: true);
                        return [:];
                    }
                }
            
                
                

            }else{
                let index = json.objectForKey("INDEX") as! String;
                let data = json.objectForKey("DATA");
                // 有几节柱子
                let indexs = index.componentsSeparatedByString(",");
                let IDS = data?.objectForKey("ID");
                if let _ = IDS?.count {
                    showChart(horizontal: false);
                    return [:];
                }
                var ids = (data?.objectForKey("ID") as! String).componentsSeparatedByString(",");
                
                /*
                if (ids.count != indexs.count){
                    //ids.re
                    showChart(horizontal: false);
//                    return
                }*/
                
                if groupColors.isEmpty {
                    for (var i = 0 ; i < indexs.count; i++) {
                        linesMark.append(indexs[i]);
//                        let red = Double(arc4random_uniform(256))
//                        let green = Double(arc4random_uniform(256))
//                        let blue = Double(arc4random_uniform(256))
//                        let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 0.9)
//                        groupColors.append(color);
                    }
                    let color1 = UIColor(red: 57/255, green: 203/255, blue: 120/255, alpha: 1)
                    let color2 = UIColor(red: 255/255, green: 96/255, blue: 67/255, alpha: 1)
                    let color3 = UIColor(red: 255/255, green: 153/255, blue: 50/255, alpha: 1)
                    let color4 = UIColor(red: 103/255, green: 201/255, blue: 250/255, alpha: 1)
                    let color4_1 = UIColor(red: 230/255, green: 80/255, blue: 123/255, alpha: 1)
                    let color4_2 = UIColor(red: 102/255, green: 204/255, blue: 204/255, alpha: 1)
                    let color5 = UIColor(red: 218/255, green: 218/255, blue: 218/255, alpha: 1)
                    groupColors.append(color1)
                    groupColors.append(color2)
                    groupColors.append(color3)
                    groupColors.append(color4)
                    groupColors.append(color4_1)
                    groupColors.append(color4_2)
                    groupColors.append(color5)
                }
                
                
                for (var j = 0 ; j < ids.count; j++) {
                    var vals:[KeyToValue] = [];
                    for (var i = 0 ; i < indexs.count; i++) {
                        let values = (data?.objectForKey("VALUE\(i+1)") as! String).componentsSeparatedByString(",");
//                                            print(j)
//                                            print(values)
                        let val = Double(values[j])!;
                        let keyv = KeyToValue();
                        
                        if val > maxV {
                            maxV = val;
                        }
//                        linesMark.append(indexs[i]);
                        keyv.value = 0;
                        keyv.valuel = val;
                        vals.append(keyv);
                    }
                    ids[j] = Utils.mySubStringFromIndex(ids[j], from: 8)

                    let item = (title: ids[j], vals);
                    groupsData.append(item);
                    
                }
                
                if !ids.isEmpty {
                    doJsMaxV(ids.count);
                }
            }
   
            
        }
        
        showChart(horizontal: false);
        return [:]
    }
    
    
    private func doJsMaxV(count:Int){
        if count > 0 {

            step = Double(Int(maxV) / count);
            step = Double(maxV / 10);//*Double(beichu);

            step = ceil(step);
            if step == 0 {
                step = 1;
            }
            maxV = maxV + step;
            maxV = ceil(maxV);
        }

    }
    
    
    private func barsChart(horizontal horizontal: Bool) -> Chart {

        
        let groups: [ChartPointsBarGroup] = groupsData.enumerate().map {index, entry in
            let constant = ChartAxisValueDouble(index)
            let bars = entry.1.enumerate().map {index, tuple in
                ChartBarModel(constant: constant, axisValue1: ChartAxisValueDouble(tuple.value), axisValue2: ChartAxisValueDouble(tuple.valuel), bgColor: groupColors[index])
            }
            return ChartPointsBarGroup(constant: constant, bars: bars)
        }
        
        let (axisValues1, axisValues2): ([ChartAxisValue], [ChartAxisValue]) = (
            0.stride(through: maxV, by: step).map {ChartAxisValueDouble(Double($0), labelSettings: labelSettings)},
            [ChartAxisValueString(order: -1)] +
                groupsData.enumerate().map {index, tuple in ChartAxisValueString(tuple.0, order: index, labelSettings: labelSettings)} +
                [ChartAxisValueString(order: groupsData.count)]
        )
        let (xValues, yValues) = horizontal ? (axisValues1, axisValues2) : (axisValues2, axisValues1)
        
        let xModel = ChartAxisModel(axisValues: xValues);
        let yModel = ChartAxisModel(axisValues: yValues);
        //ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "Axis title", settings: labelSettings.defaultVertical()))
        
        let position = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
        let chartFrame = position;//ExamplesDefaults.chartFrame(self.frame)
        //let frame = ExamplesDefaults.chartFrame(self.view.bounds)
        //let chartFrame = self.chart?.frame ?? CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height - self.dirSelectorHeight)
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: ExamplesDefaults.chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxis, yAxis, innerFrame) = (coordsSpace.xAxis, coordsSpace.yAxis, coordsSpace.chartInnerFrame)
        
        let groupsLayer = ChartGroupedPlainBarsLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, groups: groups, horizontal: horizontal, barSpacing: 2, groupSpacing: 25, animDuration: 0.5)
        
        let settings = ChartGuideLinesLayerSettings(linesColor: UIColor.blackColor(), linesWidth: ExamplesDefaults.guidelinesWidth)
        let guidelinesLayer = ChartGuideLinesLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, axis: horizontal ? .X : .Y, settings: settings)
        
        return Chart(
            frame: chartFrame,
            layers: [
                xAxis,
                yAxis,
                guidelinesLayer,
                groupsLayer
            ]
        )
    }


    func doTest() {
        self.chart?.clearView()
        self.backgroundColor = UIColor.whiteColor();
        let chart = self.barsChart(horizontal: true)
        self.addSubview(chart.view)
        self.chart = chart
        if let chart = self.chart {
            let dirSelector = DirSelector(frame: CGRectMake(0, chart.frame.origin.y + chart.frame.size.height, self.frame.size.width, self.dirSelectorHeight), controller: self)
            self.addSubview(dirSelector)
        }
    }
    
    
    func showChart(horizontal horizontal: Bool) {
        self.chart?.clearView()
        self.backgroundColor = UIColor.whiteColor();
        
        let chart = self.barsChart(horizontal: horizontal)
        self.addSubview(chart.view)
        self.chart = chart
//        if let chart = self.chart {
//            let dirSelector = DirSelector(frame: CGRectMake(0, chart.frame.origin.y + chart.frame.size.height, self.frame.size.width, self.dirSelectorHeight), controller: self)
//            self.addSubview(dirSelector)
//        }
        doAddLabel();

//        if self.linesMarkShow == false {
//            linesMarkShow = true;
//            doAddLabel();
//            
//        }
    }

    
    class DirSelector: UIView {
        
        let horizontal: UIButton
        let vertical: UIButton
        
        weak var controller: GroupedBarsViewTool?
        
        private let buttonDirs: [UIButton : Bool]
        
        init(frame: CGRect, controller: GroupedBarsViewTool) {
            
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

//        if !groupColors.isEmpty {
            var i = 0;
            for mark in linesMark {
                let markNotice = ChartMarkView();
                markNotice.lineMark(groupColors[i], label: mark);
                markNotice.frame = CGRect(x: (paddingLeft  + 80*i), y: paddingTop, width: textWidth, height: viewHeight)
                self.addSubview(markNotice)
                i++;
            }
        
//        }
       
        
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
//        labelNotice.noticeMark(UIColor.blackColor(), label: labelText);
//        self.addSubview(labelNotice)
        
        
    }
}
