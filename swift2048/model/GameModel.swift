//
//  GameModel.swift
//  swift2048
//
//  Created by xiaojia on 7/7/14.
//  Copyright (c) 2014 IOSAvenger. All rights reserved.
//

import UIKit

class GameModel{
    
    var dimension : Int
    
    var chessArray : Array<Int>!
    
    init(dimension:Int)
    {
        self.dimension = dimension
        
        initchessArray()
    }
    
    func initchessArray()
    {
        chessArray = Array<Int> (count:self.dimension*self.dimension, repeatedValue:0)
    }
    
    func setPosition(row:Int, col:Int, value:Int) -> Bool
    {
        assert(row>=0 && row<self.dimension)
        assert(col>=0 && col<self.dimension)
        
        var index = self.dimension*row + col
        
        if(chessArray[index]>0){
            println("位置已被占用")
            return false
        }
        
        chessArray[index] = value
        return true
    }
    
    func emptyPosition() -> Int[]
    {
        var emptyChess = Array<Int>()
        for i in 0..(self.dimension*self.dimension)
        {
            if(chessArray[i]==0){
                emptyChess += i
            }
        }
        return emptyChess
    }
    
    
    func isFull() -> Bool
    {
        if(emptyPosition().count==0){
            println("isFull")
            return true
        }
        return false
    }
    
    func findRightPosition()
    {
        for index in 0..dimension*dimension {
            //if(chessArray[index])
        }
    }
    
    func margeValue()
    {
        for index in dimension..dimension*dimension {
            if(chessArray[index-dimension] == chessArray[index] && chessArray[index] != 0){
                chessArray[index-dimension] *= 2
                chessArray[index] = 0
            }
        }
    }
}