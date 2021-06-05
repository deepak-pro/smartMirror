//
//  resetViewController.swift
//  Sphere
//
//  Created by Deepak on 24/03/19.
//  Copyright © 2019 D Developer. All rights reserved.
//

import UIKit
import Firebase


class resetViewController: UIViewController , UITextFieldDelegate {

    @IBOutlet weak var emailTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTxt.delegate = self
        emailTxt.returnKeyType = .done
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func resetButton(_ sender: Any) {
        if((emailTxt.text?.isEmpty)! == true){
            let alert = UIAlertController(title: "Please type email", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert,animated: true, completion: nil)
            return
        }else{
            var auth = Auth.auth()
            var email = emailTxt.text!
            auth.sendPasswordReset(withEmail: email) { (error) in
                if(error != nil){
                    let alert = UIAlertController(title: error?.localizedDescription, message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert,animated: true, completion: nil)
                    return
                }
                let alert = UIAlertController(title: "Please Check your email for reset link", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert,animated: true, completion: nil)
            }
        }
        
    }
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
