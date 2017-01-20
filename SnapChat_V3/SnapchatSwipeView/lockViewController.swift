//
//  lockViewController.swift
//  SnapChat-V3
//
//  Created by lavintyben on 16/10/9.
//  Copyright © 2016年 Brendan Lee. All rights reserved.
//

import UIKit

class lockViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var password: String?
    
    var images: [UIImage] = []
    
    private let imageRatio: CGFloat = 1920/1080
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //images.append(UIImage(named: "Smithsonian")!)
        //images.append(UIImage(named: "Sunset")!)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        passwordTextField.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        // Hide the collectionView before setting or inputing passwords
        collectionView.hidden = true
        passwordView.hidden = false
        
        passwordTextField.text = ""
    }
    
// -----------------------------Collection View ------------------------------
    // how many sections
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //number of items/cells in section
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return images.count
        
    }
    
    //cells for item at index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("reusableCell", forIndexPath: indexPath)
        
        let imageView = cell.viewWithTag(100) as! UIImageView
        imageView.image = images[indexPath.row]
        
        return cell
    }
    
    // Layout Settings
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let width = collectionView.frame.width/3 - 1
        
        return CGSize(width: width, height: width * imageRatio)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }
    
    func reloadCollectionView(){
        
        collectionView.reloadData()
        
    }
    
// -----------------------------Lock-lock ------------------------------
    @IBAction func submit(sender: AnyObject) {
        // First submit(password creation)
        if password == nil{
            if (passwordTextField.text == ""){
                displayAlertMessage("Please set the password for the first time")
                return
            }
            
            displayAlertMessage("First password setting Done")
            
            password = passwordTextField.text
            passwordView.hidden = true
            collectionView.hidden = false
            
            return
        }
        
        // Further submit. Check the password
        if (passwordTextField.text == password){
            passwordView.hidden = true
            collectionView.hidden = false
        }else {
            self.displayAlertMessage("Password do not match!");
        }
        
        // end the editing
        self.view.endEditing(true)
    }
    
    @IBAction func reset(sender: UIButton) {
        passwordTextField.text = ""
        password = nil
        
        displayAlertMessage("Reset the password successfully")
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

// -----------------------------Text Field related extension ------------------------------
extension lockViewController:UITextFieldDelegate{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
