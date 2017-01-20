//
//  editViewController.swift
//  SnapChat-V3
//
//  Created by lavintyben on 16/10/10.
//  Copyright © 2016年 Brendan Lee. All rights reserved.
//

import UIKit

class editViewControllerInShake: UIViewController {
    
    var shakeShakeText: String?
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        textField.delegate = self
    }
    
    // Reset the textField
    @IBAction func reset(sender: UIButton) {
        textField.text = ""
    }

// -----------------------------Submittion------------------------------
    @IBAction func submit(sender: UIButton) {
        if let shakeShakeText = textField.text {
            
            // Create the shakeShake Message
            let newShakeShakeMessage = shakeShakeMessage(username: User.currentUser!.username, content: shakeShakeText)
            
            // Send the new message to the server
            // ...
            
            // Send the success message
            let myAlert = UIAlertController(title:"Alert", message: "Submit Successfully", preferredStyle: UIAlertControllerStyle.Alert);
            
            let okAction = UIAlertAction(title:"ok", style: UIAlertActionStyle.Default, handler: {
                (alert: UIAlertAction) in
                
                self.navigationController?.popViewControllerAnimated(true)
                
            });
            
            myAlert.addAction(okAction);
            self.presentViewController(myAlert, animated: true, completion: nil)
            
        }else{
            displayAlertMessage("The message cannot be empty")
        }
    }
}

// -----------------------------Text Field------------------------------
extension editViewControllerInShake: UITextFieldDelegate{
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func displayAlertMessage(userMessage:String ){
        
        let myAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title:"ok", style: UIAlertActionStyle.Default, handler: nil);
        
        myAlert.addAction(okAction);
        
        self.presentViewController(myAlert, animated: true, completion: nil)
        
    }
    
    
}