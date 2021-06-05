//
//  settingsViewController.swift
//  Sphere
//
//  Created by Deepak on 24/03/19.
//  Copyright © 2019 D Developer. All rights reserved.
//

import UIKit
import TextFieldEffects
import Firebase
import FirebaseDatabase
import SVProgressHUD

class settingsViewController: UIViewController , UITextFieldDelegate {
    
    
    @IBOutlet weak var passTextFeild: KaedeTextField!
    @IBOutlet weak var retypePassTextFeild: KaedeTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passTextFeild.delegate = self
        retypePassTextFeild.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    @IBAction func chnagePasswordTap(_ sender: Any) {
        
        if((passTextFeild.text?.isEmpty)! || (retypePassTextFeild.text?.isEmpty)!){
            print("Empty")
            let alert = UIAlertController(title: "PLease fill both feilds", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default , handler: nil))
            present(alert,animated: true, completion: nil)
            return
        }else{
            if(passTextFeild.text! == retypePassTextFeild.text!){
                let newPassword = passTextFeild.text!
                var user = Auth.auth().currentUser
                print(user)
                user?.updatePassword(to: newPassword, completion: { (error) in
                    if(error != nil){
                        print("Error changing password")
                        let alert = UIAlertController(title: error?.localizedDescription, message: "", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default , handler: nil))
                        self.present(alert,animated: true, completion: nil)
                        return
                    }
                    let alert = UIAlertController(title: "Password changed successfully", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default , handler: nil))
                    self.present(alert,animated: true, completion: nil)
                    self.passTextFeild.text = ""
                    self.retypePassTextFeild.text = ""
                })
            }else {
                let alert = UIAlertController(title: "Password do not match", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default , handler: nil))
                present(alert,animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func signOutTapp(_ sender: Any) {
        
        let alert = UIAlertController(title: "Are you sure you want to Sign Out", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            isSignOut = true
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }))
        present(alert,animated: true , completion: nil)
        
        
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
