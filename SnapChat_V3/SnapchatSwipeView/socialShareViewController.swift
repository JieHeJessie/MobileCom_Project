//
//  ViewController.swift
//  EasyShare
//
//  Created by Jiachen Guo on 16/10/12.
//  Copyright © 2016年 Jiachen Guo. All rights reserved.
//

import UIKit
import Social

class socialShareViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var noteTextview: UITextView!
    
    var image: UIImage!
    
    var defaultContent:String = "Add me on Snapchat! Username: \(User.currentUser!.username)"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(123111)
        configureNoteTextView()
        
        noteTextview.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: IBAction Function
    @IBAction func showShareOptions(sender: AnyObject) {
        // Dismiss the keyboard if it's visible.
        if noteTextview.isFirstResponder() {
            noteTextview.resignFirstResponder()
        }
        
        let actionSheet = UIAlertController(title: "", message: "Share your Story", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let moreAction = UIAlertAction(title: "Social Share", style: UIAlertActionStyle.Default) { (action) -> Void in
            
            let activityViewController: UIActivityViewController
            if self.image != nil{
                //activietyItems 可添加默认内容，文字，图片
                activityViewController = UIActivityViewController(activityItems: ["\(self.defaultContent)\n\(self.noteTextview.text)",self.image], applicationActivities: nil)
            }else {
                //activietyItems 可添加默认内容，文字，图片
                activityViewController = UIActivityViewController(activityItems: ["\(self.defaultContent)\n\(self.noteTextview.text)"], applicationActivities: nil)
            }
            
            
            activityViewController.excludedActivityTypes = [UIActivityTypeMail]
            
            self.presentViewController(activityViewController, animated: true, completion: nil)
            
        }
        
        
        let dismissAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            
        }

        actionSheet.addAction(moreAction)
        actionSheet.addAction(dismissAction)
        
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    
    // MARK: Custom Functions
    func configureNoteTextView() {
        noteTextview.layer.cornerRadius = 8.0
        noteTextview.layer.borderColor = UIColor(white: 0.75, alpha: 0.5).CGColor
        noteTextview.layer.borderWidth = 1.2
    }
    
    
    func showAlertMessage(message: String!) {
        let alertController = UIAlertController(title: "EasyShare", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: UITextViewDelegate Functions
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
}

