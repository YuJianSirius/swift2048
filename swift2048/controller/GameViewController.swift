//
//  GameViewController.swift
//  swift2048
//
//  Created by xiaojia on 7/2/14.
//  Copyright (c) 2014 IOSAvenger. All rights reserved.
//

import UIKit
import QuartzCore

class GameViewController: UIViewController{
 
 
    var boxArray : NSMutableArray = NSMutableArray()        //初始化游戏箱子数组
    var chessArray : NSMutableArray = NSMutableArray()      //初始化棋子数组
    var dimension:Int = 4
    var width:Float = 60
    var gameModel = GameModel(dimension:4)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        generateChess()
    }

    func generateChess()
    {
        let rdnumber = Int(arc4random_uniform(2))
        var value : Int = 0
        
        if(rdnumber==1){
            value = 2
        }else{
            value = 4
        }
        
        let row = Int(arc4random_uniform(UInt32(dimension)))
        let col = Int(arc4random_uniform(UInt32(dimension)))
        
        if(gameModel.isFull()){
            return
        }
        else{
            if(gameModel.setPosition(row,col:col,value:value)){
            var index = row*dimension + col
            
            var chess : chessView = chessView(postion:CGPointMake(0, 0),width:width,value:value)
            var TargetView : UIView = boxArray.objectAtIndex(index) as UIView
            TargetView.addSubview(chess)
            
            CATransaction.begin()                                       //CAAnimation part begin
            CATransaction.setValue(0.2, forKey:kCATransactionAnimationDuration)
            
            var scaleAnimation : CABasicAnimation = CABasicAnimation(keyPath:"transform.scale")
            scaleAnimation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionLinear)
            scaleAnimation.fromValue = 0.0
            scaleAnimation.toValue = 1.0
            
            TargetView.layer.addAnimation(scaleAnimation, forKey:"scaleAnimation")
            
            CATransaction.commit()                                     //CAAnimation part commit
            }
        }
        
    }
    
    func initUI()
    {
        
        var ReSetBtn : UIButton = UIButton(frame:CGRectMake(140,450,50,30))
        ReSetBtn.backgroundColor = (UIColor.blueColor())
        ReSetBtn.setTitle("Reset",forState: UIControlState.Normal)
        ReSetBtn.addTarget(self, action: "ReSetClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(ReSetBtn)
        
        var NewChessBtn : UIButton = UIButton(frame:CGRectMake(140, 500, 50, 30))
        NewChessBtn.backgroundColor = (UIColor.blueColor())
        NewChessBtn.setTitle("New",forState: UIControlState.Normal)
        NewChessBtn.addTarget(self, action: "NewClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(NewChessBtn)
        
        generateBackG()
    }
    
    func generateBackG()
    {
        for index in 0..dimension*dimension {                    //box initialize
            var box : UIView = UIView()
            box.frame = CGRectMake( Float(65/2+(index%4)*65), 150 + Float(Int(index/4)*65), 60, 60)
            box.backgroundColor = (UIColor.darkGrayColor())
            //self.view.addSubview(box)
            boxArray.insertObject(box, atIndex:Int(index))
            
            let swipeGestureR = UISwipeGestureRecognizer(target:self , action:"SwipeAction:")   //add gesturerecoginer
            swipeGestureR.direction = UISwipeGestureRecognizerDirection.Up
            box.addGestureRecognizer(swipeGestureR)
            let rightGestureR = UISwipeGestureRecognizer(target:self , action:"SwipeAction:")
            rightGestureR.direction = UISwipeGestureRecognizerDirection.Right
            //            swipeGestureR.direction = UISwipeGestureRecognizerDirection.Left
            //            swipeGestureR.direction = UISwipeGestureRecognizerDirection.Down
            box.addGestureRecognizer(rightGestureR)
        }
        
        for index in 0..dimension*dimension {
            self.view.addSubview(boxArray.objectAtIndex(Int(index)) as UIView)
        }
    }
    
    
    
    func ReSetClick(sender : UIButton){
        gameModel.initchessArray()
        for index in 0..dimension*dimension{
            var TargetView : UIView = boxArray.objectAtIndex(index) as UIView
            TargetView.removeFromSuperview()
        }
        initUI()
    }
    
    func NewClick(shender : UIButton){
        generateChess()
    }
    
    func SwipeAction(gestureRecognizer : UISwipeGestureRecognizer){
//        switch gestureRecognizer.direction {
//            case is UISwipeGestureRecognizerDirection.Right:
//                println("swipeActiveUp")
//        }
        if gestureRecognizer.direction & .Right {
            println("Right")
        }else if(gestureRecognizer.direction & .Up){
            println("up")
        }

    }
    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
