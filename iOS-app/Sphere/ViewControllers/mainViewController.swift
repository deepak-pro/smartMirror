//
//  mainViewController.swift
//  Sphere
//
//  Created by Deepak on 12/5/18.
//  Copyright © 2018 D Developer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SVProgressHUD
import DGRunkeeperSwitch
import EventKit

var isSignOut : Bool = false

class mainViewController: UIViewController  , UITextFieldDelegate {
    
    
    var ref = Database.database().reference()
    @IBOutlet weak var showNewsSwitch: UISwitch!
    @IBOutlet weak var showCalSwitch: UISwitch!
    
    override func viewDidAppear(_ animated: Bool) {
        if(isSignOut == true){
            isSignOut = false
            signOut()
        }else {
            syncEvents()
        }
        
    }
    
    // Synchronise calender events with Smart Mirror
    func syncEvents(){
        let eventStore = EKEventStore()
        
        
        switch EKEventStore.authorizationStatus(for: .event){
        case .authorized :
            print("Authorised") ;
            getEvents()
            break ;
        case .denied :
            print("Denied") ;
            break ;
        case .notDetermined :
            eventStore.requestAccess(to: .event) { (snap, error) in
                print(snap)
                if(snap == true){
                    self.getEvents()
                }
            }
            break ;
        default :
            print("This is default") ;
        }
    }
    
    func getEvents(){
        let eventStore = EKEventStore()
        let calenders = eventStore.calendars(for: .event)
        for calender in calenders {
            let startDate = NSDate(timeIntervalSinceNow: 0)
            let endDate = NSDate(timeIntervalSinceNow: +24*3600)
            let predicate = eventStore.predicateForEvents(withStart: startDate as Date, end: endDate as Date, calendars: calenders)
            let events = eventStore.events(matching: predicate)
            
            var eventsArray = [String]()
            for event in events{
                print(event.title!)
                eventsArray.append(event.title!)
            }
            print(eventsArray)
            self.ref.child("users").child((Auth.auth().currentUser?.uid)!).child("calender").setValue(eventsArray)
            break ;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userId = Auth.auth().currentUser?.uid
        ref.child("users").child(userId!).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let data = value?["data"] as? String ?? ""
        }
        
        showNewsSwitch.setOn(false, animated: true)
        showCalSwitch.setOn(false, animated: true)
        
        // Making Switch for Temperature Unit
        
        let runkeeperSwitch2 = DGRunkeeperSwitch()
        runkeeperSwitch2.titles = ["Celsius" , "Fahrenheit"]
        runkeeperSwitch2.backgroundColor = UIColor(red: 38.0/255.0, green:  70.0/255.0, blue: 83.0/255.0, alpha: 1.0)
        runkeeperSwitch2.selectedBackgroundColor = .white
        runkeeperSwitch2.titleColor = .white
        runkeeperSwitch2.selectedTitleColor = UIColor(red: 38.0/255.0, green:  70.0/255.0, blue: 83.0/255.0, alpha: 1.0)
        runkeeperSwitch2.titleFont = UIFont(name: "HelveticaNeue-Medium", size: 20.0)
        runkeeperSwitch2.frame = CGRect(x: 50.0, y: 90.0, width: view.bounds.width - 100.0, height: 60.0)
        runkeeperSwitch2.autoresizingMask = [.flexibleWidth] // This is needed if you want the control to resize
        runkeeperSwitch2.addTarget(self, action: #selector(mainViewController.switchValueDidChange(sender:)), for: .valueChanged)
        view.addSubview(runkeeperSwitch2)
        
        let runkeeperSwitch1 = DGRunkeeperSwitch()
        runkeeperSwitch1.titles = ["12" , "24"]
        runkeeperSwitch1.backgroundColor = UIColor(red: 38.0/255.0, green:  70.0/255.0, blue: 83.0/255.0, alpha: 1.0)
        runkeeperSwitch1.selectedBackgroundColor = .white
        runkeeperSwitch1.titleColor = .white
        runkeeperSwitch1.selectedTitleColor = UIColor(red: 38.0/255.0, green:  70.0/255.0, blue: 83.0/255.0, alpha: 1.0)
        runkeeperSwitch1.titleFont = UIFont(name: "HelveticaNeue-Medium", size: 20.0)
        runkeeperSwitch1.frame = CGRect(x: 50.0, y: 205.0, width: view.bounds.width - 100.0, height: 60.0)
        runkeeperSwitch1.autoresizingMask = [.flexibleWidth] // This is needed if you want the control to resize
        runkeeperSwitch1.addTarget(self, action: #selector(mainViewController.hourSwitchDidChnage(sender:)), for: .valueChanged)
        view.addSubview(runkeeperSwitch1)
        
        ref.child("users").child((Auth.auth().currentUser?.uid)!).child("tempUnit").observeSingleEvent(of: .value , with: {(snapshot) in
            let tempUnit = snapshot.value  as? String ?? "C"
            if(tempUnit == "C"){
                 runkeeperSwitch2.setSelectedIndex(0, animated: true)
            }else {
                runkeeperSwitch2.setSelectedIndex(1, animated: true)
            }
            })
        
        ref.child("users").child((Auth.auth().currentUser?.uid)!).child("timeFormat").observeSingleEvent(of: .value , with: {(snapshot) in
            let tempUnit = snapshot.value  as? String ?? "12"
            if(tempUnit == "12"){
                runkeeperSwitch1.setSelectedIndex(0, animated: true)
            }else {
                runkeeperSwitch1.setSelectedIndex(1, animated: true)
            }
        })
        
        ref.child("users").child((Auth.auth().currentUser?.uid)!).child("showNews").observeSingleEvent(of: .value , with: {(snapshot) in
            let tempUnit = snapshot.value  as? String ?? "1"
            if(tempUnit == "1"){
                self.showNewsSwitch.setOn(true, animated: true)
            }else {
                self.showNewsSwitch.setOn(false, animated: true)
            }
        })
        
        ref.child("users").child((Auth.auth().currentUser?.uid)!).child("showCal").observeSingleEvent(of: .value , with: {(snapshot) in
            let tempUnit = snapshot.value  as? String ?? "1"
            if(tempUnit == "1"){
                self.showCalSwitch.setOn(true, animated: true)
            }else {
                self.showCalSwitch.setOn(false, animated: true)
            }
            SVProgressHUD.dismiss()
        })
        
        SVProgressHUD.show()
        
    }
    
    @objc func hourSwitchDidChnage(sender : DGRunkeeperSwitch){
        if(sender.selectedIndex == 0){
            self.ref.child("users").child((Auth.auth().currentUser?.uid)!).child("timeFormat").setValue("12")
        }else {
            self.ref.child("users").child((Auth.auth().currentUser?.uid)!).child("timeFormat").setValue("24")
        }
    }
    
    @objc func switchValueDidChange(sender : DGRunkeeperSwitch){
        print(sender.selectedIndex)
        if(sender.selectedIndex == 0){
       self.ref.child("users").child((Auth.auth().currentUser?.uid)!).child("tempUnit").setValue("C")
        }else {
            self.ref.child("users").child((Auth.auth().currentUser?.uid)!).child("tempUnit").setValue("F")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    func signOut() {
        SVProgressHUD.show()
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "showLogin", sender: self)
        } catch  {
            print("🚫 Error is Signning out")
        }
        SVProgressHUD.dismiss()
    }
    
    @IBAction func putInDatabaseButton(_ sender: Any) {
        self.ref.child("users").child((Auth.auth().currentUser?.uid)!).child("data").setValue("Helloww")
        
    }
    
    @IBAction func showNewsChanged(_ sender: UISwitch) {
        if(sender.isOn){
            self.ref.child("users").child((Auth.auth().currentUser?.uid)!).child("showNews").setValue("1")
        }else {
            self.ref.child("users").child((Auth.auth().currentUser?.uid)!).child("showNews").setValue("0")
        }
    }
    
    @IBAction func showCalenderChanged(_ sender: UISwitch) {
        if(sender.isOn){
            self.ref.child("users").child((Auth.auth().currentUser?.uid)!).child("showCal").setValue("1")
        }else {
            self.ref.child("users").child((Auth.auth().currentUser?.uid)!).child("showCal").setValue("0")
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
