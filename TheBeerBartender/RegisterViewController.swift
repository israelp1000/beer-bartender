//
//  RegisterViewController.swift
//  TheBeerBartender
//
//  Created by Israel on 13/06/2018.
//  Copyright © 2018 Israel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    var ref: DatabaseReference!
    var handleUsername: DatabaseHandle?
    var userID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.passwordTextField.delegate = self
        self.emailTextField.delegate = self
        self.usernameTextField.delegate = self
        ref = Database.database().reference()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil{ ///??
            self.goToHighScoorePage()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func register(_ sender: Any) {
        let username = usernameTextField.text
        if (String(describing: username).count - 12) > 15 {
            print(String(describing: username).count)
            let alert = UIAlertController(title: "Pay attention:", message: "Username can't be longer then 15 Characters", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }

        // validate - whitespaces in the username field:
        if (username?.trimmingCharacters(in: .whitespaces).isEmpty)!{
            //print("No username...")
            let alert = UIAlertController(title: "Pay attention:", message: "fill the Username", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert whitespaces username occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        //
        
        if let email = emailTextField.text, let password = passwordTextField.text{
            
            self.ref.child("username").observeSingleEvent(of: .value){ (snapshot) in
                let myDict :[String : Any] = snapshot.value as! [String : Any]
                //check if username olredy exsist: //
                for (_, value) in myDict{
                    if (username! == (value as! String)){
                        print("... username olredy exist...")
                        self.usernameTextField.textColor = UIColor.red
                        let alert = UIAlertController(title: "Pay attention:", message: "Username already exists. Please choose another username.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                            self.usernameTextField.text = ""
                            self.usernameTextField.textColor = UIColor.black
                        }))
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                }

            
            
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if let firebaseError = error {
                    //error reister Alert:
                    let alert = UIAlertController(title: "Pay attention:", message: firebaseError.localizedDescription, preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"OK\" alert Register occured.")
                    }))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                    self.userID = Auth.auth().currentUser?.uid
                self.ref.child("username").child(self.userID!).setValue(username!)

                self.ref.child("highscore").child(username!).setValue(0)
                    
                    self.goToHighScoorePage()
                }
            }
        }
    }
    
    func goToHighScoorePage(){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let highScoreViewController: HighScoreViewController = storyboard.instantiateViewController(withIdentifier: "HighScoreViewController") as! HighScoreViewController
        self.present(highScoreViewController, animated: false, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        passwordTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        usernameTextField.resignFirstResponder()
        return true
    }
}
