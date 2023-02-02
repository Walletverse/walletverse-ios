//
//  ZGScanWrapper.swift
//  Walletverse
//
//  Created by Ky on 2022/9/29.
//  Copyright © 2022 Walletverse. All rights reserved.
//

import UIKit
import AVFoundation
import CoreImage.CIFilterBuiltins

public struct ZGScanResult {
    public var strScanned:String? = ""
    public var imgScanned:UIImage?
    public var strBarCodeType:String? = ""
    public var arrayCorner:[AnyObject]?
    
    public init(str:String?,img:UIImage?,barCodeType:String?,corner:[AnyObject]?) {
        self.strScanned = str
        self.imgScanned = img
        self.strBarCodeType = barCodeType
        self.arrayCorner = corner
    }
}

class ZGScanWrapper: NSObject,AVCaptureMetadataOutputObjectsDelegate {
    let device = AVCaptureDevice.default(for: AVMediaType.video)
    var input:AVCaptureDeviceInput?
    var output:AVCaptureMetadataOutput
    
    let session = AVCaptureSession()
    var previewLayer:AVCaptureVideoPreviewLayer?
    var stillImageOutput:AVCaptureStillImageOutput?
    
    var arrayResult:[ZGScanResult] = [];
    var successBlock:([ZGScanResult]) -> Void
    var isNeedCaptureImage:Bool
    var isNeedScanResult:Bool = true
    
    init( videoPreView:UIView,objType:[AVMetadataObject.ObjectType] = [(AVMetadataObject.ObjectType.qr as NSString) as AVMetadataObject.ObjectType],isCaptureImg:Bool,cropRect:CGRect=CGRect.zero,success:@escaping ( ([ZGScanResult]) -> Void) ) {
        if let device = device {
            do {
                input = try AVCaptureDeviceInput(device: device)
            } catch let error as NSError {
                print("AVCaptureDeviceInput(): \(error)")
            }
        }
        successBlock = success
        output = AVCaptureMetadataOutput()
        isNeedCaptureImage = isCaptureImg
        stillImageOutput = AVCaptureStillImageOutput();
        super.init()
        
        if device == nil || input == nil {
            return
        }
        if session.canAddInput(input!) {
            session.addInput(input!)
        }
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        if session.canAddOutput(stillImageOutput!) {
            session.addOutput(stillImageOutput!)
        }
        let outputSettings:Dictionary = [AVVideoCodecJPEG:AVVideoCodecKey]
        stillImageOutput?.outputSettings = outputSettings
        session.sessionPreset = AVCaptureSession.Preset.high
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = objType
        if !cropRect.equalTo(CGRect.zero) {
            output.rectOfInterest = cropRect
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        var frame:CGRect = videoPreView.frame
        frame.origin = CGPoint.zero
        previewLayer?.frame = frame
        
        videoPreView.layer .insertSublayer(previewLayer!, at: 0)
        
        if (device!.isFocusPointOfInterestSupported && device!.isFocusModeSupported(AVCaptureDevice.FocusMode.continuousAutoFocus)) {
            do {
                try input?.device.lockForConfiguration()
                input?.device.focusMode = AVCaptureDevice.FocusMode.continuousAutoFocus
                input?.device.unlockForConfiguration()
            } catch let error as NSError {
                print("device.lockForConfiguration(): \(error)")
            }
        }
    }
    
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureOutput(output, didOutputMetadataObjects: metadataObjects, from: connection)
    }
    
    func start() {
        if !session.isRunning {
            isNeedScanResult = true
            session.startRunning()
        }
    }
    
    func stop() {
        if session.isRunning {
            isNeedScanResult = false
            session.stopRunning()
        }
    }
    
    open func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if !isNeedScanResult {
            return
        }
        isNeedScanResult = false
        arrayResult.removeAll()
        for current:Any in metadataObjects {
            if (current as AnyObject).isKind(of: AVMetadataMachineReadableCodeObject.self) {
                let code = current as! AVMetadataMachineReadableCodeObject
                let codeType = code.type
                let codeContent = code.stringValue
                arrayResult.append(ZGScanResult(str: codeContent, img: UIImage(), barCodeType: codeType.rawValue, corner: code.corners as [AnyObject]?))
            }
        }
        if arrayResult.count > 0 {
            if isNeedCaptureImage {
                captureImage()
            } else {
                stop()
                successBlock(arrayResult)
            }
        } else {
            isNeedScanResult = true
        }
    }
    
    open func captureImage() {
        let stillImageConnection:AVCaptureConnection? = connectionWithMediaType(mediaType: AVMediaType.video as AVMediaType, connections: (stillImageOutput?.connections)! as [AnyObject])
        stillImageOutput?.captureStillImageAsynchronously(from: stillImageConnection!, completionHandler: { (imageDataSampleBuffer, error) -> Void in
            self.stop()
            if imageDataSampleBuffer != nil {
                let imageData: Data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer!)!
                let scanImg:UIImage? = UIImage(data: imageData)
                for idx in 0...self.arrayResult.count-1 {
                    self.arrayResult[idx].imgScanned = scanImg
                }
            }
            self.successBlock(self.arrayResult)
        })
    }
    
    open func connectionWithMediaType(mediaType:AVMediaType, connections:[AnyObject]) -> AVCaptureConnection? {
        for connection:AnyObject in connections {
            let connectionTmp:AVCaptureConnection = connection as! AVCaptureConnection
            for port:Any in connectionTmp.inputPorts {
                if (port as AnyObject).isKind(of: AVCaptureInput.Port.self) {
                    let portTmp:AVCaptureInput.Port = port as! AVCaptureInput.Port
                    if portTmp.mediaType == mediaType {
                        return connectionTmp
                    }
                }
            }
        }
        return nil
    }
    
    open func changeScanRect(cropRect:CGRect) {
        stop()
        output.rectOfInterest = cropRect
        start()
    }
    
    open func changeScanType(objType:[AVMetadataObject.ObjectType]) {
        output.metadataObjectTypes = objType
    }
    
    open func isGetFlash()->Bool {
        if (device != nil &&  device!.hasFlash && device!.hasTorch) {
            return true
        }
        return false
    }
    
    open func setTorch(torch:Bool) {
        if isGetFlash() {
            do {
                try input?.device.lockForConfiguration()
                input?.device.torchMode = torch ? AVCaptureDevice.TorchMode.on : AVCaptureDevice.TorchMode.off
                input?.device.unlockForConfiguration()
            } catch let error as NSError {
                print("device.lockForConfiguration(): \(error)")
            }
        }
    }
    
    open func changeTorch() {
        if isGetFlash() {
            do {
                try input?.device.lockForConfiguration()
                var torch = false
                if input?.device.torchMode == AVCaptureDevice.TorchMode.on {
                    torch = false
                } else if input?.device.torchMode == AVCaptureDevice.TorchMode.off {
                    torch = true
                }
                input?.device.torchMode = torch ? AVCaptureDevice.TorchMode.on : AVCaptureDevice.TorchMode.off
                input?.device.unlockForConfiguration()
            } catch let error as NSError {
                print("device.lockForConfiguration(): \(error)")
            }
        }
    }
    
    static func defaultMetaDataObjectTypes() ->[AVMetadataObject.ObjectType] {
        var types =
            [AVMetadataObject.ObjectType.qr,
             AVMetadataObject.ObjectType.upce,
             AVMetadataObject.ObjectType.code39,
             AVMetadataObject.ObjectType.code39Mod43,
             AVMetadataObject.ObjectType.ean13,
             AVMetadataObject.ObjectType.ean8,
             AVMetadataObject.ObjectType.code93,
             AVMetadataObject.ObjectType.code128,
             AVMetadataObject.ObjectType.pdf417,
             AVMetadataObject.ObjectType.aztec
        ]
        
        types.append(AVMetadataObject.ObjectType.interleaved2of5)
        types.append(AVMetadataObject.ObjectType.itf14)
        types.append(AVMetadataObject.ObjectType.dataMatrix)
        return types as [AVMetadataObject.ObjectType]
    }
    
    static func isSysIos8Later()->Bool {
        if #available(iOS 8, *) {
            return true;
        }
        return false
    }
    
    static public func recognizeQRImage(image:UIImage) ->[ZGScanResult] {
        var returnResult:[ZGScanResult]=[]
        
        if ZGScanWrapper.isSysIos8Later() {
            let detector:CIDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])!
            let img = CIImage(cgImage: (image.cgImage)!)
            let features:[CIFeature]? = detector.features(in: img, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
            if( features != nil && (features?.count)! > 0) {
                let feature = features![0]
                if feature.isKind(of: CIQRCodeFeature.self) {
                    let featureTmp:CIQRCodeFeature = feature as! CIQRCodeFeature
                    let scanResult = featureTmp.messageString
                    let result = ZGScanResult(str: scanResult, img: image, barCodeType: AVMetadataObject.ObjectType.qr.rawValue,corner: nil)
                    returnResult.append(result)
                }
            }
        }
        return returnResult
    }
    
    static public func createCode( codeType:String, codeString:String, size:CGSize,qrColor:UIColor,bkColor:UIColor )->UIImage? {
        let stringData = codeString.data(using: String.Encoding.utf8)
        let qrFilter = CIFilter(name: codeType)
        qrFilter?.setValue(stringData, forKey: "inputMessage")
        qrFilter?.setValue("H", forKey: "inputCorrectionLevel")
        let colorFilter = CIFilter(name: "CIFalseColor", parameters: ["inputImage":qrFilter!.outputImage!,"inputColor0":CIColor(cgColor: qrColor.cgColor),"inputColor1":CIColor(cgColor: bkColor.cgColor)])
        let qrImage = colorFilter!.outputImage!
        let cgImage = CIContext().createCGImage(qrImage, from: qrImage.extent)!
        UIGraphicsBeginImageContext(size);
        let context = UIGraphicsGetCurrentContext()!;
        context.interpolationQuality = CGInterpolationQuality.none;
        context.scaleBy(x: 1.0, y: -1.0);
        context.draw(cgImage, in: context.boundingBoxOfClipPath)
        let codeImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return codeImage
    }
    
    static public func createCode128(  codeString:String, size:CGSize,qrColor:UIColor,bkColor:UIColor )->UIImage? {
        let stringData = codeString.data(using: String.Encoding.utf8)
        let qrFilter = CIFilter(name: "CICode128BarcodeGenerator")
        qrFilter?.setDefaults()
        qrFilter?.setValue(stringData, forKey: "inputMessage")
        let outputImage:CIImage? = qrFilter?.outputImage
        let context = CIContext()
        let cgImage = context.createCGImage(outputImage!, from: outputImage!.extent)
        let image = UIImage(cgImage: cgImage!, scale: 1.0, orientation: UIImage.Orientation.up)
        let scaleRate:CGFloat = 20.0
        let resized = resizeImage(image: image, quality: CGInterpolationQuality.none, rate: scaleRate)
        return resized;
    }
    
    static func getConcreteCodeImage(srcCodeImage:UIImage,codeResult:ZGScanResult)->UIImage? {
        let rect:CGRect = getConcreteCodeRectFromImage(srcCodeImage: srcCodeImage, codeResult: codeResult)
        if rect.isEmpty {
            return nil
        }
        let img = imageByCroppingWithStyle(srcImg: srcCodeImage, rect: rect)
        if img != nil {
            let imgRotation = imageRotation(image: img!, orientation: UIImage.Orientation.right)
            return imgRotation
        }
        return nil
    }
    
    static public func getConcreteCodeImage(srcCodeImage:UIImage,rect:CGRect)->UIImage? {
        if rect.isEmpty {
            return nil
        }
        let img = imageByCroppingWithStyle(srcImg: srcCodeImage, rect: rect)
        if img != nil {
            let imgRotation = imageRotation(image: img!, orientation: UIImage.Orientation.right)
            return imgRotation
        }
        return nil
    }
    
    static public func getConcreteCodeRectFromImage(srcCodeImage:UIImage,codeResult:ZGScanResult)->CGRect {
        if (codeResult.arrayCorner == nil || (codeResult.arrayCorner?.count)! < 4) {
            return CGRect.zero
        }
        let corner:[[String:Float]] = codeResult.arrayCorner  as! [[String:Float]]
        let dicTopLeft     = corner[0]
        let dicTopRight    = corner[1]
        let dicBottomRight = corner[2]
        let dicBottomLeft  = corner[3]
        let xLeftTopRatio:Float = dicTopLeft["X"]!
        let yLeftTopRatio:Float  = dicTopLeft["Y"]!
        let xRightTopRatio:Float = dicTopRight["X"]!
        let yRightTopRatio:Float = dicTopRight["Y"]!
        let xBottomRightRatio:Float = dicBottomRight["X"]!
        let yBottomRightRatio:Float = dicBottomRight["Y"]!
        let xLeftBottomRatio:Float = dicBottomLeft["X"]!
        let yLeftBottomRatio:Float = dicBottomLeft["Y"]!
        
        let xMinLeft = CGFloat( min(xLeftTopRatio, xLeftBottomRatio) )
        let xMaxRight = CGFloat( max(xRightTopRatio, xBottomRightRatio) )
        let yMinTop = CGFloat( min(yLeftTopRatio, yRightTopRatio) )
        let yMaxBottom = CGFloat ( max(yLeftBottomRatio, yBottomRightRatio) )
        let imgW = srcCodeImage.size.width
        let imgH = srcCodeImage.size.height
        
        let rect = CGRect(x: xMinLeft * imgH, y: yMinTop*imgW, width: (xMaxRight-xMinLeft)*imgH, height: (yMaxBottom-yMinTop)*imgW)
        return rect
    }

    static public func addImageLogo(srcImg:UIImage,logoImg:UIImage,logoSize:CGSize )->UIImage {
        UIGraphicsBeginImageContext(srcImg.size);
        srcImg.draw(in: CGRect(x: 0, y: 0, width: srcImg.size.width, height: srcImg.size.height))
        let rect = CGRect(x: srcImg.size.width/2 - logoSize.width/2, y: srcImg.size.height/2-logoSize.height/2, width:logoSize.width, height: logoSize.height);
        logoImg.draw(in: rect)
        let resultingImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return resultingImage!;
    }
    
    static func resizeImage(image:UIImage,quality:CGInterpolationQuality,rate:CGFloat)->UIImage? {
        var resized:UIImage?;
        let width    = image.size.width * rate;
        let height   = image.size.height * rate;
        UIGraphicsBeginImageContext(CGSize(width: width, height: height));
        let context = UIGraphicsGetCurrentContext();
        context!.interpolationQuality = quality;
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        resized = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return resized;
    }
    
    static func imageByCroppingWithStyle(srcImg:UIImage,rect:CGRect)->UIImage? {
        let imageRef = srcImg.cgImage
        let imagePartRef = imageRef!.cropping(to: rect)
        let cropImage = UIImage(cgImage: imagePartRef!)
        
        return cropImage
    }
    
    static func imageRotation(image:UIImage,orientation:UIImage.Orientation)->UIImage {
        var rotate:Double = 0.0;
        var rect:CGRect;
        var translateX:CGFloat = 0.0;
        var translateY:CGFloat = 0.0;
        var scaleX:CGFloat = 1.0;
        var scaleY:CGFloat = 1.0;
        switch (orientation) {
        case UIImage.Orientation.left:
            rotate = .pi/2;
            rect = CGRect(x: 0, y: 0, width: image.size.height, height: image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImage.Orientation.right:
            rotate = 3 * .pi/2;
            rect = CGRect(x: 0, y: 0, width: image.size.height, height: image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImage.Orientation.down:
            rotate = .pi;
            rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height);
            translateX = 0;
            translateY = 0;
            break;
        }
        UIGraphicsBeginImageContext(rect.size);
        let context = UIGraphicsGetCurrentContext()!;
        context.translateBy(x: 0.0, y: rect.size.height);
        context.scaleBy(x: 1.0, y: -1.0);
        context.rotate(by: CGFloat(rotate));
        context.translateBy(x: translateX, y: translateY);
        context.scaleBy(x: scaleX, y: scaleY)
        context.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height))
        let newPic = UIGraphicsGetImageFromCurrentImageContext()
        return newPic!
    }

}
