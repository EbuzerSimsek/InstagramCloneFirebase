//
//  ViewController.swift
//  InstaCloneFirebase
//
//  Created by Ebuzer Şimşek on 17.04.2023.
//

import UIKit
import Firebase
class ViewController: UIViewController {

    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var mailText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    @IBAction func signinClicked(_ sender: Any) {
        if mailText.text != "" && passwordText.text != ""{
            
            Auth.auth().signIn(withEmail: mailText.text!, password: passwordText.text!) { authdata, error in
                if error != nil{
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }else
                {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        }
        else{
            makeAlert(titleInput: "Error", messageInput: "Username?/Password?")
        }
    }
    
    @IBAction func signupClicked(_ sender: Any) {
        if mailText.text != "" && passwordText.text != ""{
            Auth.auth().createUser(withEmail: mailText.text!, password: passwordText.text!) { authdata, error in
                if error != nil{
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }
                else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }
        else {
            makeAlert(titleInput: "Error", messageInput: "Username?/Password?")
        }
    }
    func makeAlert(titleInput:String,messageInput:String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}

