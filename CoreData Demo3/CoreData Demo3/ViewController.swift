//
//  ViewController.swift
//  CoreData Demo3
//
//  Created by XGus on 3/25/2560 BE.
//  Copyright © 2560 Wizardapp.me. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var users = [[String: AnyObject]]()
    
    var currentname = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        requestData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func saveData(_ sender: Any) {
        
        
        guard nameTextField.text != "" else {
            print("error nil")
            return
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
        
        let name = nameTextField.text as String?
        
        newUser.setValue(name, forKey: "name")
        
        do {
            try context.save()
            requestData()
        } catch {
            print("Error save")
        }
        
    }
    
    @IBAction func updateData(_ sender: Any) {
        
        guard nameTextField.text != "" else {
            print("error nil")
            return
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        
        
        
        do {
            
            let results = try context.fetch(request)
            
            if results.count > 0 {
                
                for result in results as! [NSManagedObject] {
                    
                    
                    
                    if String(describing: result.value(forKey: "name") as! String) == currentname {
                        
                        
                        let name = nameTextField.text as String!
                        
                        result.setValue(name, forKey: "name")
                        
                        
                    
                        
                        do {
                            
                            try context.save()
                            requestData()
                            
                        } catch {
                            
                            print("Update username save failed")
                            
                        }
                        
                    }else{print("Not Update")}
                    
                    
                    
                }
                
                
            }
            
        } catch {
            
            print("Update username failed")
            
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
                    
                    if let name = result.value(forKey: "name") as! String? {
                        dict["name"] = name as AnyObject?
                        
                        
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
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if users.count > 0 {
            return users.count
        }else{
            return 0
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let user = users[indexPath.row]
        let name = user["name"] as! String?
        
        cell.textLabel?.text = name
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let user = users[indexPath.row]
        
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        
        request.returnsObjectsAsFaults = false
        
        if editingStyle == .delete {
            
            
            do {
                let results = try context.fetch(request)
                
                if results.count > 0  {
                    
                    
                    for result in results as! [NSManagedObject] {
                        
                        if String(describing: result.value(forKey: "name")) == String(describing: user["name"]) {
                            
                            context.delete(result)
                            
                            users.remove(at: indexPath.row)
                        }
                    }
                }
                
                
            } catch  {
                print("error request")
            }
            
            
        }
        
        print("Edit \(indexPath.row)")
        
        requestData()
    
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = users[indexPath.row]
        let name = user["name"] as! String?
        
        nameTextField.text = name
        
        
        currentname = name!
        
        print(currentname)
        
        print("select \(indexPath.row)")
    }


}

