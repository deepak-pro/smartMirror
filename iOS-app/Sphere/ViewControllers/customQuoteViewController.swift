//
//  customQuoteViewController.swift
//  Sphere
//
//  Created by Deepak on 24/03/19.
//  Copyright © 2019 D Developer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SVProgressHUD

class customQuoteViewController: UIViewController , UITextViewDelegate {

    @IBOutlet weak var textArea: UITextView!
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textArea.delegate = self
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneAction))
        ]
        
        textArea.inputAccessoryView = toolbar
        
        ref.child("users").child((Auth.auth().currentUser?.uid)!).child("customQuote").observeSingleEvent(of: .value) { (snapshot) in
                let value = snapshot.value!
            self.textArea.text = value as? String ?? "Your Quote Here"
        }
        
    }
    
    @objc func doneAction(){
        self.textArea.resignFirstResponder()
    }
    
    @IBAction func generateQuoteofTheDay(_ sender: Any) {
        print("Generating Quote of the day..")
        SVProgressHUD.show()
        guard let url = URL(string: "https://quotes.rest/qod.json") else {return}
        let task = URLSession.shared.dataTask(with: url){ (data,response,error) in
            
            guard let dataResponse = data,error == nil else {
                print(error?.localizedDescription ?? "Response error"); return
                let alert = UIAlertController(title: "Error", message: "Something went wrong"
                    , preferredStyle: .alert )
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert,animated: true, completion: nil)
            }
            do{
                let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse, options: [])
                guard let jsonArray = jsonResponse as? [String: Any] else {
                    return
                }
                guard let result1 = jsonArray["contents"] as? [String : Any] else {
                    return
                }
                guard let result2 = result1["quotes"] as? [[String : Any]] else {
                    return
                }
                guard let result3 = result2[0] as? [String : Any] else {
                    return
                }
                guard let quote = result3["quote"] as? String else {
                    return
                }
               
                DispatchQueue.main.async {
                    print(quote)
                    self.textArea.text = quote
                }
                
                SVProgressHUD.dismiss()
            } catch let parseerror {
                let alert = UIAlertController(title: "Error", message: "Something went wrong"
                    , preferredStyle: .alert )
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert,animated: true, completion: nil)
            }
        }
        task.resume()
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        ref.child("users").child((Auth.auth().currentUser?.uid)!).child("customQuote").setValue(textArea.text ?? "")
        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
