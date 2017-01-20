//
//  ViewController.swift
//  SnapChat_Login&Register
//
//  Created by HEJIE on 14/09/2016.
//  Copyright © 2016 HEJIE. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet var loginUsername: UITextField!
    @IBOutlet var loginPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loginUsername.delegate = self
        loginPassword.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        
        let loginuser = loginUsername.text;
        let loginuserpassword = loginPassword.text;
        
        let usernameStored = NSUserDefaults.standardUserDefaults().stringForKey("username");
        let userPasswordStored = NSUserDefaults.standardUserDefaults().stringForKey("password");
        
        if(usernameStored == loginuser || loginuser == ""){
            if(userPasswordStored == loginuserpassword || loginuserpassword == ""){
                //login成功
                self.performSegueWithIdentifier("FromLoginToMainpage", sender: self)
                
            }
        }else{
            displayAlertMessage("Username and password do not match!");
            return;
        }
        
    }
    func displayAlertMessage(userMessage:String ){
        
        var myAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title:"ok", style: UIAlertActionStyle.Default, handler: nil);
        
        myAlert.addAction(okAction);
        
        self.presentViewController(myAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue){}
    
    /**
     * Called when 'return' key pressed. return NO to ignore.
     */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /**
     * Called when the user click on the view (outside the UITextField).
     */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

}

