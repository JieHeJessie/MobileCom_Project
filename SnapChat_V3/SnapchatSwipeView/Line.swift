//
//  Line.swift
//  SnapChat-V3
//
//  Created by lavintyben on 16/9/30.
//  Copyright © 2016年 Brendan Lee. All rights reserved.
//

import UIKit

class Line {
    
    var start: CGPoint
    var end: CGPoint
    var color: UIColor
    
    var startX: CGFloat{
        get{
            return start.x
        }
    }
    
    var startY: CGFloat{
        get{
            return start.y
        }
    }
    
    var endX: CGFloat{
        get{
            return end.x
        }
    }
    
    var endY: CGFloat{
        get{
            return end.y
        }
    }
    
    init(start _start: CGPoint, end _end: CGPoint, color _color: UIColor){
        
        self.start = _start
        self.end = _end
        self.color = _color
    
    }


}
