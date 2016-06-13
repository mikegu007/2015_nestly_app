//
//  ChartViewInterface.swift
//  SocialListeningApp
//
//  Created by ciccic on 16/3/10.
//  Copyright © 2016年 cicdata. All rights reserved.
//

import Foundation
import UIKit

protocol ChartViewInterface {

//    var ss:String{
//        get
//        set
//    };
    
    func setData(json:AnyObject,a:Int) -> NSDictionary
}