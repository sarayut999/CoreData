//
//  ViewController.swift
//  CoreData Demo1
//
//  Created by XGus on 3/25/2560 BE.
//  Copyright © 2560 Wizardapp.me. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        let context = appDelegate.persistentContainer.viewContext
        
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
        
        // insert data
        newUser.setValue("Gus", forKey: "name")
        newUser.setValue(3.01, forKey: "gpa")
        newUser.setValue(25, forKey: "age")
        
        
        //save data
        do {
            try context.save()
            print("save")
        } catch {
            print("there was an error");
        }
        
        
        
        
        
        
        //request data
        let request = NSFetchRequest<NSFetchRequestResult> (entityName: "Users")
        
        
        request.returnsObjectsAsFaults = false
        
        
        do {
            let results = try context.fetch(request)
            
            
            if results.count > 0 {
            
                for result in results as! [NSManagedObject]{
                
                    if let name = result.value(forKey: "name") as? String {
                    
                        print(name)
                    }
                    
                }
            }
            
        } catch  {
            print("Couldn' t fetch request")
        }
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

