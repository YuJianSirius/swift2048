//
//  chessView.swift
//  swift2048
//
//  Created by xiaojia on 7/7/14.
//  Copyright (c) 2014 IOSAvenger. All rights reserved.
//

import UIKit

class chessView : UIView{
    
    var numberLabel : UILabel = UILabel()
    
    let colorMAP = [
        2 : UIColor(red: 238.0/255.0, green: 228.0/255.0, blue: 218.0/255.0, alpha: 1.0),
        4 : UIColor(red: 218.0/255.0, green: 228.0/255.0, blue: 218.0/255.0, alpha: 1.0),
        8 : UIColor(red: 238.0/255.0, green: 228.0/255.0, blue: 218.0/255.0, alpha: 1.0),
        16: UIColor(red: 245.0/255.0, green: 149.0/255.0, blue: 99.0/255.0, alpha: 1.0)
    ]
    
    var value : Int = 0 {
        didSet{
            backgroundColor = colorMAP[value]
            numberLabel.text = "\(value)"
        }
    }
    
    init(postion:CGPoint, width:CGFloat, value:Int)
    {
        numberLabel = UILabel(frame:CGRectMake(0,0,width,width))
        numberLabel.textColor = UIColor.whiteColor()
        numberLabel.font = UIFont(name:"微软雅黑",size:30)
        numberLabel.textAlignment = NSTextAlignment.Center
        numberLabel.text = "\(value)"
        super.init(frame:CGRectMake(postion.x,postion.y,width,width))
        
        self.addSubview(numberLabel)
        self.value = value
        backgroundColor = colorMAP[value]
    }
}
