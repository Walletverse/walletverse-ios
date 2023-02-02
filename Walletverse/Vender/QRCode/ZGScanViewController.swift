//
//  ZGScanViewController.swift
//  Walletverse
//
//  Created by Ky on 2022/9/29.
//  Copyright © 2022 Walletverse. All rights reserved.
//

import UIKit
import AVFoundation

public protocol ZGScanViewControllerDelegate: class {
    func scanFinished(scanResult: ZGScanResult, error: String?)
}

public protocol QRRectDelegate {
    func drawwed()
}

class ZGScanViewController: BaseViewController, UINavigationControllerDelegate {
    open weak var scanResultDelegate: ZGScanViewControllerDelegate?
    open var delegate: QRRectDelegate?
    open var scanObj: ZGScanWrapper?
    open var scanStyle: ZGScanViewStyle? = ZGScanViewStyle()
    open var qRScanView: ZGScanView?
    open var isOpenInterestRect = false
    public var arrayCodeType:[AVMetadataObject.ObjectType]?
    public  var isNeedCodeImage = false
    public var readyString:String! = "loading"
    
    lazy var torchIV : UIImageView = {
        return CustomView.imageViewCustom(image: UIImage(named: "assets_torch_close"))
    }()
    
    lazy var torchL : UILabel = {
        return CustomView.labelCustom(text: LocalString("scan_flash_open"), font: FontSystem(size: 12), color: ColorHex(0xffffff), textAlignment: .center)
    }()
    
    lazy var torchBtn : UIButton = {
        return UIButton()
    }()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        // [self.view addSubview:_qRScanView];
        self.view.backgroundColor = UIColor.black
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        
        drawScanView()
        startScan()
    }
    
    open func setNeedCodeImage(needCodeImg:Bool) {
        isNeedCodeImage = needCodeImg;
    }
    
    open func setOpenInterestRect(isOpen:Bool) {
        isOpenInterestRect = isOpen
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        drawScanView()
        perform(#selector(ZGScanViewController.startScan), with: nil, afterDelay: 0.3)
    }
    
    @objc open func startScan() {
        if (scanObj == nil) {
            var cropRect = CGRect.zero
            if isOpenInterestRect {
                cropRect = ZGScanView.getScanRectWithPreView(preView: self.view, style:scanStyle! )
            }
            if arrayCodeType == nil {
                arrayCodeType = [AVMetadataObject.ObjectType.qr as NSString ,AVMetadataObject.ObjectType.ean13 as NSString ,AVMetadataObject.ObjectType.code128 as NSString] as [AVMetadataObject.ObjectType]
            }
            scanObj = ZGScanWrapper(videoPreView: self.view,objType:arrayCodeType!, isCaptureImg: isNeedCodeImage,cropRect:cropRect, success: { [weak self] (arrayResult) -> Void in
                if let strongSelf = self {
                    strongSelf.qRScanView?.stopScanAnimation()
                    strongSelf.handleCodeResult(arrayResult: arrayResult)
                }
            })
        }
        qRScanView?.deviceStopReadying()
        qRScanView?.startScanAnimation()
        scanObj?.start()
    }
    
    open func drawScanView() {
        if qRScanView == nil {
            qRScanView = ZGScanView(frame: self.view.frame,vstyle:scanStyle! )
            self.view.addSubview(qRScanView!)
            delegate?.drawwed()
        }
        qRScanView?.deviceStartReadying(readyStr: readyString)
        
        torchBtn.frame = CGRect(x: (ZSCREENWIDTH - 60)/2, y: ZSCREENHEIGHT - 60 - 80 - ZSCREENBOTTOM, width: 60, height: 60)
        torchIV.frame = CGRect(x: torchBtn.centerX - 15, y: torchBtn.y + 4, width: 30, height: 30)
        view.addSubview(torchIV)
        torchL.frame = CGRect(x: torchBtn.x, y: torchIV.bottom + 5, width: torchBtn.width, height: 17)
        view.addSubview(torchL)
        torchBtn.addTarget(self, action: #selector(torchBtnClick), for: .touchUpInside)
        torchBtn.isSelected = false
        view.addSubview(torchBtn)
    }
    
    open func handleCodeResult(arrayResult:[ZGScanResult]) {
        if let delegate = scanResultDelegate  {
            self.navigationController? .popViewController(animated: true)
            let result:ZGScanResult = arrayResult[0]
            delegate.scanFinished(scanResult: result, error: nil)
        } else {
            for result:ZGScanResult in arrayResult {
                print("%@",result.strScanned ?? "")
            }
            let result:ZGScanResult = arrayResult[0]
            showMsg(title: result.strBarCodeType, message: result.strScanned)
        }
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        qRScanView?.stopScanAnimation()
        scanObj?.stop()
    }
    
    open func openPhotoAlbum() {
        ZGPermissions.authorizePhoto { [weak self] (granted) in
            let picker = UIImagePickerController()
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
            picker.delegate = self;
            picker.allowsEditing = true
            self?.present(picker, animated: true, completion: nil)
        }
    }
    
    func showMsg(title:String?,message:String?) {
        let alertController = UIAlertController(title: nil, message:message, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: UIAlertAction.Style.default) { (alertAction) in
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func torchBtnClick() {
        if torchBtn.isSelected {
            torchIV.image = UIImage(named: "assets_torch_close")
            torchL.text = LocalString("scan_flash_open")
            scanObj?.setTorch(torch: false)
        } else {
            torchIV.image = UIImage(named: "assets_torch_open")
            torchL.text = LocalString("scan_flash_close")
            scanObj?.setTorch(torch: true)
        }
        torchBtn.isSelected = !torchBtn.isSelected
    }
}

extension ZGScanViewController : UIImagePickerControllerDelegate {
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        var image:UIImage? = info[UIImagePickerController.InfoKey.editedImage.rawValue] as? UIImage
        if (image == nil ) {
            image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage
        }
        if(image != nil) {
            let arrayResult = ZGScanWrapper.recognizeQRImage(image: image!)
            if arrayResult.count > 0
            {
                handleCodeResult(arrayResult: arrayResult)
                return
            }
        }
        showMsg(title: nil, message: NSLocalizedString("Identify failed", comment: "Identify failed"))
    }
}
