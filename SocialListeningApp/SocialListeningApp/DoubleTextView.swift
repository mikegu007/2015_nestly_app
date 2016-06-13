

//
//  DoubleTextView.swift
//  SocialListeningApp
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/8/16.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.

import UIKit

class DoubleTextView: UIView {
    
    private let leftTextButton: NoHighlightButton =  NoHighlightButton()
    private let rightTextButton: NoHighlightButton = NoHighlightButton()
    private let textColorFroNormal: UIColor = UIColor(red: 100 / 255.0, green: 100 / 255.0, blue: 100 / 255.0, alpha: 1)
    private let textFont: UIFont = theme.SDNavTitleFont
    private let bottomLineView: UIView = UIView()
    private let bottomLineViewBackGroud: UIView = UIView()
    
    private var selectedBtn: UIButton?
    weak var delegate: DoubleTextViewDelegate?
    var bottomLineWith:CGFloat = 60.0;
    // -1 都没有权限 0 第一个有权限 1 第二个有权限 2 都有权限
    var selIndex = 2;
    
    
    /// 便利构造方法
    convenience init(leftText: String, rigthText: String) {
        self.init()
        /*
        // 设置左边文字
        setButton(leftTextButton, title: leftText, tag: 100)
        // 设置右边文字
        setButton(rightTextButton, title: rigthText, tag: 101)
        // 设置底部线条View
        setBottomLineView()
        
        titleButtonClick(leftTextButton)
*/
    }
    
    func initTitle(leftText: String, rigthText: String,clickIndex:Int) {
        selIndex = clickIndex;

        if selIndex == -1 {
            // 设置左边文字
            setButton(leftTextButton, title: leftText, tag: 100,addTarget: false)
            // 设置右边文字
            setButton(rightTextButton, title: rigthText, tag: 101,addTarget: false)
        }else if selIndex == 2 {
            // 设置左边文字
            setButton(leftTextButton, title: leftText, tag: 100,addTarget: true)
            // 设置右边文字
            setButton(rightTextButton, title: rigthText, tag: 101,addTarget: true)
        }else if selIndex == 0 {
            // 设置左边文字
            setButton(leftTextButton, title: leftText, tag: 100,addTarget: true)
            // 设置右边文字
            setButton(rightTextButton, title: rigthText, tag: 101,addTarget: false)
        }else {
            // 设置左边文字
            setButton(leftTextButton, title: leftText, tag: 100,addTarget: false)
            // 设置右边文字
            setButton(rightTextButton, title: rigthText, tag: 101,addTarget: true)
        }
        
        // 设置底部线条View
        setBottomLineView()


        if clickIndex != 1{
            titleButtonClick(leftTextButton)
        }else {
            titleButtonClick(rightTextButton)
            super.layoutSubviews();
        }
        

    }
    
    func clickBtn(index:Int){
        if index == 0 {
            titleButtonClick(leftTextButton)
        }else{
            titleButtonClick(rightTextButton)
            super.layoutSubviews();
        }
    }
    
    
    
    private func setBottomLineView() {
        bottomLineViewBackGroud.backgroundColor = UIColor.colorWith(217, green: 217, blue: 217, alpha: 1)
        
        bottomLineView.backgroundColor = theme.SDNativeBackgroundColor;
        
        bottomLineViewBackGroud.addSubview(bottomLineView);
        
        addSubview(bottomLineViewBackGroud)
    }
    
    private func setButton(button: UIButton, title: String, tag: Int,addTarget:Bool) {
        button.setTitleColor(theme.SDNativeBackgroundColor, forState: .Selected)
        button.setTitleColor(textColorFroNormal, forState: .Normal)
        button.titleLabel?.font = textFont
        button.tag = tag
        if addTarget{
            button.addTarget(self, action: "titleButtonClick:", forControlEvents: .TouchUpInside)
        }
        button.setTitle(title, forState: .Normal)
        addSubview(button)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let btnW = width * 0.5
        leftTextButton.frame = CGRectMake(0, 0, btnW, height)
        rightTextButton.frame = CGRectMake(btnW, 0, btnW, height)
        bottomLineViewBackGroud.frame = CGRectMake(0, height - 2, width, 1)
        
        //let leftBtnWidth =
        // 宽度是固定的
        bottomLineView.frame = CGRectMake(0, 0, bottomLineWith, 2)
        if selIndex != 1 {
            bottomLineView.frame.origin.x = btnW/2 - self.bottomLineView.width/2;
        }else{
            self.bottomLineView.frame.origin.x = btnW + btnW/2 - self.bottomLineView.width/2;
        }
        
    }
    
    func titleButtonClick(sender: UIButton) {
        changeBtnStyle(sender);
        delegate?.doubleTextView(self, didClickBtn: sender, forIndex: sender.tag - 100)
    }
    
    func changeBtnStyle(sender: UIButton){
        selectedBtn?.selected = false
        sender.selected = true
        selectedBtn = sender
        bottomViewScrollTo(sender.tag - 100)
    }
    // 设置line滚动到的位置
    func bottomViewScrollTo(index: Int) {
        //print("index:\(index)");
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            //self.bottomLineView.frame.origin.x = CGFloat(index) * self.bottomLineView.width
            let btnW = self.width * 0.5
            if index == 0 {
                  //print("move 1");
                self.bottomLineView.frame.origin.x = btnW/2 - self.bottomLineView.width/2;
            }else{
                 // print("move 2");
                self.bottomLineView.frame.origin.x = btnW + btnW/2 - self.bottomLineView.width/2;
                
            }
        })


    }
    
    
    
    
    func clickBtnToIndex(index: Int) {
        let btn: NoHighlightButton = self.viewWithTag(index + 100) as! NoHighlightButton
        self.titleButtonClick(btn)
    }
    
    
    func changeBtnStyleIndex(index:Int){
        let btn: NoHighlightButton = self.viewWithTag(index + 100) as! NoHighlightButton
        changeBtnStyle(btn)
    }
}

/// DoubleTextViewDelegate协议
protocol DoubleTextViewDelegate: NSObjectProtocol{
    
    func doubleTextView(doubleTextView: DoubleTextView, didClickBtn btn: UIButton, forIndex index: Int)
    
}

/// 没有高亮状态的按钮
class NoHighlightButton: UIButton {
    /// 重写setFrame方法
    override var highlighted: Bool {
        didSet{
            super.highlighted = false
        }
    }
}
