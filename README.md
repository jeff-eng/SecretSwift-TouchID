# SecretSwift-TouchID
Repo following Project 28: Secret Swift: Touch ID at Hacking with Swift written in Swift 2.

## Concepts learned/practiced
* Learned:
  * iOS keychain
    * KeychainWrapper class - used to read and write keychain values
      * setString() method
        * Example:

        ```Swift
        if !secret.hidden {
          KeychainWrapper.setString(secret.text, forKey: "SecretMessage")
        }

        ```
      * stringForKey() method
        * Example:

        ```Swift
        if let text = KeychainWrapper.stringForKey("SecretMessage")

        ```
  * Local Authentication framework
    * Touch ID
      * Check if device is Touch ID capable
      * Run Touch ID authentication if device is capable
      * Successful authentication allowing app to open as well as error handling if unsuccessful in authentication.
    * canEvaluatePolicy() method - checks if device supports Touch ID when passing in .deviceOwnerAuthenticationWithBiometrics as argument
    * evaluatePolicy() method - does the actual biometric authentication and you instruct what to do when either successful or unsuccessful in authenticating.
* Practiced:
  * Notification Center - notified of certain events that occur in iOS such as when the keyboard changes or hides.
    * addObserver() method
    * Example:
      ```Swift

      let notificationCenter = NSNotificationCenter.defaultCenter()
      notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIKeyboardWillHideNotification, object: nil)

      ```
  * Grand Central Dispatch(GCD)
    * Example:
    ```Swift
    dispatch_async(dispatch_get_main_queue()) {
      if success {
          self.unlockSecretMessage()
      } else {
          let ac = UIAlertController(title: "Authentication failed", message: "Your fingerprint could not be verified. Please try again.", preferredStyle: .Alert)
          ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
          self.presentViewController(ac, animated: true, completion: nil)
      }
    }
    ```
## Attributions
[Project 28: Secret Swift](https://www.hackingwithswift.com/read/28/overview)
