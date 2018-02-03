//
//  ViewController.swift
//  instagram
//
//  Created by Tianyi Zhang on 2018-01-04.
//  Copyright © 2018 Tianyi Zhang. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    var signupModeActive = true
    
    func displayAlert(_ title: String, _ message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBAction func signupOrLogin(_ sender: Any) {
        if email.text == "" || password.text == "" {
            displayAlert("No!", "Inproper input")
        }else {
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            
            activityIndicator.center = self.view.center
            
            activityIndicator.hidesWhenStopped = true
            
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            
            view.addSubview(activityIndicator)
            
            activityIndicator.startAnimating()
            
            UIApplication.shared.beginIgnoringInteractionEvents()
            if(signupModeActive) {
                let user = PFUser()
                user.username = email.text
                user.password = password.text
                user.email = email.text
                
                user.signUpInBackground(block: {
                    (success, error) in
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents() 
                    if let error = error {
                        self.displayAlert("Could not sign up ", error.localizedDescription)
                        
                    }else {
                        print("Signed up!")
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                    }
                })
            }else {
                PFUser.logInWithUsername(inBackground: email.text!, password: password.text!, block:{
                    (user,error ) in
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if user != nil {
                        print("login successful!")
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                    }else {
                        var errorText = "please try again!"
                        if let error = error {
                            errorText = error.localizedDescription
                        }
                        
                        self.displayAlert("Could not log you in ", errorText)
                    }
                } )
            }
        }
    }
    @IBOutlet weak var signupOrLoginButton: UIButton!
    @IBAction func switchLoginMode(_ sender: Any) {
        if(signupModeActive) {
            signupModeActive = false
            signupOrLoginButton.setTitle("Log in", for: [])
            switchLoginModeButton.setTitle("Sign up", for: [])
        }else {
            signupModeActive = true
            signupOrLoginButton.setTitle("Sign up", for: [])
            switchLoginModeButton.setTitle("Log in", for: [])

        }
    }
    
    @IBOutlet weak var switchLoginModeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad() 
        // Do any additional setup after loading the view, typically from a nib.
     

    }

    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        if PFUser.current() != nil {
            performSegue(withIdentifier: "showUserTable", sender: self)
        }
     
    }


}

