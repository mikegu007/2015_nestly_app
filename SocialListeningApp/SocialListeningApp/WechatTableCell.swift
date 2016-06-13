//
//  WechatTableCell.swift
//  SocialListeningApp
//
//  Created by chencharles on 16/2/19.
//  Copyright © 2016年 cicdata. All rights reserved.
//

//
//  AccountTableCell.swift
//  SocialListeningApp
//
//  Created by chencharles on 16/2/18.
//  Copyright © 2016年 cicdata. All rights reserved.
//


import Foundation
import UIKit
import Alamofire



class WechatTableCell: UITableViewCell {
    @IBOutlet weak var accountImg: UIImageView!
    
    @IBOutlet weak var newFans: UILabel!
    @IBOutlet weak var unfollowed: UILabel!
    @IBOutlet weak var totfans: UILabel!
    @IBOutlet weak var reads: UILabel!
    @IBOutlet weak var reposts: UILabel!
    
    
    // 横屏时候的名称和地址
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    
    // 竖屏时候的名称和地址
    @IBOutlet weak var name2: UILabel!
    @IBOutlet weak var address2: UILabel!
    
    var day_ago:Int = 7
    var change_day:Int = 0
    
    var model: AccountBean? {
        didSet {
            if let _ = name{
                name.text = model!.name
                
            }
            if let _ = address {
                address.text = "since  \(model!.address)"
                
            }
            if let _ = name2 {
                name2.text = model?.name;
                
            }
            
            if let _ = address2 {
                address2.text = "Data since  \(model!.address)"
            }
            if let _ = accountImg {
                accountImg.layer.cornerRadius = theme.ImageCornerRadius;
                accountImg.layer.masksToBounds = true;
                accountImg.wxn_setImageWithURL(NSURL(string: model!.imageurl)!, placeholderImage: UIImage(named: "wechat")!);
                
                
            }
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "changedDay:", name: "changeDay", object: nil)

//            self.loadWechat(7,wechatUserId: (model?.id)!);

        }
    }
    
    func changedDay(long_ago:NSNotification){
        change_day = long_ago.object as! Int
        // print(change_day)
        switch change_day {
        case 0 :
            day_ago = 1
        case 1 :
            day_ago = 7
        case 2 :
            day_ago = 14
        case 3 :
            day_ago = 30
        default :
            break
        }
        // print(day_ago)
        
        self.loadWechat(day_ago,wechatUserId: (model?.id)!);
    }
    
    
    func loadWechat(dayId:Int,wechatUserId:Int){
        //数据链接，解析
        let url = rootURL + "wechatAccount/findWechatPercentage.cic";
        let parameters = [
            "dayId": dayId,
            "wechatUserId":wechatUserId,
        ]
        Alamofire.request(.GET, url,parameters: parameters).responseJSON{
            data in
            if(data.result.isSuccess){
                let json = data.result.value!;
                if (!NSJSONSerialization.isValidJSONObject(json)) {
                }else{
                    let jsonObj = Utils.stringToJson(json);
                    //print(jsonObj)
                    for(var i = 0 ; i < jsonObj.count; i++){
                        let temp = jsonObj[i]
                        let id = temp.objectForKey("id") as! String;
                        let val = temp.objectForKey("value1") as! String;
                        if id == "NEW_USER"{
                            self.newFans.text = val;
                        }else if id == "CANCEL_USER" {
                            self.unfollowed.text = val;
                        }else if id == "CUMULATE_USER"{
                            self.totfans.text = val;
                        }else if id == "INT_PAGEREAD_COUNT"{
                            self.reads.text = val;
                        }else if id == "SHARE_COUNT"{
                            self.reposts.text = val;
                        }
                        
                    }
                }
            }
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
}