//
//  ViewController.swift
//  Sphere
//
//  Created by Deepak JOSHI on 27/05/18.
//  Copyright © 2018 D Developer. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD


class ViewController: UIViewController , UITextFieldDelegate {

    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTxt.delegate = self
        passwordTxt.delegate = self
        emailTxt.returnKeyType = .done
        passwordTxt.returnKeyType = .done
        self.dismissKey()
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(Auth.auth().currentUser == nil){
            print("🚫 User Not logged in")
        }else {
            print("✅ User Logged In")
            performSegue(withIdentifier: "showData", sender: self)
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    func showAlert(withTitle : String , message : String){
        let alert = UIAlertController(title: withTitle , message: message , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        present(alert,animated: true , completion: nil)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    @IBAction func doneButtonClick(_ sender: Any){
        if(emailTxt.text == "" || passwordTxt.text == ""){
            showAlert(withTitle: "Feilds are empty", message: "Please fill all the feilds")
        }
        SVProgressHUD.show()
        Auth.auth().signIn(withEmail: emailTxt.text!, password: passwordTxt.text!) {
            (user,err) in
            SVProgressHUD.dismiss()
            if(err != nil){
                self.showAlert(withTitle: (err?.localizedDescription)!, message: "")
                return
            }
            self.performSegue(withIdentifier: "showData", sender: self)
        }
        
        
    }
    
}

