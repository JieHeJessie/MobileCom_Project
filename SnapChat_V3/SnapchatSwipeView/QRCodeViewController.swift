//
//  QRCodeViewController.swift
//  二维码扫描
//
//

import UIKit
import AVFoundation

class QRCodeViewController: UIViewController {
    
    @IBOutlet weak var scanLineConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var containerHeihhtCons: NSLayoutConstraint!

    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var scanImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startAnimation()
        
        startScan()
    }
    
    func startAnimation() {
        UIView.animateWithDuration(2, delay: 0, options: .Repeat, animations: {
            
            self.scanLineConstraint.constant = -self.containerHeihhtCons.constant
            self.scanImageView.layoutIfNeeded()

            
            self.scanLineConstraint.constant = 0
            self.scanImageView.layoutIfNeeded()
            
            }, completion: nil)
    }
    
    func startScan() {
        
        if !session.canAddInput(avcapInput) || !session.canAddOutput(avcapOutput){
            return
        }
        
        session.addInput(avcapInput)
        session.addOutput(avcapOutput)
        
        avcapOutput.metadataObjectTypes = avcapOutput.availableMetadataObjectTypes
        
        //这个是只可读的
        avcapOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        
        view.layer.insertSublayer(previewLayer, atIndex: 0)
        
        previewLayer.addSublayer(drawlayer)
        
        session.startRunning()
        
    }
    //会话
    private lazy var session:AVCaptureSession = {
        let session = AVCaptureSession()
        return session
    }()
    
    //拿到输入设备
    private lazy var avcapInput:AVCaptureDeviceInput? = {
        // 获取摄像头
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do{
            // 创建输入对象
            let avcapOut = try AVCaptureDeviceInput(device: device)
            return avcapOut
        }catch{
            print(error)
            return nil
        }
    }()
    
    //拿到输出对象
    private lazy var avcapOutput:AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    
    //创建预览图层
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.session)
        layer.frame = UIScreen.mainScreen().bounds
        return layer
    }()
    
    private lazy var drawlayer: CALayer = {
        let layer = CALayer()
        layer.frame = UIScreen.mainScreen().bounds
        return layer
    }()
}


extension QRCodeViewController:AVCaptureMetadataOutputObjectsDelegate
{
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!)
    {
        //print(metadataObjects)
        clearlayer()
        //UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.blackColor()]
        navigationItem.title = metadataObjects.last?.stringValue
        for object in metadataObjects{
            if object is AVMetadataMachineReadableCodeObject {
                let codeobject = previewLayer.transformedMetadataObjectForMetadataObject(object as! AVMetadataObject) as!AVMetadataMachineReadableCodeObject
                
                drawCorners(codeobject)
                
                // Create a aleart
                let myAlert = UIAlertController(title:"Note", message: "Do you want to add \(navigationItem.title!) as friends??", preferredStyle: UIAlertControllerStyle.Alert);
                
                let okAction = UIAlertAction(title:"Yes", style: UIAlertActionStyle.Default, handler: {
                    (alert: UIAlertAction) in
                    
                    // Send data to server
                    // ....
                    print("Remember to set the code in the QRCodeViewController when scan a code successfully")
                
                
                });
                let noAction = UIAlertAction(title:"no", style: UIAlertActionStyle.Default, handler: nil);
                
                myAlert.addAction(okAction);
                myAlert.addAction(noAction);
            
                self.presentViewController(myAlert, animated: true, completion: nil)
                
            }
        }
    }
    
    func drawCorners(codeobject:AVMetadataMachineReadableCodeObject)
    {
        let layer = CAShapeLayer()
        layer.lineWidth = 2
        layer.strokeColor = UIColor.greenColor().CGColor
        layer.fillColor = UIColor.clearColor().CGColor
        
        let path = UIBezierPath()
        var point = CGPointZero
        var index = 0
        
        CGPointMakeWithDictionaryRepresentation((codeobject.corners[index++] as! CFDictionaryRef), &point)
        path.moveToPoint(point)
        
        while index < codeobject.corners.count {
            CGPointMakeWithDictionaryRepresentation((codeobject.corners[index++] as! CFDictionaryRef), &point)
            path.addLineToPoint(point)
        }
        
        path.closePath()
        
        layer.path = path.CGPath
        
        drawlayer.addSublayer(layer)
    }
    
    func clearlayer()
    {
        if drawlayer.sublayers == nil || drawlayer.sublayers?.count == 0 {
            return
        }
        
        for subLayer in drawlayer.sublayers! {
            subLayer.removeFromSuperlayer()
        }
    }
}