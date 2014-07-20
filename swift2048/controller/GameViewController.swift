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
    var chessList : Dictionary<NSIndexPath,chessView> = Dictionary()   //初始化棋子字典保存Label
    var chessValue : Dictionary<NSIndexPath,Int> = Dictionary()         //初始化棋子字典保存value
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
            
            var chess : chessView = chessView(postion:CGPointMake(Float(65/2+col*65),Float(150+row*65)),width:width,value:value)
            //var TargetView : UIView = boxArray.objectAtIndex(index) as UIView
            self.view.addSubview(chess)
            self.view.bringSubviewToFront(chess)
       
            var IndexPath = NSIndexPath(forRow:row,inSection:col)
            chessList[IndexPath] = chess
            chessValue[IndexPath] = value
            gameModel.chessArray[index] = value
            
            CATransaction.begin()                                       //CAAnimation part begin
            CATransaction.setValue(0.2, forKey:kCATransactionAnimationDuration)
            
            var scaleAnimation : CABasicAnimation = CABasicAnimation(keyPath:"transform.scale")
            scaleAnimation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionLinear)
            scaleAnimation.fromValue = 0.0
            scaleAnimation.toValue = 1.0
            
            chess.layer.addAnimation(scaleAnimation, forKey:"scaleAnimation")
            
            CATransaction.commit()                                     //CAAnimation part commit
            }else{
                generateChess()
            }
        }
        
    }
    
    func insertChess(row:Int,col:Int,value:Int) {
        var chess : chessView = chessView(postion:CGPointMake(Float(65/2+col*65),Float(150+row*65)),width:width,value:value)
        //var TargetView : UIView = boxArray.objectAtIndex(index) as UIView
        self.view.addSubview(chess)
        //self.view.bringSubviewToFront(chess)
        
        var IndexPath = NSIndexPath(forRow:row,inSection:col)
        
        var index = row*dimension+col
        chessList[IndexPath] = chess
        chessValue[IndexPath] = value
        gameModel.chessArray[index] = value
        
//        CATransaction.begin()                                       //CAAnimation part begin
//        CATransaction.setValue(0.2, forKey:kCATransactionAnimationDuration)
//        
//        var scaleAnimation : CABasicAnimation = CABasicAnimation(keyPath:"transform.scale")
//        scaleAnimation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionLinear)
//        scaleAnimation.fromValue = 0.0
//        scaleAnimation.toValue = 1.0
//        
//        chess.layer.addAnimation(scaleAnimation, forKey:"scaleAnimation")
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
    
    func updateUI() {
        for (key,chess) in chessList{
            chess.removeFromSuperview()
        }
        
        for index in 0..dimension*dimension {
            var value = gameModel.chessArray[index]
            if(value != 0){
                var row = Int(index/dimension)
                var col = Int(index%dimension)
                insertChess(row,col:col,value:value)
            }
        }
    }
    
    
    func generateBackG()
    {
        for index in 0..dimension*dimension {                    //box initialize
            var box : UIView = UIView()
            box.frame = CGRectMake( Float(65/2+(index%4)*65), 150 + Float(Int(index/4)*65), 60, 60)
            box.backgroundColor = (UIColor.darkGrayColor())
            boxArray.insertObject(box, atIndex:Int(index))
            
            let swipeUpGestureR = UISwipeGestureRecognizer(target:self , action:"SwipeAction:")      //add gesturerecoginer
            swipeUpGestureR.direction = UISwipeGestureRecognizerDirection.Up
            self.view.addGestureRecognizer(swipeUpGestureR)
            let swipeRightGestureR = UISwipeGestureRecognizer(target:self , action:"SwipeAction:")
            swipeRightGestureR.direction = UISwipeGestureRecognizerDirection.Right
            self.view.addGestureRecognizer(swipeRightGestureR)
            let swipeLeftGestureR = UISwipeGestureRecognizer(target:self , action:"SwipeAction:")
            swipeLeftGestureR.direction = UISwipeGestureRecognizerDirection.Left
            self.view.addGestureRecognizer(swipeLeftGestureR)
            let swipeDownGestureR = UISwipeGestureRecognizer(target:self , action:"SwipeAction:")
            swipeDownGestureR.direction = UISwipeGestureRecognizerDirection.Down
            self.view.addGestureRecognizer(swipeDownGestureR)
    
        }
        
        for index in 0..dimension*dimension {
            self.view.addSubview(boxArray.objectAtIndex(Int(index)) as UIView)
        }
    }
    


    func ReSetClick(sender : UIButton){
        gameModel.initchessArray()
        for (key,chess) in chessList{
            chess.removeFromSuperview()
        }
        chessList.removeAll(keepCapacity:true)
        chessValue.removeAll(keepCapacity:true)
    }
    
    func NewClick(shender : UIButton){
        generateChess()
        println(gameModel.chessArray)
    }
    
    
    func removeChessForKey(key : NSIndexPath, Index : Int){
        var chess = chessList[key]!
        var chessvalue = chessValue[key]
        
        chess.removeFromSuperview()
        chessList.removeValueForKey(key)
        chessValue.removeValueForKey(key)
        gameModel.chessArray[Index]=0
        println("remove")
    }
    
    func SwipeAction(gestureRecognizer : UISwipeGestureRecognizer){
        if gestureRecognizer.direction & .Right {
            println("Right")
            MoveRight()
        }else if(gestureRecognizer.direction & .Up){
            println("up")
            //gameModel.margeValue()
            MoveUp()
            //updateUI()
            println(gameModel.chessArray)
        }else if(gestureRecognizer.direction & .Left){
            println("left")
            MoveLeft()
            
        }else if(gestureRecognizer.direction & .Down){
            println("down")
            MoveDown()
        }

    }
    
    func MoveUp()
    {
        var value : Int!
        for i in 0..dimension {
            for j in 0..dimension {
                var row = i
                var col = j
                var IndexPath = NSIndexPath(forRow:row, inSection:col)
                value = chessValue[IndexPath]
                var index = i*dimension + j
                if(chessValue[IndexPath] != nil){
                    if(row>0){
                        if(chessValue[NSIndexPath(forRow:row-1, inSection:col)]==nil){
                            IndexPath = NSIndexPath(forRow:row, inSection:col)
                            removeChessForKey(IndexPath,Index:index)
                            println("row is \(row), col is \(col)")
                            row = i-1;
                            IndexPath = NSIndexPath(forRow:row, inSection:col)
                            insertChess(row,col:col,value:value)
                            if(chessValue[NSIndexPath(forRow:row-1, inSection:col)]==nil){
                                //MoveUp()
                            }
                        }else if(chessValue[NSIndexPath(forRow:row-1, inSection:col)] == value) {
                            //chessValue[NSIndexPath(forRow:row+1, inSection:col)] = 2 * value
                            //chessValue[IndexPath] = nil
                            value = 2 * value
                            removeChessForKey(IndexPath,Index:index)
                            var index = i*dimension + j - dimension
                            removeChessForKey(NSIndexPath(forRow:row-1, inSection:col),Index:index)
                            insertChess(row-1,col:col,value:value)
                            println("merge")
                        }
                    }
                }
            }
        }
    }
    
    func MoveRight()
    {
        var value : Int!
        for i in 0..dimension {
            for j in 0..dimension {
                var row = i
                var col = j
                var IndexPath = NSIndexPath(forRow:row, inSection:col)
                value = chessValue[IndexPath]
                var index = i*dimension + j
                if(chessValue[IndexPath] != nil){
                    if(col<3){
                        if(chessValue[NSIndexPath(forRow:row, inSection:col+1)]==nil){
                            IndexPath = NSIndexPath(forRow:row, inSection:col)
                            removeChessForKey(IndexPath,Index:index)
                            println("row is \(row), col is \(col)")
                            col = j+1;
                            IndexPath = NSIndexPath(forRow:row, inSection:col)
                            insertChess(row,col:col,value:value)
                            if(chessValue[NSIndexPath(forRow:row, inSection:col+1)]==nil){
                                MoveRight()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func MoveLeft()
    {
        var value : Int!
        for i in 0..dimension {
            for j in 0..dimension {
                var row = i
                var col = j
                var IndexPath = NSIndexPath(forRow:row, inSection:col)
                value = chessValue[IndexPath]
                var index = i*dimension + j
                if(chessValue[IndexPath] != nil){
                    if(col>0){
                        if(chessValue[NSIndexPath(forRow:row, inSection:col-1)]==nil){
                            IndexPath = NSIndexPath(forRow:row, inSection:col)
                            removeChessForKey(IndexPath,Index:index)
                            println("row is \(row), col is \(col)")
                            col = j-1;
                            IndexPath = NSIndexPath(forRow:row, inSection:col)
                            insertChess(row,col:col,value:value)
                            if(chessValue[NSIndexPath(forRow:row, inSection:col-1)]==nil){
                                MoveLeft()
                            }
                        }
                    }
                }
            }
        }    }
    
    func MoveDown()
    {
        var value : Int!
        for i in 0..dimension {
            for j in 0..dimension {
                var row = i
                var col = j
                var IndexPath = NSIndexPath(forRow:row, inSection:col)
                value = chessValue[IndexPath]
                var index = i*dimension + j
                if(chessValue[IndexPath] != nil){
                    if(row<3){
                        if(chessValue[NSIndexPath(forRow:row+1, inSection:col)]==nil){
                            IndexPath = NSIndexPath(forRow:row, inSection:col)
                            removeChessForKey(IndexPath,Index:index)
                            println("row is \(row), col is \(col)")
                            row = i+1;
                            IndexPath = NSIndexPath(forRow:row, inSection:col)
                            insertChess(row,col:col,value:value)
                            if(chessValue[NSIndexPath(forRow:row+1, inSection:col)]==nil){
                                MoveDown()
                            }
                        }else if(chessValue[NSIndexPath(forRow:row+1, inSection:col)] == value) {
                            //chessValue[NSIndexPath(forRow:row+1, inSection:col)] = 2 * value
                            //chessValue[IndexPath] = nil
                            value = 2 * value
                            removeChessForKey(IndexPath,Index:index)
                            var index = i*dimension + j + dimension
                            removeChessForKey(NSIndexPath(forRow:row+1, inSection:col),Index:index)
                            insertChess(row+1,col:col,value:value)
                            println("merge")
                        }
                    }
                }
            }
        }
    }
    
    func mergeUp()
    {
        var value : Int!
        for i in 0..dimension {
            for j in 0..dimension {
                var row = i
                var col = j
                var IndexPath = NSIndexPath(forRow:row, inSection:col)
                value = chessValue[IndexPath]
                var index = i*dimension + j
                if(chessValue[IndexPath] != nil){
                    
                }
            }
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
