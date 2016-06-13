//
//  BarsDemo.swift
//  SocialListeningApp
//
//  Created by chencharles on 16/2/24.
//  Copyright © 2016年 cicdata. All rights reserved.
//

import Foundation
import UIKit

class BarsDemo: NormalViewController {
    
    private var chart: BarsChartViewTool = BarsChartViewTool();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chart.frame = self.view.frame;
        chart.doTest();
        
        self.view.addSubview(chart)
        
    }
}