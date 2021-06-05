//
//  signUpViewController.swift
//  Sphere
//
//  Created by Deepak on 12/5/18.
//  Copyright © 2018 D Developer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SVProgressHUD

class signUpViewController: UIViewController , UITextFieldDelegate {
    
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var repasswordTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTxt.delegate = self
        emailTxt.delegate = self
        passwordTxt.delegate = self
        repasswordTxt.delegate = self
        usernameTxt.returnKeyType = .done
        emailTxt.returnKeyType = .done
        passwordTxt.returnKeyType = .done
        repasswordTxt.returnKeyType = .done
        self.dismissKey()
        
    }
    
    func showAlert(withTitle : String , message : String){
        let alert = UIAlertController(title: withTitle , message: message , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        present(alert,animated: true , completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    func ifEmpty() -> Bool {
        if(emailTxt.text == "" || usernameTxt.text == "" || passwordTxt.text == "" || repasswordTxt.text == ""){
            showAlert(withTitle: "Empty Feilds", message: "Please Fill all the feilds")
            return true
        }else {
            return false
        }
    }
    
    func ifNotSame() -> Bool {
        if(passwordTxt.text != repasswordTxt.text){
            showAlert(withTitle: "Password are not same", message: "Please type same password")
            return true
        }else {
            return false
        }
    }
    
    
    @IBAction func signUpButton(_ sender: Any) {
        
        if(ifEmpty() || ifNotSame()){
            return
        }
        SVProgressHUD.show()
        Auth.auth().createUser(withEmail: emailTxt.text!, password: passwordTxt.text!, completion: {
            (authResult,err) in
            SVProgressHUD.dismiss()
            if(err != nil){
                print(err)
                self.showAlert(withTitle: (err?.localizedDescription)! , message: "")
                return
            }
            guard let user = authResult?.user else { return }
            var ref = Database.database().reference()
            //ref.child("users").child(user.uid).setValue(["username" : (self.usernameTxt.text)!])
            ref.child("users").child(user.uid).child("username").setValue((self.usernameTxt.text)!)
            Auth.auth().signIn(withEmail: (self.emailTxt.text)!, password:(self.passwordTxt.text)!, completion: { (data, err) in
                if(err != nil){
                    self.showAlert(withTitle: "Error", message: (err?.localizedDescription)!)
                    return
                }
                
                self.performSegue(withIdentifier: "fromUP", sender: self)
                
            })
        })
        
    }
    

}
