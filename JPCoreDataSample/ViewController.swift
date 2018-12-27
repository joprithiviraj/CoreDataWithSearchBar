//
//  ViewController.swift
//  JPCoreDataSample
//
//  Created by joprithiviraj on 20/12/18.
//  Copyright © 2018 joprithivi. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, getValuesProtocol {
    func getArrayValues(_ getValues: [String : Any]) {
        getEditCoreDataValue = getValues
    }
    
    var setdelegate:ListViewController = ListViewController()

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    var getEditCoreDataValue = [String:Any]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if !getEditCoreDataValue.isEmpty {
            nameTextField.text = (getEditCoreDataValue["name"] as! String)
            companyNameTextField.text = (getEditCoreDataValue["companyName"] as! String)
            ageTextField.text = (getEditCoreDataValue["age"] as! String)
            emailTextField.text = (getEditCoreDataValue["emailId"] as! String)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func saveButton(_ sender: Any) {
        if nameTextField.text!.isEmpty || companyNameTextField.text!.isEmpty || ageTextField.text!.isEmpty || emailTextField.text!.isEmpty {
            alertController("Please enter the detials")
        }
        else {
            if !getEditCoreDataValue.isEmpty {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Register")
                do {
                    let edited = try context.fetch(request)
                    let updatedObject = edited[getEditCoreDataValue["indexValue"] as! Int] as! NSManagedObject
                    updatedObject.setValue(nameTextField.text!, forKey: "name")
                    updatedObject.setValue(companyNameTextField.text!, forKey: "companyName")
                    updatedObject.setValue(ageTextField.text!, forKey: "age")
                    updatedObject.setValue(emailTextField.text!, forKey: "emailId")
                    do {
                        try context.save()
                        getEditCoreDataValue = [:]
                        clearTextFieldInfo()
                        alertController("Updated Successfully")
                    }
                    catch {
                        print("Not updated")
                    }
                } catch {
                    print("Failed to open")
                }
            }
            else {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: "Register", in: context)
                let register = NSManagedObject(entity: entity!, insertInto: context)
                register.setValue(nameTextField.text!, forKey: "name")
                register.setValue(companyNameTextField.text!, forKey: "companyName")
                register.setValue(ageTextField.text!, forKey: "age")
                register.setValue(emailTextField.text!, forKey: "emailId")
                do {
                    try context.save()
                    alertController("Saved Successfully")
                    clearTextFieldInfo()
                    print("Saved")
                    
                } catch {
                    print("Failed saving")
                }
            }
        }
    }
    
    @IBAction func listButton(_ sender: Any) {
        self.performSegue(withIdentifier: "listSegue", sender: self)
    }
    
    func clearTextFieldInfo() {
        nameTextField.text = ""
        companyNameTextField.text = ""
        ageTextField.text = ""
        emailTextField.text = ""
    }
    
    func alertController(_ msg: String) {
        let alertController = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //MARK: step 5 create a reference of Class B and bind them through the prepareforsegue method
        if segue.identifier == "listSegue" {
            let controller = segue.destination as! ListViewController
            controller.delegate = self
        }
    }
}
