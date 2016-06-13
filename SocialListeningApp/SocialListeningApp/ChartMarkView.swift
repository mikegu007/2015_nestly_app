//
//  ChartMarkView.swift
//  SocialListeningApp
//
//  Created by chencharles on 16/2/25.
//  Copyright © 2016年 cicdata. All rights reserved.
//

import Foundation
import UIKit
import SwiftCharts

class ChartMarkView :UIView{
    
    func barMark(viewColor:UIColor,var label:String){
        let barView = UIView();
        let labelView = UILabel();
        
        barView.frame = CGRect(x: 0, y: (self.frame.height - 10 )/2, width: 20, height: 10);
        barView.backgroundColor = viewColor;
        self.addSubview(barView)
        
        if label.characters.count > 10 {
            label = (label as NSString).substringToIndex(10);
            label = label + "..";
        }
        labelView.text = label;
        labelView.textColor = UIColor.darkGrayColor();
        labelView.font = UIFont(name: "Helvetica", size: 9)
        
        let size = ChartUtils.textSize(label, font: labelView.font)

        labelView.frame = CGRect(x: 22, y: (self.frame.height - size.height )/2, width: size.width, height: size.height);
        
        self.addSubview(labelView);
        
        
    }
    
    
    func lineMark(viewColor:UIColor,var label:String){
        let barView = UIView();
        let labelView = UILabel();
        
        barView.frame = CGRect(x: 0, y: (self.frame.height - 2 )/2, width: 20, height: 2);
        barView.backgroundColor = viewColor;
        self.addSubview(barView)
        
        if label.characters.count > 12 {
            label = (label as NSString).substringToIndex(11);
            label = label + "..";
        }
        
        labelView.text = label;
        labelView.textColor = UIColor.darkGrayColor();
        labelView.font = UIFont(name: "Helvetica", size: 9)
        
        let size = ChartUtils.textSize(label, font: labelView.font)
        
        labelView.frame = CGRect(x: 22, y: (self.frame.height - size.height )/2, width: size.width, height: size.height);
        
        self.addSubview(labelView);
    }
    
    func labelMark(viewColor:UIColor,var label:String){
        let barView = UIView();
        let labelView = UILabel();
        
        barView.frame = CGRect(x: 0, y: (self.frame.height - 8 )/2, width: 8, height: 8);
        barView.backgroundColor = viewColor;
        self.addSubview(barView)
        
        if label.characters.count > 10 {
            label = (label as NSString).substringToIndex(8);
            label = label + "..";
        }
        labelView.text = label;
        labelView.textColor = UIColor.darkGrayColor();
        labelView.font = UIFont(name: "Helvetica", size: 10)
        
        let size = ChartUtils.textSize(label, font: labelView.font)
        
        labelView.frame = CGRect(x: 22, y: (self.frame.height - size.height )/2, width: size.width, height: size.height);
        
        self.addSubview(labelView);
        
        
    }
    
    func noticeMark(viewColor:UIColor,label:String){
        let barView = UIView();
        let labelView = UILabel();
        
        let clr = UIColor(red: 57/255, green: 115/255, blue: 191/255, alpha: 1);
        barView.frame = CGRect(x: 0, y: (self.frame.height - 24 )/2, width: 10, height: 10);
        barView.backgroundColor = clr;
        self.addSubview(barView)
        
        /*if label.characters.count > 20 {
            label = (label as NSString).substringToIndex(8);
            label = label + "..";
        }*/
        labelView.text = label;
        labelView.textColor = UIColor.darkGrayColor();
        labelView.font = UIFont(name: "Helvetica", size: 10)
        
        let size = ChartUtils.textSize(label, font: labelView.font)
        
        labelView.frame = CGRect(x: 14, y: (self.frame.height - 24 )/2, width: self.frame.width, height: size.height);
        
        self.addSubview(labelView);
        
        
    }
    
}