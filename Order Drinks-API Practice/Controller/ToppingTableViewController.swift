//
//  ToppingTableViewController.swift
//  LiHoTea
//
//  Created by Ryan Lin on 2023/6/5.
//

import UIKit

class ToppingTableViewController: UITableViewController {
    
    var toppings = [Topping]()
    var selectedToppings = [Topping]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 0
    //    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        toppings.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ToppingTableViewCell.self)", for: indexPath) as? ToppingTableViewCell else {fatalError("dequeueReusableCell ToppingTableViewCell Failed")}
        
        let row = indexPath.row
        
        cell.toppingTextField.text = toppings[row].toppingName
        cell.toppingPriceTextField.text = "+\(toppings[row].toppingPrice!)"
        if toppings[row].check == false {
            cell.checkButton.setImage(UIImage(systemName: "circle"), for: .normal)
            cell.checkButton.tintColor = .systemGray3
        } else {
            cell.checkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            cell.checkButton.tintColor = .systemOrange
        }
        return cell
    }
    // Q1: remove element of array in for-in
    // Q2: community between table function cellForRow and didSeleRow
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        //add toppings
        if selectedToppings.count < 2, toppings[row].check == false {
            
            toppings[row].check = true
            selectedToppings.append(toppings[row])
            
            //remove topping
        } else if toppings[row].check == true {
            
            toppings[row].check = false
            let name = toppings[row].toppingName
            
            //finding the index of the same topping
            if let index = selectedToppings.firstIndex(where: {
                $0.toppingName.contains(name) }) {
                selectedToppings.remove(at: index)
            }
        }
        
        tableView.reloadData()
        
        let name = Notification.Name("topping changed")
        NotificationCenter.default.post(name: name, object: nil, userInfo: [
            "selectedToppings" : selectedToppings,
            "toppings": toppings
        ])
        
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        "Optional, max 2"
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
