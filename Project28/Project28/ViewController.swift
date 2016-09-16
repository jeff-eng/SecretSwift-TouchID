//
//  ViewController.swift
//  Project28
//
//  Created by Jeffrey Eng on 9/14/16.
//  Copyright © 2016 Jeffrey Eng. All rights reserved.
//

import LocalAuthentication
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var secret: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nothing to see here"
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        // Ask iOS to tell us when the keyboard changes or when it hides.
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIKeyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIKeyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplicationWillResignActiveNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func authenticateUser(sender: AnyObject) {
        let context = LAContext()
        var error: NSError?
        
        // Here, we are checking to see if the device has Touch ID and if so, request Touch ID to begin check
        if context.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please verify your identity"
            
            context.evaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] (success, authenticationError) in
                
                dispatch_async(dispatch_get_main_queue()) {
                    if success {
                        self.unlockSecretMessage()
                    } else {
                        // provide alert message that Touch ID verification failed
                        let ac = UIAlertController(title: "Authentication failed", message: "Your fingerprint could not be verified. Please try again.", preferredStyle: .Alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                        self.presentViewController(ac, animated: true, completion: nil)
                    }
                }
            }
        } else {
            // provide alert if device does not have Touch ID
            let ac = UIAlertController(title: "Touch ID is not available", message: "Your device is not configured for Touch ID", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        }
    }
    
    func adjustForKeyboard(notification: NSNotification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let keyboardViewEndFrame = view.convertRect(keyboardScreenEndFrame, fromView: view.window)
        
        if notification.name == UIKeyboardWillHideNotification {
            secret.contentInset = UIEdgeInsetsZero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
    
    // Loads the message into the text view
    func unlockSecretMessage() {
        // Sets initial hidden property to false, which means the text view is visible by default
        secret.hidden = false
        // Change title of view controller
        title = "Secret stuff!"
        
        if let text = KeychainWrapper.stringForKey("SecretMessage") {
            // if a value exists, then assign that value as the text for the text view
            secret.text = text
        }
    }
    
    // Saves the message back to the keychain; write text view's text to keychain, then make hidden
    func saveSecretMessage() {
        if !secret.hidden {
            // Write to the keychain
            KeychainWrapper.setString(secret.text, forKey: "SecretMessage")
            // Hide keyboard
            secret.resignFirstResponder()
            // Re-hide the text view
            secret.hidden = true
            // Change back the view controller's title
            title = "Nothing to see here"
        }
    }

}

