//
//  CampaignBean.swift
//  SocialListeningApp
//
//  Created by ciccic on 16/4/11.
//  Copyright © 2016年 cicdata. All rights reserved.
//

import Foundation

class CampaignBean {
    var id = 0;
    var customid = 0;
    var name = "";
    var isExpanded = false;
    var imp = 0;
    var click = 0;
    var uv = 0;
    var tauv = 0;
    var ctr = "";
    var cpm = 0.0;
    var cpc = 0.0;
    var cpuv = 0.0;
    var e_com = "";
    var delivery = "";
    
    var cpmNorm = 0.0
    var cpcNorm = 0.0
    var cpuvNorm = 0.0
    var ctrNorm = 0.0

    var time1 = ""
    var time2 = ""
    var platform = ""
    
    var startDate = ""
    var endDate = ""

    var baseinfo : AnyObject?

}