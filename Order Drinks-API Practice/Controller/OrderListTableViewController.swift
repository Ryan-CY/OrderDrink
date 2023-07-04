//
//  OrderListTableViewController.swift
//  LiHoTea
//
//  Created by Ryan Lin on 2023/6/13.
//

import UIKit

class OrderListTableViewController: UITableViewController {
    
    var orderRecords = [OrderRecord]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        renewDate()
    }
    
    @objc func refreshData() {
        renewDate()
        tableView.refreshControl?.endRefreshing()
    }
    
    func renewDate() {
        
        //empty orderRecords and table view first
        self.orderRecords = []
        self.tableView.reloadData()
        
        OrderController.shared.fetchOrderList { result in
            
            switch result {
            case .success(let orderRecords):
                self.orderRecords = orderRecords
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Table view data source
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 0
    //    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        orderRecords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(OrderListTableViewCell.self)", for: indexPath) as? OrderListTableViewCell else {
            fatalError("dequeueReusableCell OrderListTableViewCell failed")
        }
        
        let row = indexPath.row
        
        cell.nameLabel.text = "#\(row+1) "+orderRecords[row].fields.name
        cell.toppingLabel.text = orderRecords[row].fields.toppings
        cell.sizeLabel.text = orderRecords[row].fields.size+" x "+orderRecords[row].fields.quantity.description
        cell.iceLevelLabel.text = orderRecords[row].fields.iceLevel
        cell.sugarLavelLabel.text = orderRecords[row].fields.sugarLevel
        //cell.quantityLabel.text = "Qty x"+orderRecords[row].fields.quantity.description
        cell.noteLabel.text = orderRecords[row].fields.note
        cell.timeLabel.text = orderRecords[row].fields.time
        
        cell.frameImageView.layer.cornerRadius = 10
        cell.frameImageView.layer.borderWidth = 4
        cell.frameImageView.layer.borderColor = CGColor(red: 147/255, green: 189/255, blue: 197/255, alpha: 1)
        
        return cell
    }
    
    /*
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     }
     */
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let id = orderRecords[indexPath.row].id
        
        OrderController.shared.deleteOrder(deleteID: id)
        
        orderRecords.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
    }
    
    
    
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
