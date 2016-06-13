//
//  AreasChartViewTool
//  SwiftCharts
//  堆积图

//  Created by ischuetz on 04/05/15.
//  Copyright (c) 2015 ivanschuetz. All rights reserved.
//

import UIKit
import SwiftCharts

class AreasChartViewTool: UIView,ChartViewInterface {
    
    private var chart: Chart? // arc
    
    var areaColor1 = UIColor(red: 0.1, green: 0.1, blue: 0.9, alpha: 0.4)
    var areaColor2 = UIColor(red: 0.9, green: 0.1, blue: 0.1, alpha: 0.4)
    var areaColor3 = UIColor(red: 0.1, green: 0.9, blue: 0.1, alpha: 0.4)
    
    var groupColors:[UIColor] = []
    
    
    private var linesMarkShow = false;

    var linesMark:[String] = [];
    var linesMarkView:[ChartMarkView] = [];

    
    
    private var labelNotice = ChartMarkView();
    private var area1Notice = ChartMarkView();
    private var area2Notice = ChartMarkView();
    private var area3Notice = ChartMarkView();
    
    var labelText = "AAAAA";
    var area1Mark = "New Fans";
    var area2Mark = "BBBBB";
    var area3Mark = "cccc";
    
    private let paddingTop = 10;
    private let paddingLeft = 60;
    private let textWidth = 70;
    private let viewHeight = 15;
    
    
    private var barsData: [KeyToValue] = [
        KeyToValue(key:"A", val:10,vall: 1),
        KeyToValue(key:"B", val:50,vall: 1),
        KeyToValue(key:"C", val:35,vall: 1),
        KeyToValue(key:"A", val:20,vall: 2),
        KeyToValue(key:"B", val:30,vall: 2),
        KeyToValue(key:"C", val:47,vall: 2),
        KeyToValue(key:"A", val:60,vall: 3),
        KeyToValue(key:"B", val:48,vall: 3),
        KeyToValue(key:"C", val:48,vall: 3),
        KeyToValue(key:"D", val:48,vall: 4)

    ]
    
    
    var chartPoints:[ChartPoint] = [];
    
    
    var linePoint:Dictionary<Double,[KeyToValue]> = Dictionary<Double,[KeyToValue]>();
    var keyIndex:Dictionary<String,Int> = Dictionary<String,Int>();

    func doSplitArray(){
        
        linePoint.removeAll();
        keyIndex.removeAll();
        var index = 0;
        
        for item in barsData {
            if linePoint.keys.contains(item.valuel) {
                var ary = linePoint[item.valuel];
                ary?.append(item);
                linePoint.updateValue(ary!, forKey: item.valuel)
            }else{
                var ary:[KeyToValue] = [];
                ary.append(item)
                linePoint[item.valuel] = ary;
            }
            
            if !keyIndex.keys.contains(item.key) {
                keyIndex[item.key] = index;
                index++;
            }
        }
    }
    
    private var beichu = 1;
    
    let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont)

    private var linesCount = 0;
    
    func setData(json:AnyObject,a:Int) -> NSDictionary{
        maxV = 0;
        minV = 0;
        //linePoint.removeAll();
        //keyIndex.removeAll();
        linesMark.removeAll();
        chartPoints.removeAll();
        barsData.removeAll();
        groupColors.removeAll();
        //self.remove
        self.chart?.clearView()

        if (NSJSONSerialization.isValidJSONObject(json)) {
            //print("json:\(json)");
            
            let INDEX = json.objectForKey("INDEX");
            
            var index = "";
            if let _ = INDEX?.count{
                viewDidLoad();
                return [:];
            }
            
            index = INDEX as! String;
            
            let data = json.objectForKey("DATA");
            let ids = (data?.objectForKey("ID") as! String).componentsSeparatedByString(",");
            
            // 有几节柱子
            var indexs = index.componentsSeparatedByString(",");
            
            linesCount = indexs.count;
            
            if groupColors.isEmpty {
                for (var i = 0 ; i < indexs.count; i++) {
//                    print(indexs[i])
                    if (indexs[i] == "Share to Friends"){
                        indexs[i] = "To Friends"
                    }
                    if (indexs[i] == "Top-right Menu in Articles and Account Name"){
                        indexs[i] = "Articles"
                    }
                    if (indexs[i] == "Search Account"){
                        indexs[i] = "Search"
                    }
                    if (indexs[i] == "Name Card Sharing"){
                        indexs[i] = "NameCard"
                    }

                    linesMark.append(indexs[i]);
//                    let red = Double(arc4random_uniform(256))
//                    let green = Double(arc4random_uniform(256))
//                    let blue = Double(arc4random_uniform(256))
//                    let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 0.9)
//                    groupColors.append(color);
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
            
            
            if ids.count >= 14 {
                beichu = 3;
            }
            if ids.count >= 20 {
                beichu = 4;
            }
            
            for (var j = 0 ; j < ids.count; j++) {
                
                var x = "";

                if j % beichu == 0 {
                    x = Utils.getDateStringByMils(Double(ids[j])!, formatStr: "MM/dd");
                }
                for (var i = 0 ; i < indexs.count; i++) {
                //for (var i = indexs.count - 1  ; i >= 0; i--) {
                    let values = (data?.objectForKey("VALUE\(i+1)") as! String).componentsSeparatedByString(",");
                    var val = Double(values[j])!;
                    let keyv = KeyToValue();

                    if val > maxV {
                        maxV = val;
                    }
                    
                    for(var k = i + 1 ; k < indexs.count; k++){
                    //for(var k = indexs.count - 1 ; k > i; k--){

                        let values = (data?.objectForKey("VALUE\(k)") as! String).componentsSeparatedByString(",");
                        val += Double(values[j])!;
                        
                    }
                    
                    keyv.key = x;
                    keyv.value = val;
                    keyv.valuel = Double(i + 1);
                    barsData.append(keyv);
                    
                    let point = ChartPoint(x: ChartAxisValueString(x,order:j,labelSettings: labelSettings), y: ChartAxisValueDouble(val));
                    
                    chartPoints.append(point);
                }
 
            }
            
            if !ids.isEmpty {
                doJsMaxV(ids.count);
            }
        
        }
        
        viewDidLoad();
        return [:]
    }
    
    private var maxV:Double = 0;
    private var minV:Double = 0;
    private var step:Double = 20;
    
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

            if count < 10 {
                step = Double(maxV / Double(count))*Double(beichu);
            }else{
                step = Double(maxV / 10);//*Double(beichu);
            }
            
            step = Double(maxV / 10);//*Double(beichu);

            //print("setp:\(step)");
            step = ceil(step);
            if (step == 0){
                step = 1;
            }

            maxV = maxV + step;
            maxV = ceil(maxV);

        }
    }
    
    
    func doShowCharts(datas:[KeyToValue]){
        self.barsData = datas;
        viewDidLoad();
    }
    
    func doTest(){
        viewDidLoad();
    }
    
    func viewDidLoad() {
        self.backgroundColor = UIColor.whiteColor();

        
        doSplitNum(barsData);
        doJsMaxV(barsData.count);
        
        
        doSplitArray();
        
        
        /*
        
        
        let ps1 = linePoint[1];
        let ps2 = linePoint[2];
        let ps3 = linePoint[3];

       // let chartPoints1 = ps1.map{ChartPoint(x: ChartAxisValueString($[0].key,order: 1, labelSettings: labelSettings), y: ChartAxisValueDouble($0.value))}
        
        var chartPoints1:[ChartPoint] = [];
        var chartPoints2:[ChartPoint] = [];
        var chartPoints3:[ChartPoint] = [];

        var index = 0;
        for p in ps1! {
            index = keyIndex[p.key]!;
            let point = ChartPoint(x: ChartAxisValueString(p.key,order:index,labelSettings: labelSettings), y: ChartAxisValueDouble(p.value));
            chartPoints1.append(point)
            index++;
        }
        
        //index = 0;
        for p in ps2! {
            index = keyIndex[p.key]!;

            let point = ChartPoint(x: ChartAxisValueString(p.key,order:index,labelSettings: labelSettings), y: ChartAxisValueDouble(p.value));
            chartPoints2.append(point)
            index++;
        }
        
        //index = 0;
        for p in ps3! {
            index = keyIndex[p.key]!;

            let point = ChartPoint(x: ChartAxisValueString(p.key,order:index,labelSettings: labelSettings), y: ChartAxisValueDouble(p.value));
            chartPoints3.append(point)
            index++;
        }
        
        */
        
        //let allChartPoints = (chartPoints1 + chartPoints2 + chartPoints3).sort {(obj1, obj2) in return obj1.x.scalar < obj2.x.scalar}
        
        
        let allChartPoints = chartPoints.sort {(obj1, obj2) in return obj1.x.scalar < obj2.x.scalar}
        //xprint(allChartPoints);
        let xValues: [ChartAxisValue] = (NSOrderedSet(array: allChartPoints).array as! [ChartPoint]).map{$0.x}
        let yValues = ChartAxisValuesGenerator.generateYAxisValuesWithChartPoints(allChartPoints, minSegmentCount: 5, maxSegmentCount: 30, multiple: step, axisValueGenerator: {ChartAxisValueDouble($0, labelSettings: self.labelSettings)}, addPaddingSegmentIfEdge: false)
        
        let xModel = ChartAxisModel(axisValues: xValues);//, axisTitleLabel: ChartAxisLabel(text: "Axis title", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues);//, axisTitleLabel: ChartAxisLabel(text: "Axis title", settings: labelSettings.defaultVertical()))
        
        let position = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
        let chartFrame = position;//ExamplesDefaults.chartFrame(self.frame)
        
        //let chartFrame = ExamplesDefaults.chartFrame(self.frame)
        
        let chartSettings = ExamplesDefaults.chartSettings
        chartSettings.trailing = 20
        chartSettings.labelsToAxisSpacingX = 20
        chartSettings.labelsToAxisSpacingY = 20
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxis, yAxis, innerFrame) = (coordsSpace.xAxis, coordsSpace.yAxis, coordsSpace.chartInnerFrame)
        
        
        var linemodels = [ChartLineModel]();
        var cpLayers = [ChartLayer]();
        
        for (var i = 1 ; i <= linesCount; i++){
        //for (var i = linesCount ; i >= 1; i--){
            let cp = linePoint[Double(i)];
            var chartPoints1:[ChartPoint] = [];

            var index = 0;
            for p in cp! {
                //var index = keyIndex[p.key]!;
                let point = ChartPoint(x: ChartAxisValueString(p.key,order:index,labelSettings: labelSettings), y: ChartAxisValueDouble(p.value));
                chartPoints1.append(point);
                index++;
            }
            
            let chartPointsLayer1 = ChartPointsAreaLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: chartPoints1, areaColor: groupColors[i-1], animDuration: 3, animDelay: 0, addContainerPoints: true);
            
            let lineModel1 = ChartLineModel(chartPoints: chartPoints1, lineColor: groupColors[i-1], animDuration: 1, animDelay: 0);
            
            linemodels.append(lineModel1);
            cpLayers.append(chartPointsLayer1);
            
        }
        
        /*
        
        let chartPointsLayer1 = ChartPointsAreaLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: chartPoints1, areaColor: areaColor1, animDuration: 3, animDelay: 0, addContainerPoints: true)
        let chartPointsLayer2 = ChartPointsAreaLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: chartPoints2, areaColor: areaColor2, animDuration: 3, animDelay: 0, addContainerPoints: true)
        let chartPointsLayer3 = ChartPointsAreaLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: chartPoints3, areaColor: areaColor3, animDuration: 3, animDelay: 0, addContainerPoints: true)

        
        let lineModel1 = ChartLineModel(chartPoints: chartPoints1, lineColor: UIColor.blackColor(), animDuration: 1, animDelay: 0)
        let lineModel2 = ChartLineModel(chartPoints: chartPoints2, lineColor: UIColor.blackColor(), animDuration: 1, animDelay: 0)
        let lineModel3 = ChartLineModel(chartPoints: chartPoints3, lineColor: UIColor.blackColor(), animDuration: 1, animDelay: 0)
        */
        let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, lineModels: linemodels)
        
        /*
        var popups: [UIView] = []
        var selectedView: ChartPointTextCircleView?
        
        let circleViewGenerator = {(chartPointModel: ChartPointLayerModel, layer: ChartPointsLayer, chart: Chart) -> UIView? in
            
            let (chartPoint, screenLoc) = (chartPointModel.chartPoint, chartPointModel.screenLoc)
            
            let v = ChartPointTextCircleView(chartPoint: chartPoint, center: screenLoc, diameter: Env.iPad ? 50 : 30, cornerRadius: Env.iPad ? 24: 15, borderWidth: Env.iPad ? 2 : 1, font: ExamplesDefaults.fontWithSize(Env.iPad ? 14 : 8))
            v.viewTapped = {view in
                for p in popups {p.removeFromSuperview()}
                selectedView?.selected = false
                
                let w: CGFloat = Env.iPad ? 250 : 150
                let h: CGFloat = Env.iPad ? 100 : 80
                
                let x: CGFloat = {
                    let attempt = screenLoc.x - (w/2)
                    let leftBound: CGFloat = chart.bounds.origin.x
                    let rightBound = chart.bounds.size.width - 5
                    if attempt < leftBound {
                        return view.frame.origin.x
                    } else if attempt + w > rightBound {
                        return rightBound - w
                    }
                    return attempt
                }()
                
                let frame = CGRectMake(x, screenLoc.y - (h + (Env.iPad ? 30 : 12)), w, h)
                
                let bubbleView = InfoBubble(frame: frame, arrowWidth: Env.iPad ? 40 : 28, arrowHeight: Env.iPad ? 20 : 14, bgColor: UIColor.blackColor(), arrowX: screenLoc.x - x)
                chart.addSubview(bubbleView)
                
                bubbleView.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(0, 0), CGAffineTransformMakeTranslation(0, 100))
                let infoView = UILabel(frame: CGRectMake(0, 10, w, h - 30))
                infoView.textColor = UIColor.whiteColor()
                infoView.backgroundColor = UIColor.blackColor()
                infoView.text = "Some text about \(chartPoint)"
                infoView.font = ExamplesDefaults.fontWithSize(Env.iPad ? 14 : 12)
                infoView.textAlignment = NSTextAlignment.Center
                
                bubbleView.addSubview(infoView)
                popups.append(bubbleView)
                
                UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions(), animations: {
                    view.selected = true
                    selectedView = view
                    
                    bubbleView.transform = CGAffineTransformIdentity
                    }, completion: {finished in})
            }
            
            return v
        }
        
        
        let itemsDelay: Float = 0.08
        let chartPointsCircleLayer1 = ChartPointsViewsLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: chartPoints1, viewGenerator: circleViewGenerator, displayDelay: 0.9, delayBetweenItems: itemsDelay)
        
        let chartPointsCircleLayer2 = ChartPointsViewsLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: chartPoints2, viewGenerator: circleViewGenerator, displayDelay: 1.8, delayBetweenItems: itemsDelay)
        
        let chartPointsCircleLayer3 = ChartPointsViewsLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: chartPoints3, viewGenerator: circleViewGenerator, displayDelay: 2.7, delayBetweenItems: itemsDelay)
        */
        
        let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.blackColor(), linesWidth: ExamplesDefaults.guidelinesWidth)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, settings: settings)
        
        cpLayers.append(chartPointsLineLayer);
        
        let chart = Chart(
            frame: chartFrame,
            layers: [
                xAxis,
                yAxis
                
            ]
        )
        /*
        guidelinesLayer,

        ,
        chartPointsCircleLayer1,
        chartPointsCircleLayer2,
        chartPointsCircleLayer3
        chartPointsLineLayer
        */
        
        
        chart.addLayers(cpLayers);

        
        self.addSubview(chart.view)
        self.chart = chart
        
        
        
        doAddLabel();

    }
    
    
    func doAddLabel(){
        
        
        for vi in linesMarkView{
            vi.removeFromSuperview();
        }
        
        if !groupColors.isEmpty {
            var i = 0;
            for mark in linesMark {
                let markNotice = ChartMarkView();
                markNotice.lineMark(groupColors[i], label: mark);
                if i >= 3{
                    markNotice.frame = CGRect(x: (paddingLeft + 80*(i-3)), y: paddingTop + 20, width: textWidth, height: viewHeight)
                }else{
                    markNotice.frame = CGRect(x: (paddingLeft + 80*i), y: paddingTop, width: textWidth, height: viewHeight)
                }
                //markNotice.frame = CGRect(x: (paddingLeft + 80*i), y: paddingTop, width: textWidth, height: viewHeight)
                self.addSubview(markNotice)
                linesMarkView.append(markNotice);
                i++;
            }

        }
        
        if !linesMarkShow {
            labelNotice.frame = CGRect(x: 10, y: self.frame.height - 12, width: 200, height: 20)
            labelNotice.noticeMark(UIColor.blueColor(), label: labelText);
//            self.addSubview(labelNotice)
            linesMarkShow = true;
            //linesMarkView.append(labelNotice);
        }
        

    }

    
}
