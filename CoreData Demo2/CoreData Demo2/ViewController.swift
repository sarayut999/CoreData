//
//  ViewController.swift
//  CoreData Demo2
//
//  Created by XGus on 3/25/2560 BE.
//  Copyright © 2560 Wizardapp.me. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var gpaTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var users = [[String:AnyObject]]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        requestData()
        
    }
    
    
    @IBAction func okSave() {
        
        
        
        guard nameTextField.text != "" && ageTextField.text != "" && gpaTextField.text != ""  else {
            print("error nil")
            return
        }
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
        
        
        
        let name = nameTextField.text as String?
        let age  = Int(ageTextField.text!) as Int?
        let gpa  = Double(gpaTextField.text!) as Double?
        
        
        newUser.setValue(name, forKey: "name")
        newUser.setValue(age, forKey: "age")
        newUser.setValue(gpa, forKey: "gpa")
        
        
        do {
            try context.save()
            requestData()
        } catch {
            print("Error save")
        }
        
        
    
    }
    
    
    
    func requestData() {
        
        users.removeAll()
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
    
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        
        
        request.returnsObjectsAsFaults = false
        
        var dict = Dictionary<String, AnyObject>()
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0  {
                
                for result in results as! [NSManagedObject] {
                    
                    if let name = result.value(forKey: "name") as? String {
                        print(name)
                        
                        dict["name"] = name as AnyObject?
                    }
                    if let age = result.value(forKey: "age") as? Int {
                        print(age)
                        
                        dict["age"] = age as AnyObject?
                    }
                    if let gpa = result.value(forKey: "gpa") as? Double {
                        print(gpa)
                        
                        dict["gpa"] = gpa as AnyObject?
                    }
                    
                    users.append(dict)
                    print(users.description)
                    
                    
                }
            }
            
        } catch  {
            print("error request")
        }
        
        
        
        
        tableView.reloadData()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let user = users[indexPath.row]
        
        let name = user["name"] as! String
        let age = user["age"] as! Int
        let gpa  = user["gpa"] as! Double
        
        

        
        cell.textLabel?.text = "\(name) : \(age) : \(gpa)"
        
        return cell
    }


}

