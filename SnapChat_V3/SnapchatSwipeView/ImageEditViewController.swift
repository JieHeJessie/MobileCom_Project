//
//  ImageEditViewController.swift
//  SnapChat-V3
//
//  Created by lavintyben on 16/9/25.
//  Copyright © 2016年 Brendan Lee. All rights reserved.
//

import UIKit
import Foundation

extension UIImage {
    class func imageWithLabel(label: UILabel) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
        label.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}

extension UIView {
    
    func capture() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.frame.size, self.opaque, UIScreen.mainScreen().scale)
        self.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
}

class ImageEditViewController: UIViewController, UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    
    var image:UIImage!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var imageEditView: UIView!
    
    var drawingView: DrawingView!
    
    //创建点
    var location = CGPoint(x: 0, y: 0)
    
    // Array to store items
    var items: [UIView] = [UIView]()
    
    // Initial position when touch on a item
    var initialPosition: CGPoint!
    
    // Trace the current moved item
    var movedItem: UIView?
    
    // Merged image
    var mergedImage: UIImage!
    
    // Parent view controller: CameraViewController
    var _parentViewController: UIViewController!
    
    // Hide the status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the background picture from the segue
        imageView.image = self.image
        
        // Initilize the item if not initialized
        if (items.count == 0){
            
            items.append(logo)
            
        }
        
        textField.delegate = self
        
        timerPicker.delegate = self
        timerPicker.dataSource = self
        
        drawingView = self.view.viewWithTag(200) as! DrawingView
        
    }
    
    //对画面进行单次点击时所触发的函式
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // End the editing of the text field
        self.view.endEditing(true)
        
        // Hide the timer picker view
        self.timerPicker.hidden = true
        
        for touch in (touches ){
            
            let location = touch.locationInView(self.view)
            
            for item in items{
                
                // Record the position and reference of the item if it is toughed
                if item.frame.contains(location){
                    self.initialPosition = location
                    self.movedItem = item
                    
                    //print (movedItem)
                    return
                }
            }
        }
        
        // If no item is selected
        movedItem = nil
    }
    
    //对画面进行拖曳动做时所触发的函式
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // if no item is selected
        if (movedItem == nil){
            return
        }
        
        for touch in (touches){
            // Get the postion of this touch
            let location = touch.locationInView(self.view)
            
            // Set the delta position
            let deltaX: CGFloat = location.x - initialPosition.x
            let deltaY: CGFloat = location.y - initialPosition.y
            
            // Get the original position
            let originalCenterOfX = movedItem!.center.x
            let originalCenterOfY = movedItem!.center.y
            
            // Update the active item's position
            movedItem!.center = CGPoint(x: originalCenterOfX + deltaX, y: originalCenterOfY + deltaY)
            
            // Record the current location as the new initial Position
            initialPosition = location
            
        }
    }

// --------------------------- Button Action -------------------------------
    @IBAction func merge(sender: UIButton) {
        
        // Get the merged image
        mergedImage = imageEditView.capture()

        // Go to the new view controller
        performSegueWithIdentifier("goToSend", sender: self)
    }
    
    @IBAction func switchWriting(sender: UIButton) {
        
        textField.resignFirstResponder()
        
        if (textField.hidden == true){
            
            if (label.hidden == true){
                // Reset when appears
                textField.text = nil
                textField.hidden = false
                
                textField.becomeFirstResponder()
            }
            
        }else{
            
            textField.hidden = true
            
        }
        
        // Reset the label
        label.text = nil
        label.hidden = true
        
    }
    
    @IBAction func switchLogo(sender: UIButton) {
        
        switchHidden(logo)
        
    }
    
    @IBAction func switchDraw(sender: UIButton) {
        
        if (drawingView.userInteractionEnabled == false){
            
            drawingView.userInteractionEnabled = true
            
            sender.backgroundColor = UIColor(white: 1, alpha: 1)
            sender.setTitleColor(UIColor.blackColor(), forState: .Normal)
            
        }else {
            
            drawingView.userInteractionEnabled = false
            //drawingView.resetDrawing()
            
            sender.backgroundColor = UIColor(white: 1, alpha: 0.19)
            sender.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            
            
            
        }
        
    }

// --------------------------- Segue Preparation -------------------------------
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "goToPreview"){
            let imageView = segue.destinationViewController.view.viewWithTag(100) as! UIImageView
            imageView.image = self.mergedImage
        }else if (segue.identifier == "goToSend"){
            let _sendViewController = segue.destinationViewController as! sendViewController
            
            // send the message content to the send view controller
            _sendViewController.image = self.mergedImage
            _sendViewController.timer = selectedTimerOption
        
        }
        
        
        
        
    }
    
    @IBAction func unwindToEditor(segue: UIStoryboardSegue) {}
    
    /**
     * Called when 'return' key pressed. return NO to ignore.
     */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        // Hide the text field
        textField.hidden = true
        
        // Set the label
        label.text = textField.text
        
        // Label appears
        label.hidden = false
        
        // Put the label into item array
        items.append(label)
        
        return true
    }
    
// -------------------------------------- timer setting --------------------
    @IBOutlet weak var timerPicker: UIPickerView!
    @IBOutlet weak var timerButton: UIButton!
    
    let timerOptions = ["1s","2s","3s","4s","5s","6s","7s","8s","9s","10s"]
    
    // Default 5s
    var selectedTimerOption: String = "5"
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return timerOptions[row]
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timerOptions.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @IBAction func timerSetting(sender: UIButton) {

        self.timerPicker.hidden = false
        
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedTimerOption = timerOptions[row]
        timerButton.setTitle(selectedTimerOption, forState: .Normal)
        
    }
    
// -------------------------------------- Store image into  memory --------------------
    @IBAction func storeIntoMemory(sender: UIButton) {
        
        // Get the current image
        mergedImage = imageEditView.capture()
        
        // Send the image to memory and update it
        storeIntoMemoryWithImage(mergedImage)
        
        // Alert box
        let alert = UIAlertController(title: "", message: "Store Memory Success", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

// -------------------------------------- Store image into  Story --------------------
    @IBAction func storeIntoStory(sender: UIButton) {
        
        // Get the current image
        mergedImage = imageEditView.capture()
        
        // Get the current time
        let time:String = getCurrentTimeString()
        
        // Send the image to memory and update it
        storeIntoStoryWithImage(mergedImage, timeString:time)
        
        // Alert box
        let alert = UIAlertController(title: "", message: "Store Story Success", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

// -------------------------------------- Delete picture(only userful in the editor of snap view controller) --------------------
    var indexPath: NSIndexPath!
    
    @IBAction func deleteItemInCollectionView(sender: UIButton) {
        let snapViewController = _parentViewController as! SnapViewController
        
        snapViewController.images.removeAtIndex(indexPath.row)
        snapViewController.collectionView.reloadData()
        
        // Go back to snap View Controller
        performSegueWithIdentifier("unwindToSnap", sender: self)
    }
    
// -------------------------------------- Auxiliary function --------------------
    func switchHidden (UIItem: UIView){
        
        if (UIItem.hidden == true){
        
            UIItem.hidden = false
            
        }else{
            
            UIItem.hidden = true
        
        }
    }
    
    func storeIntoMemoryWithImage(image:UIImage){
        // Nevigation
        let verticalScrollView = _parentViewController.parentViewController
        let memoryViewController = verticalScrollView?.childViewControllers[2]
        let pageViewController = memoryViewController?.childViewControllers[0] as! PageViewController
        
        let snapViewController = pageViewController.snapViewController as! SnapViewController
        
        // Add the new image into the content
        snapViewController.images.append(image)
        
        // Update the content in the collection view
        snapViewController.reloadCollectionView()
    
    }
    
    func storeIntoStoryWithImage(image:UIImage, timeString:String){
        
        let newStoryMessage = StoryMessage(content: "", receivingTime: timeString, sender: User.currentUser,image: image)
        
        StoryMessages.appendWithNewStoryMessage(newStoryMessage)
    }
    
    func getCurrentTimeString() -> String{
        let currentDateTime = NSDate()
        
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        formatter.dateStyle = .ShortStyle
        
        return formatter.stringFromDate(currentDateTime)
    }
}
