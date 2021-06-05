//
//  todoViewController.swift
//  Sphere
//
//  Created by Deepak on 23/03/19.
//  Copyright © 2019 D Developer. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import Firebase
import FirebaseDatabase

class todoViewController: UIViewController, UITableViewDelegate , UITableViewDataSource {
    
    
    var ref = Database.database().reference()
    var tasks = [Task]()
    @IBOutlet weak var tableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let alert = UIAlertController(title: "Are you sure to delete this task", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            let realm = try! Realm()
            let toDelete = realm.objects(Task.self).filter("task = '\(self.tasks[indexPath.row].task)'")
            print("To delete is \(toDelete)")
            try! realm.write {
                realm.delete(toDelete)
            }
            
            self.fetechTasks()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true , completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! listCell
        cell.taskTitle.text = tasks[indexPath.row].task
        return cell
    }
    
    @IBAction func donetapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        var textField1 = UITextField()
        let alert = UIAlertController(title: "Add new task", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Add task", style: .default, handler: { (action) in
            if(textField1.text != ""){
                let realm = try! Realm()
                let newTask = Task()
                newTask.task = textField1.text!
                self.tasks.append(newTask)
                try! realm.write {
                    realm.add(newTask)
                }
                self.fetechTasks()
            }
            
        }))
        alert.addTextField { (alertTxtField) in
            alertTxtField.placeholder = "Task Name"
            alertTxtField.autocapitalizationType = UITextAutocapitalizationType.sentences
            textField1 = alertTxtField
        }
        present(alert, animated: true , completion:  nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetechTasks()
        
    }
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    func fetechTasks(){
        let realm = try! Realm()
        let results = realm.objects(Task.self)
        tasks.removeAll()
        var taskArr = [String]()
        for i in results {
            let newTask = Task()
            newTask.task = i.task
            tasks.append(newTask)
            taskArr.append(i.task as! String)
        }
        
        
        tableView.reloadData()
        print("000000000000")
        print(taskArr)
        print("-------------")
        self.ref.child("users").child((Auth.auth().currentUser?.uid)!).child("todoList").setValue(taskArr)
        print("-------------")
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }


}
