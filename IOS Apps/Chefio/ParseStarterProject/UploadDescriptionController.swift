//
//  UploadDescriptionController.swift
//  Chefio
//
//  Created by Tingbo Chen on 5/27/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class UploadDescriptionController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    let boarderGray = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.3)
    let textGrey = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.4)
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet var titleInput: UITextView!

    @IBOutlet var descripInput: UITextView!
    
    func activityIndFunc(status: Int = 0) {
        
        if status == 1 {
            //Show Activity Indicator
            activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
            activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
        } else if status == 0 {
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
        }
        
    }
    
    func alertFunc(alertMsg: [AnyObject]) {
        
        //Alerts
        let alert = UIAlertController(title: alertMsg[0] as? String, message: alertMsg[1] as? String, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            //self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func dateString() -> String {
        //Date Extraction
        var dateValue: String = ""
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components([.Day , .Month , .Year, .Hour, .Minute], fromDate: date)
        
        dateValue = String(dateComponents.month) + "/" + String(dateComponents.day) + "/" + String(dateComponents.year)
        
        return dateValue
    }
    
    func placeholdTextReset(status: Int = 0) {
        if status == 1 {
            //Resets placeholders
            //self.ImageOutlet.contentMode = .ScaleToFill
            
            //self.ImageOutlet.image = UIImage(named: "placeholder-camera-green.png")
            
            //self.ImageOutlet.alpha = 0.5
            
            descripInput.text = ""
            
            titleInput.text = ""
            
            descripInputSpecs(0)
            
            titleInputSpecs(0)
            
        } else if status == 0 {
            
            //self.ImageOutlet.contentMode = .ScaleToFill
            
            //self.ImageOutlet.alpha = 1
            
        }
        
    }
    
    func textBoxSpecs() {
        
        let textBoxes = [descripInput, titleInput]
        
        for textBox in textBoxes {
            textBox.textContainerInset =
                UIEdgeInsetsMake(5,2,2,2)
            textBox.layer.borderWidth = 2.0
            textBox.layer.borderColor = boarderGray.CGColor
            textBox.layer.cornerRadius = 5.0
        }
        
    
    }
    
    func descripInputSpecs(status: Int = 0) {
        
        if status == 0 && self.descripInput.text.isEmpty {
            self.descripInput.text = "Add Description"
            self.descripInput.textColor = textGrey
        } else if status == 1 && descripInput.textColor == textGrey {
            self.descripInput.text = nil
            self.descripInput.textColor = UIColor.blackColor()
        }
    }
    
    func titleInputSpecs(status: Int = 0) {
        
        if status == 0 && self.titleInput.text.isEmpty {
            self.titleInput.text = "Add Title"
            self.titleInput.textColor = textGrey
        } else if status == 1 && titleInput.textColor == textGrey {
            self.titleInput.text = nil
            self.titleInput.textColor = UIColor.blackColor()
        }
    }
    
    
    @IBAction func postButton(sender: AnyObject) {
        
        /*if ImageOutlet.image != nil && self.ImageOutlet.image != UIImage(named: "placeholder-camera-green.png") {
            
            let postWarning = ["Are you sure?", "Are you sure you want to post?"]
            
            let alert = UIAlertController(title: postWarning[0], message: postWarning[1], preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                print("OK")
                
                //Turn on Spinner
                self.activityIndFunc(1)
                
                //Upload Image To Parse
                let post = PFObject(className: "Posts")
                
                if self.addMessageField.text == "Add message" {
                    post["message"] = ""
                } else {
                    post["message"] = self.addMessageField.text
                }
                
                post["userID"] = PFUser.currentUser()!.objectId!
                
                post["date"] = self.dateString()
                
                let imageData = UIImagePNGRepresentation(self.ImageOutlet.image!)
                
                let imageFile = PFFile(name: "image.png", data: imageData!)
                
                post["imageFile"] = imageFile
                
                post.saveInBackgroundWithBlock { (success, error) -> Void in
                    if error == nil {
                        //print("success")
                        self.activityIndFunc(0)
                        
                        //Post Success Alert
                        //self.alertFunc(["Upload Successful", "Your post has been updated."])
                        
                        self.placeholdPicReset(1)
                        
                    } else {
                        
                        self.alertFunc(["Upload Unsuccessful", String(error)])
                        self.activityIndFunc(0)
                    }
                }
                
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in
                
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            //Please select Image Alert
            self.alertFunc(["No Image to Post", "Please choose an image to post."])
        }*/
        
    }
    /*
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        //print("image selected")
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        ImageOutlet.image = image
        
        if self.ImageOutlet.image != nil && self.ImageOutlet.image != UIImage(named: "placeholder-camera-green.png") {
            
            self.placeholdPicReset(0)
        }
        
    }*/
    
    @IBAction func chooseImageButton(sender: AnyObject) {
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        //image.sourceType = UIImagePickerControllerSourceType.Camera //To import from camera
        image.allowsEditing = true
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textBoxSpecs()
        
        descripInputSpecs(0)
        titleInputSpecs(0)
        
        descripInput.delegate = self
        titleInput.delegate = self
        
        navigationController?.navigationBar.topItem?.title = self.dateString()
        
        placeholdTextReset(1)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Tapping Outside the keyboard will close it:
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        descripInputSpecs(1)
        titleInputSpecs(1)
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        descripInputSpecs(0)
        titleInputSpecs(0)
    }
    
    //Tapping "Return" will tab to next label then submit and hide keyboard:
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            
            if titleInput.isFirstResponder() {
                titleInput.resignFirstResponder()
                return false
            }
        }
        return true
    }

}