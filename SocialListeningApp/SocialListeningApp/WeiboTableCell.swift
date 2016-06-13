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

class WeiboTableCell: UITableViewCell {
    @IBOutlet weak var accountImg: UIImageView!
    
    @IBOutlet weak var newFans: UILabel!
    @IBOutlet weak var newTweets: UILabel!
    @IBOutlet weak var newRetweets: UILabel!
    
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
            if let _ = newFans{
                newFans.text = model!.fans
                
            }
            if let _ = newTweets{
                newTweets.text = model!.tweets
                
            }
            if let _ = newRetweets{
                newRetweets.text = model!.retweets
                
            }
            if let _ = name{
                name.text = model!.name
                
            }
            if let _ = address {
                address.text = model!.address
                
            }
            if let _ = name2 {
                name2.text = model?.name;
                
            }
            
            if let _ = address2 {
                address2.text = model?.desc;
            }
            if let _ = accountImg {
                accountImg.layer.cornerRadius = theme.ImageCornerRadius;
                accountImg.layer.masksToBounds = true;
                accountImg.wxn_setImageWithURL(NSURL(string: model!.imageurl)!, placeholderImage: UIImage(named: "sina")!);
            }

            NSNotificationCenter.defaultCenter().addObserver(self, selector: "changedDay:", name: "changeDay", object: nil)
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

        self.loadZhibiao(day_ago,mediaUserId: (model?.id)!);
    }
    
    func loadZhibiao(dayId:Int,mediaUserId:Int){
        //数据链接，解析
        let url = rootURL + "weiboAccount/findStatUserPercentage.cic";
        let parameters = [
            "dayId": dayId,
            "mediaUserId":mediaUserId,
        ]
        Alamofire.request(.GET, url,parameters: parameters).responseJSON{
            data in
            if(data.result.isSuccess){
                let json = data.result.value!;
                if (!NSJSONSerialization.isValidJSONObject(json)) {
                    //self.alert_view(1008);
                }else{
                    let jsonObj = Utils.stringToJson(json);
                    //print(jsonObj)
                    for(var i = 0 ; i < jsonObj.count; i++){
                        let temp = jsonObj[i]
                        let id = temp.objectForKey("id") as! String;
                        let val = temp.objectForKey("value1") as! String;
                        if id == "NUM_OF_R_FANS"{
                            self.model?.fans = val;
                            self.newFans.text = val;
                        }else if id == "NUM_OF_TWEETS" {
                            self.model?.tweets = val;

                            self.newTweets.text = val;
                        }else if id == "NUM_OF_PASSIVE_MENTION"{
                            self.model?.retweets = val;

                            self.newRetweets.text = val;
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