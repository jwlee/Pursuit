//
//  SignupViewController.swift
//  Pursuit
//
//  Created by James Lee on 3/3/15.
//  Copyright (c) 2015 Pursuit. All rights reserved.
//

import Foundation
import UIKit
import Parse

class PursuitSignupViewController: UITableViewController,UITextFieldDelegate {
    
    @IBOutlet var txtUsername : UITextField!
    @IBOutlet var txtPassword : UITextField!
    @IBOutlet weak var txtBirthday : UITextField!
    @IBOutlet var txtGender : UITextField!
    @IBOutlet var txtPhone : UITextField!
    @IBOutlet var txtLocation : UITextField!

    var popDatePicker : PopDatePicker?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        popDatePicker = PopDatePicker(forTextField: txtBirthday)
        txtBirthday.delegate=self
    }
    
    /** date picker view **/
    func resign() {
        
        txtBirthday.resignFirstResponder()
    }

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        if (textField === txtBirthday) {
            resign()
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            formatter.timeStyle = .NoStyle
            let initDate = formatter.dateFromString(txtBirthday.text)
            
            popDatePicker!.pick(self, initDate:initDate, dataChanged: { (newDate : NSDate, forTextField : UITextField) -> () in
                
                // here we don't use self (no retain cycle)
                forTextField.text = newDate.ToDateMediumString()
                
            })
            return false
        }
        else {
            return true
        }
    }
    
    /** send information to next slide **/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "pursuit_signup_success") {
            var svc = segue.destinationViewController as PursuitSignupDetailViewController;
            svc.username = txtUsername.text.lowercaseString
            svc.userpassword = txtPassword.text
            svc.userbirthday = txtBirthday.text
            svc.usergender = txtGender.text
            svc.userphone = txtPhone.text
            svc.userlocation = txtLocation.text
            
            
        }
    }

    
    @IBAction func cancel(sender:UIButton)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func submit(sender:UIButton)
    {
        var query = PFUser.query()
        query.whereKey( "username" , equalTo: txtUsername.text)
        var overlap = query.findObjects()
        println(overlap);
        if(overlap.count == 0)
        {
            self.performSegueWithIdentifier("pursuit_signup_success", sender: self)
        }
        else
        {
            let alertVC = UIAlertController(title: "Invaild ID", message: "Sorry, this ID is taken", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style:.Default, handler: nil)
            alertVC.addAction(okAction)
            presentViewController(alertVC, animated: true, completion: nil)
        }

    }
    


}