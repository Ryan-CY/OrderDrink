//
//  MenuViewController.swift
//  Order Drinks-API Practice
//
//  Created by Ryan Lin on 2023/6/13.
//

import UIKit

class MenuViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var records = [Record]()
    var presentItems = [Record]()
    var categories = ["All Products"]
    var urlString = "https://api.airtable.com/v0/appBBoJvZRrxzj09q/Menu?sort%5B0%5D%5Bfield%5D=category&sort%5B0%5D%5Bdirection%5D=desc"
    
    func update(records: [Record]) {
        self.records = records
        presentItems = records
        collectionView.reloadData()
        getCategory()
    }
    
    func initializeUI() {
        MenuController.shared.fetchMenu(urlString: urlString) { result in
            
            switch result {
            case .success(let records):
                DispatchQueue.main.async {
                    self.update(records: records)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        
        initializeUI()
        
        searchBar.delegate = self
        searchBar.placeholder = "Search Drinks"
        
        presentItems = records
        
        selectedCategory()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        presentItems = []
        collectionView.reloadData()
        
        presentItems = records
        collectionView.reloadData()
        
        categoryButton.setTitle("Categories", for: .normal)
        searchBar.text = ""
        
    }
    
    func selectedCategory() {
        let name = Notification.Name("selected category")
        NotificationCenter.default.addObserver(self, selector: #selector(categoryChanged), name: name, object: nil)
    }
    
    @objc func categoryChanged(noti: Notification) {
        
        presentItems = []
        collectionView.reloadData()
        
        if let userInfo = noti.userInfo,
           let category = userInfo["category"] as? String {
            
            categoryButton.setTitle(category, for: .normal)
            
            if category == "All Products" {
                presentItems = records
            } else {
                for record in records {
                    if record.fields.category.first == category {
                        presentItems.append(record)
                    }
                }
            }
        }
        collectionView.reloadData()
    }
    
    func getCategory() {
        for record in records {
            let category = record.fields.category.first!
            if categories.contains(category) == false {
                categories.append(category)
            }
        }
        print(categories)
    }
    
    @IBSegueAction func showCategotyTableViewController(_ coder: NSCoder) -> UITableViewController? {
        
        let controller = CategoryTableViewController(coder: coder)
        
        if let sheetPresentationController = controller?.sheetPresentationController {
            sheetPresentationController.detents = [.medium()]
        }
        return controller
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? CategoryTableViewController {
            destination.categories = categories
            
        } else if let destination = segue.destination as? OrderViewController,
                  let item = collectionView.indexPathsForSelectedItems?.first?.item {
            destination.record = presentItems[item]
        }
    }
}
