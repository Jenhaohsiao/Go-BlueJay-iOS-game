//
//  GameScene.swift
//  FlappyClone
//
//  Created by HSIAO JENHAO on 2016-09-21.
//  Copyright © 2016 HSIAO JENHAO. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGFloat{
    
    
    public static func random() -> CGFloat{
        
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    public static func random(min : CGFloat, max : CGFloat) -> CGFloat{
        
        return CGFloat.random() * (max - min) + min
    }
    
    
    
}


