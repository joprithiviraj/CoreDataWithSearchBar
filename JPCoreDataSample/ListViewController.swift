//
//  ListViewController.swift
//  JPCoreDataSample
//
//  Created by joprithiviraj on 20/12/18.
//  Copyright © 2018 joprithivi. All rights reserved.
//

import UIKit
import CoreData

protocol getValuesProtocol: class {
    func getArrayValues(_ getValues: [String:Any])
}

class ListTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var companyLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class ListViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableViewObj: UITableView!
    var searchActive : Bool = false
    var filtered:[[String:String]]? = []
    var listArray: [[String:String]]? = []
    var getEditListArray: [[String:String]]? = []
    var delegate:getValuesProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCoreData()
    }
    
    func fetchCoreData() {
        listArray?.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Register")
        request.returnsObjectsAsFaults = false
        request.resultType = NSFetchRequestResultType.dictionaryResultType
        do {
            let result = try context.fetch(request) as! [[String:String]]
            listArray = result
            print(listArray!)
            
        } catch {
            
            print("Failed")
        }
    }

    func deleteCoreData(indexPath: Int) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Register")
        do {
            let test = try context.fetch(request)
            let objectToDelete = test[indexPath] as! NSManagedObject
            context.delete(objectToDelete)
            do {
                try context.save()
                fetchCoreData()
            }
            catch {
                print(error)
            }
        }
        catch {
            print(error)
        }
    }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filtered!.count
        }
        else {
            return listArray!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        if searchActive {
            cell.nameLbl.text! = filtered![indexPath.row]["name"]!
            cell.companyLbl.text! = filtered![indexPath.row]["companyName"]!
            cell.ageLbl.text! = filtered![indexPath.row]["age"]!
            cell.emailLbl.text! = filtered![indexPath.row]["emailId"]!
        }
        else {
            cell.nameLbl.text! = listArray![indexPath.row]["name"]!
            cell.companyLbl.text! = listArray![indexPath.row]["companyName"]!
            cell.ageLbl.text! = listArray![indexPath.row]["age"]!
            cell.emailLbl.text! = listArray![indexPath.row]["emailId"]!
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 162
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if searchActive {
            return []
        }
        else {
            let delete = UITableViewRowAction(style: .destructive, title: "delete") { (action, indexPath) in
                // delete item at indexPath
                self.deleteCoreData(indexPath: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .none)
            }
            let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
                // share item at indexPath
                var getList = [String:Any]()
                getList = ["indexValue": indexPath.row, "name": self.listArray![indexPath.row]["name"]!, "companyName": self.listArray![indexPath.row]["companyName"]!, "age": self.listArray![indexPath.row]["age"]!, "emailId": self.listArray![indexPath.row]["emailId"]!]
                self.navigationController?.popViewController(animated: true)
                self.delegate?.getArrayValues(getList)
                print(getList)

            }
            return [delete,edit]
        }
    }
}

extension ListViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        tableViewObj.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //working fine old concepts
//        let searchPredicate = NSPredicate(format: "name CONTAINS[C] %@", searchText)
//        let array = (listArray! as NSArray).filtered(using: searchPredicate)
//        print ("array = \(array)")
//
//        if(array.count == 0){
//            searchActive = false;
//        } else {
//            searchActive = true;
//        }
//        self.tableViewObj.reloadData()
        
        //new concetps
        filtered = listArray?.filter { $0["name"]!.uppercased().lowercased().contains(searchText.lowercased())}
        print(filtered!)
        searchActive = !filtered!.isEmpty
        tableViewObj.reloadData()
    }

    
}
