//
//  CameraViewController.swift
//  SnapChat-V3
//
//  Created by lavintyben on 16/9/17.
//  Copyright © 2016年 Brendan Lee. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    // camera capture related properties
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    // Temp screenshot of photo
    @IBOutlet weak var tempImageView: UIImageView!
    // Continuous view of camera view
    @IBOutlet weak var cameraView: UIView!
    // Detect whether has taken a photo
    var didTakePhoto = Bool()
    
    // The button to control the switch of flash light
    @IBOutlet weak var flashButton: UIButton!
    // Whether or not need the flash when take a photo
    var isFlash: Bool = false
    
    // The button to control using which cam(front or back)
    @IBOutlet weak var camButton: UIButton!
    var isFrontCam: Bool = false
    
    // Image object
    var tempImage: UIImage?
    
// ------------------- Initialization of view  ------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }
    
    // Hide the status bar (not working)
    override func prefersStatusBarHidden() -> Bool {
        print("prefersStatusBarHidden method is called")
        return true
    }
    
// ------------------- How to set the camera view ------------------------
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        previewLayer?.frame = cameraView.bounds
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Do not need to load again if already load it
        
        if (captureSession == nil){
        // Initial the session
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = AVCaptureSessionPresetHigh
        
        let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        //var error: NSError?
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            
            if  captureSession?.canAddInput(input) != nil{
                
                captureSession?.addInput(input)
                
                // Set the setting of image output
                stillImageOutput = AVCaptureStillImageOutput()
                stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
                
                // Add the preview layer into the cameraView and also activate the output
                if captureSession?.canAddOutput(stillImageOutput) != nil{
                    captureSession?.addOutput(stillImageOutput)
                    
                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    previewLayer?.videoGravity = AVLayerVideoGravityResizeAspect
                    previewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.Portrait
                    cameraView.layer.addSublayer(previewLayer!)
                    captureSession?.startRunning()
                    
                }
                
            }
            
        }catch{
            
        }
            
        }
    }
    
// ------------------- How to take a photo ------------------------
    func didPressTakePhoto(){
        
        if let videoConnection = stillImageOutput?.connectionWithMediaType(AVMediaTypeVideo){
            
            videoConnection.videoOrientation = AVCaptureVideoOrientation.Portrait
            
            
            self.toggleFlash()
            
            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {
                (sampleBuffer,error) in
                
                if sampleBuffer != nil {
                    
                    
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProviderCreateWithCFData(imageData)
                    let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, .RenderingIntentDefault)
                    
                    // Get the screenshot and output according to which cam is being used
                    let image: UIImage
                    if !self.isFrontCam{
                        
                        image = UIImage(CGImage: cgImageRef!,scale:1.0 ,orientation: UIImageOrientation.Right)
                        
                    }else{
                        
                        image = UIImage(CGImage: cgImageRef!,scale:1.0 ,orientation: UIImageOrientation.LeftMirrored)
                        
                    }
                    
                    // Save the photo into the photo album
                    //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    
                    self.tempImage = image
                    //self.tempImageView.image = image
                    //self.tempImageView.hidden = false
                    
                    self.performSegueWithIdentifier("goToImageEdit", sender: self)
                    
                }
            })
        }

    }
    
// ------------------- How to switch and activate the flash light when take photo ------------------------
    @IBAction func switchFlash(sender: UIButton) {
        
        if isFlash {
            
            isFlash = false
            flashButton.setTitle("Flash is off", forState: .Normal)
            
        }else {
            
            isFlash = true
            flashButton.setTitle("Flash is on", forState: .Normal)
            
        }
        
    }
    
    // Open the flash when take a photo
    func toggleFlash (){
        
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        do {
            if (device.hasFlash){
                
                try device.lockForConfiguration()
                
                if (isFlash){
                    
                    device.flashMode = AVCaptureFlashMode.On
                    
                } else {
                    
                    device.flashMode = AVCaptureFlashMode.Off
                    
                }
                
                device.unlockForConfiguration()
                
            }
        }catch {
            
        }
    }

// ------------------- Button Action ------------------------
    @IBAction func takePhoto(sender: UIButton) {
        didPressTakePhoto()
    }
    
    // Switch the cam
    @IBAction func switchCam(sender: UIButton) {
        
        captureSession?.beginConfiguration()
        
        // Get the current input
        let currentInput = captureSession?.inputs[0] as! AVCaptureInput
        // Remove the current input
        captureSession?.removeInput(currentInput)
        
        do {
            if isFrontCam == false{
                
                let frontCamera = AVCaptureDevice.devices().filter({$0.position == AVCaptureDevicePosition.Front}).first as! AVCaptureDevice
                let frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
                
                isFrontCam = true
                camButton.setTitle("Front Cam", forState: .Normal)
                
                captureSession?.addInput(frontCameraInput)
                
            }else {
                
                let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
                let backCameraInput = try AVCaptureDeviceInput(device: backCamera)
                
                isFrontCam = false
                camButton.setTitle("Back Cam", forState: .Normal)
                
                captureSession?.addInput(backCameraInput)
                
            }
            
        }catch {
            
        }
        
        captureSession?.commitConfiguration()
        
    }
    
// ------------------- Segue Preparation ------------------------
    // Send image data to the new destination of view controller(ImageEditViewController)
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "goToImageEdit"){
            /*
            let imageView: UIImageView = segue.destinationViewController.view.viewWithTag(100) as! UIImageView
            */
            
            let destination = segue.destinationViewController as!ImageEditViewController
            
            destination.image = self.tempImage
            destination._parentViewController = self
            
        }
    }
    
    @IBAction func unwindToCamera(segue: UIStoryboardSegue){
    }
}
