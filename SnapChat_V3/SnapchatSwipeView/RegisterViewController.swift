//
//  RegisterViewController.swift
//  SnapChat_Login&Register
//
//  Created by HEJIE on 14/09/2016.
//  Copyright © 2016 HEJIE. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate{
    //属性
    @IBOutlet var usernameTextfield: UITextField!
    @IBOutlet var nicknameTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    @IBOutlet var repeatpasswordTextfield: UITextField!
    @IBOutlet var phonenumberTextfield: UITextField!
    @IBOutlet var birthdayTextfield: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        usernameTextfield.delegate = self
        nicknameTextfield.delegate = self
        passwordTextfield.delegate = self
        repeatpasswordTextfield.delegate = self
        phonenumberTextfield.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func RegisterButtonTapped(sender: AnyObject) {
        
        //取text field的值
        let username = usernameTextfield.text;
        let nickname = nicknameTextfield.text;
        let password = passwordTextfield.text;
        let repeatpassword = repeatpasswordTextfield.text;
        let phonenumber = phonenumberTextfield.text;
        
        let birthday = birthdayTextfield.date
        print (birthday)
        
        //判断各个输入是否为空
        if(username!.isEmpty || nickname!.isEmpty || password!.isEmpty || repeatpassword!.isEmpty || phonenumber!.isEmpty){
            //显示警告信息
            displayAlertMessage("All fields are required!");
            return;
        }
        
        //判断密码是否相同
        if(password != repeatpassword){
            //显示警告信息
            displayAlertMessage("Password do not match!");
        }
        
        //存储信息到本地
        NSUserDefaults.standardUserDefaults().setObject(username, forKey: "username");
        NSUserDefaults.standardUserDefaults().setObject(nickname, forKey: "nickname");
        NSUserDefaults.standardUserDefaults().setObject(password, forKey: "password");
        NSUserDefaults.standardUserDefaults().setObject(phonenumber, forKey: "phonenumber");
        
        //显示注册成功
        var myAlert = UIAlertController(title:"Alert", message:"Registration is successful, thank you!", preferredStyle: UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title:"ok", style: UIAlertActionStyle.Default){
            action in
            self.dismissViewControllerAnimated(true, completion: nil);
        }
        
        myAlert.addAction(okAction);
        
        self.presentViewController(myAlert, animated: true, completion: nil);
    }
    //显示错误信息
    func displayAlertMessage(userMessage:String ){
        
        var myAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title:"ok", style: UIAlertActionStyle.Default, handler: nil);
        
        myAlert.addAction(okAction);
        
        self.presentViewController(myAlert, animated: true, completion: nil)
        
    }
    
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
