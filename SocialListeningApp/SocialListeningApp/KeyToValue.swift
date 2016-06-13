//
//  KeyToValue.swift
//  SocialListeningApp
//
//  Created by chencharles on 16/2/23.
//  Copyright © 2016年 cicdata. All rights reserved.
//

import Foundation
class KeyToValue {
    var id = 0;
    var key = "";
    var value:Double = 0;
    var valuel:Double = 0;

    init(){
        
    }
    
    init(key:String,val:Double){
        self.key = key;
        self.value = val;
    }
    
    init(id:Int,key:String,val:Double){
        self.key = key;
        self.value = val;
        self.id = id;
    }
    
    init(id:Int,key:String,val:Double,vall:Double){
        self.key = key;
        self.value = val;
        self.id = id;
        self.valuel = vall;
    }
    
    init(key:String,val:Double,vall:Double){
        self.key = key;
        self.value = val;
        self.valuel = vall;
    }
    
    init(val:Double,vall:Double){
        self.value = val;
        self.valuel = vall;
    }
    
}