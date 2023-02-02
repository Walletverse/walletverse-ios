//
//  UIView+Utils.swift
//  Walletverse
//
//  Created by Ky on 2022/9/29.
//  Copyright © 2022 Walletverse. All rights reserved.
//

import UIKit

extension UIView {
    
    var x : CGFloat {
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.x
        }
    }
    
    var y : CGFloat {
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.y
        }
    }
    
    var right : CGFloat {
        set {
            var frame = self.frame;
            frame.origin.x = newValue - frame.size.width;
            self.frame = frame;
        }
        get {
            return self.frame.origin.x + self.frame.size.width;
        }
    }
    
    var bottom : CGFloat {
        set {
            var frame = self.frame;
            frame.origin.y = newValue - frame.size.height;
            self.frame = frame;
        }
        get {
            return self.frame.origin.y + self.frame.size.height;
        }
    }
    
    var centerX : CGFloat {
        set {
            self.center = CGPoint.init(x: newValue, y: self.center.y)
        }
        get {
            return self.center.x
        }
    }
    
    var centerY : CGFloat {
        set {
            self.center = CGPoint.init(x: self.center.x, y: newValue)
        }
        get {
            return self.center.y
        }
    }
    
    var width : CGFloat {
        set {
            var frame = self.frame;
            frame.size.width = newValue;
            self.frame = frame;
        }
        get {
            return self.frame.size.width
        }
    }
    
    var height : CGFloat {
        set {
            var frame = self.frame;
            frame.size.height = newValue;
            self.frame = frame;
        }
        get {
            return self.frame.size.height
        }
    }
    
    var origin : CGPoint {
        set {
            var frame = self.frame;
            frame.origin = newValue;
            self.frame = frame;
        }
        get {
            return self.frame.origin
        }
    }
    
    var size : CGSize {
        set {
            var frame = self.frame;
            frame.size = newValue;
            self.frame = frame;
        }
        get {
            return self.frame.size
        }
    }
    
}
