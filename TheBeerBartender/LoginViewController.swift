//
//  LoginViewController.swift
//  TheBeerBartender
//
//  Created by Israel on 14/05/2018.
//  Copyright © 2018 Israel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.passwordTextField.delegate = self
        self.emailTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil{
            self.goToHighScoorePage()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func register(_ sender: Any) {
        
        goToRegisterPage()
    }
    
    @IBAction func login(_ sender: Any) {
        //if no internet - alert.
        
        if let email = emailTextField.text, let password = passwordTextField.text{
            
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if let firebaseError = error {
                    
                    let alert = UIAlertController(title: "Pay attention:", message: firebaseError.localizedDescription, preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                    print(firebaseError.localizedDescription)
                    return
                }
                
                self.goToHighScoorePage()
            }
        }
    }
    
    func goToHighScoorePage(){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let highScoreViewController: HighScoreViewController = storyboard.instantiateViewController(withIdentifier: "HighScoreViewController") as! HighScoreViewController
        self.present(highScoreViewController, animated: false, completion: nil)
    }
    
    func goToRegisterPage(){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let registerViewController: RegisterViewController = storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.present(registerViewController, animated: false, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
}
