//
//  ZGScanView.swift
//  Walletverse
//
//  Created by Ky on 2022/9/29.
//  Copyright © 2022 Walletverse. All rights reserved.
//

import UIKit

class ZGScanView: BaseView {
    var viewStyle:ZGScanViewStyle = ZGScanViewStyle()
    var scanRetangleRect:CGRect = CGRect.zero
    var scanLineAnimation:ZGScanLineAnimation?
    var scanLineStill:UIImageView?
    var activityView:UIActivityIndicatorView?
    var labelReadying:UILabel?
    var isAnimationing:Bool = false
    
    lazy var scanTipL : UILabel = {
        return CustomView.labelCustom(text: LocalString("scan_pay_tip"), font: FontSystem(size: 14), color: ColorHex(0xffffff), textAlignment: .center)
    }()
    
    public init(frame:CGRect, vstyle:ZGScanViewStyle ) {
        viewStyle = vstyle
        scanLineAnimation = ZGScanLineAnimation.instance()
        var frameTmp = frame;
        frameTmp.origin = CGPoint.zero
        super.init(frame: frameTmp)
        backgroundColor = UIColor.clear
    }
    
    override init(frame: CGRect) {
        var frameTmp = frame;
        frameTmp.origin = CGPoint.zero
        super.init(frame: frameTmp)
        backgroundColor = UIColor.clear
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    deinit {
        if (scanLineAnimation != nil) {
            scanLineAnimation!.stopStepAnimating()
        }
    }
    
    func startScanAnimation() {
        if isAnimationing {
            return
        }
        isAnimationing = true
        let cropRect:CGRect = getScanRectForAnimation()
        scanLineAnimation!.startAnimatingWithRect(animationRect: cropRect, parentView: self, image:viewStyle.animationImage )
    }
    
    func stopScanAnimation() {
        isAnimationing = false
        scanLineAnimation?.stopStepAnimating()
    }
    
    override open func draw(_ rect: CGRect) {
        drawScanRect()
    }
    
    func drawScanRect() {
        let XRetangleLeft = viewStyle.xScanRetangleOffset
        var sizeRetangle = CGSize(width: self.frame.size.width - XRetangleLeft*2.0, height: self.frame.size.width - XRetangleLeft*2.0)
        if viewStyle.whRatio != 1.0 {
            let w = sizeRetangle.width;
            var h:CGFloat = w / viewStyle.whRatio
            let hInt:Int = Int(h)
            h = CGFloat(hInt)
            sizeRetangle = CGSize(width: w, height: h)
        }
        let YMinRetangle = height / 2.0 - sizeRetangle.height/2.0 - viewStyle.centerUpOffset
        let YMaxRetangle = YMinRetangle + sizeRetangle.height
        let XRetangleRight = width - XRetangleLeft
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(viewStyle.color_NotRecoginitonArea.cgColor)
        var rect = CGRect(x: 0, y: 0, width: width, height: YMinRetangle)
        context.fill(rect)
        
        rect = CGRect(x: 0, y: YMinRetangle, width: XRetangleLeft, height: sizeRetangle.height)
        context.fill(rect)
        
        rect = CGRect(x: XRetangleRight, y: YMinRetangle, width: XRetangleLeft,height: sizeRetangle.height)
        context.fill(rect)
        
        rect = CGRect(x: 0, y: YMaxRetangle, width: self.frame.size.width,height: self.frame.size.height - YMaxRetangle)
        context.fill(rect)

        context.strokePath()
    
        if viewStyle.isNeedShowRetangle {
            context.setStrokeColor(viewStyle.colorRetangleLine.cgColor)
            context.setLineWidth(1);
            context.addRect(CGRect(x: XRetangleLeft, y: YMinRetangle, width: sizeRetangle.width, height: sizeRetangle.height))
            context.strokePath()
        }
        scanRetangleRect = CGRect(x: XRetangleLeft, y:  YMinRetangle, width: sizeRetangle.width, height: sizeRetangle.height)
        
        let wAngle = viewStyle.photoframeAngleW;
        let hAngle = viewStyle.photoframeAngleH;
        
        let linewidthAngle = viewStyle.photoframeLineW;
        
        var diffAngle = linewidthAngle/3;
        diffAngle = linewidthAngle / 2;
        diffAngle = linewidthAngle/2;
        diffAngle = 0;
        diffAngle = linewidthAngle/3
        
        context.setStrokeColor(viewStyle.colorAngle.cgColor);
        context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0);
        
        context.setLineWidth(linewidthAngle);
        
        let leftX = XRetangleLeft - diffAngle
        let topY = YMinRetangle - diffAngle
        let rightX = XRetangleRight + diffAngle
        let bottomY = YMaxRetangle + diffAngle
        
        context.move(to: CGPoint(x: leftX-linewidthAngle/2, y: topY))
        context.addLine(to: CGPoint(x: leftX + wAngle, y: topY))
        
        context.move(to: CGPoint(x: leftX, y: topY-linewidthAngle/2))
        context.addLine(to: CGPoint(x: leftX, y: topY+hAngle))
        
        context.move(to: CGPoint(x: leftX-linewidthAngle/2, y: bottomY))
        context.addLine(to: CGPoint(x: leftX + wAngle, y: bottomY))
        
        context.move(to: CGPoint(x: leftX, y: bottomY+linewidthAngle/2))
        context.addLine(to: CGPoint(x: leftX, y: bottomY - hAngle))
        
        context.move(to: CGPoint(x: rightX+linewidthAngle/2, y: topY))
        context.addLine(to: CGPoint(x: rightX - wAngle, y: topY))
        
        context.move(to: CGPoint(x: rightX, y: topY-linewidthAngle/2))
        context.addLine(to: CGPoint(x: rightX, y: topY + hAngle))
        
        context.move(to: CGPoint(x: rightX+linewidthAngle/2, y: bottomY))
        context.addLine(to: CGPoint(x: rightX - wAngle, y: bottomY))
        
        context.move(to: CGPoint(x: rightX, y: bottomY+linewidthAngle/2))
        context.addLine(to: CGPoint(x: rightX, y: bottomY - hAngle))
        
        context.strokePath()
        
        scanTipL.frame = CGRect(x: 16, y: bottomY+linewidthAngle/2 + 30, width: ZSCREENWIDTH - 32, height: 50)
        scanTipL.numberOfLines = 2
        addSubview(scanTipL)
    }
    
    func getScanRectForAnimation() -> CGRect {
        let XRetangleLeft = viewStyle.xScanRetangleOffset
        var sizeRetangle = CGSize(width: width - XRetangleLeft*2, height: width - XRetangleLeft*2)
        if viewStyle.whRatio != 1 {
            let w = sizeRetangle.width
            var h = w / viewStyle.whRatio
            let hInt:Int = Int(h)
            h = CGFloat(hInt)
            sizeRetangle = CGSize(width: w, height: h)
        }
        let YMinRetangle = height / 2.0 - sizeRetangle.height/2.0 - viewStyle.centerUpOffset
        let cropRect =  CGRect(x: XRetangleLeft, y: YMinRetangle, width: sizeRetangle.width, height: sizeRetangle.height)
        return cropRect;
    }
    
    static func getScanRectWithPreView(preView:UIView, style:ZGScanViewStyle) -> CGRect {
        let XRetangleLeft = style.xScanRetangleOffset;
        var sizeRetangle = CGSize(width: preView.width - XRetangleLeft*2, height: preView.width - XRetangleLeft*2)
        if style.whRatio != 1 {
            let w = sizeRetangle.width
            var h = w / style.whRatio
            let hInt:Int = Int(h)
            h = CGFloat(hInt)
            sizeRetangle = CGSize(width: w, height: h)
        }
        let YMinRetangle = preView.height / 2.0 - sizeRetangle.height/2.0 - style.centerUpOffset
        let cropRect =  CGRect(x: XRetangleLeft, y: YMinRetangle, width: sizeRetangle.width, height: sizeRetangle.height)
        var rectOfInterest:CGRect
        
        let size = preView.bounds.size;
        let p1 = size.height/size.width;
        
        let p2:CGFloat = 1920.0/1080.0
        if p1 < p2 {
            let fixHeight = size.width * 1920.0 / 1080.0;
            let fixPadding = (fixHeight - size.height)/2;
            rectOfInterest = CGRect(x: (cropRect.origin.y + fixPadding)/fixHeight,
                                    y: cropRect.origin.x/size.width,
                                    width: cropRect.size.height/fixHeight,
                                    height: cropRect.size.width/size.width)
        } else {
            let fixWidth = size.height * 1080.0 / 1920.0;
            let fixPadding = (fixWidth - size.width)/2;
            rectOfInterest = CGRect(x: cropRect.origin.y/size.height,
                                    y: (cropRect.origin.x + fixPadding)/fixWidth,
                                    width: cropRect.size.height/size.height,
                                    height: cropRect.size.width/fixWidth)
        }
        return rectOfInterest
    }
    
    func getRetangeSize()->CGSize {
        let XRetangleLeft = viewStyle.xScanRetangleOffset
        var sizeRetangle = CGSize(width: width - XRetangleLeft*2, height: width - XRetangleLeft*2)
        let w = sizeRetangle.width;
        var h = w / viewStyle.whRatio;
        let hInt:Int = Int(h)
        h = CGFloat(hInt)
        sizeRetangle = CGSize(width: w, height:  h)
        return sizeRetangle
    }
    
    func deviceStartReadying(readyStr:String) {
        let XRetangleLeft = viewStyle.xScanRetangleOffset
        let sizeRetangle = getRetangeSize()
        let YMinRetangle = height / 2.0 - sizeRetangle.height/2.0 - viewStyle.centerUpOffset
        if (activityView == nil) {
            self.activityView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            activityView?.center = CGPoint(x: XRetangleLeft +  sizeRetangle.width/2 - 50, y: YMinRetangle + sizeRetangle.height/2)
            activityView?.style = UIActivityIndicatorView.Style.whiteLarge
            addSubview(activityView!)
            
            let labelReadyRect = CGRect(x: activityView!.x + activityView!.width + 10, y: activityView!.y, width: 100, height: 30);
            self.labelReadying = UILabel(frame: labelReadyRect)
            labelReadying?.text = readyStr
            labelReadying?.backgroundColor = UIColor.clear
            labelReadying?.textColor = UIColor.white
            labelReadying?.font = UIFont.systemFont(ofSize: 18.0)
            addSubview(labelReadying!)
        }
        addSubview(labelReadying!)
        activityView?.startAnimating()
    }
    
    func deviceStopReadying() {
        if activityView != nil {
            activityView?.stopAnimating()
            activityView?.removeFromSuperview()
            labelReadying?.removeFromSuperview()
            activityView = nil
            labelReadying = nil
        }
    }

}
