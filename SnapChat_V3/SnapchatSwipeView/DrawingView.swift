//
//  drawingView.swift
//  SnapChat-V3
//
//  Created by lavintyben on 16/9/30.
//  Copyright © 2016年 Brendan Lee. All rights reserved.
//

import UIKit

class DrawingView: UIView {

    var lines: [Line] = []
    var lastPoint: CGPoint!
    
    var drawColor:UIColor = UIColor.redColor()
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        lastPoint = touches.first?.locationInView(self)
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let newPoint = touches.first?.locationInView(self)
        lines.append(Line(start: lastPoint,end: newPoint!,color:drawColor))
        lastPoint = newPoint
        
        self.setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetLineCap(context, .Round)
        CGContextSetLineWidth(context, 5)
        
        for line in lines{
            
            CGContextBeginPath(context)
            CGContextMoveToPoint(context, line.startX, line.startY)
            CGContextAddLineToPoint(context, line.endX, line.endY)
            CGContextSetStrokeColorWithColor(context, line.color.CGColor)
            CGContextStrokePath(context)
        }
    }
    
    func resetDrawing (){
    
        lines = []
        self.setNeedsDisplay()
    
    }

}
