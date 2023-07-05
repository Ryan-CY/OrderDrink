//
//  MenuViewController+Extension.swift
//  Order Drinks-API Practice
//
//  Created by Ryan Lin on 2023/6/4.
//

import Foundation
import UIKit

extension MenuViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presentItems.count
    }
    
    fileprivate func configuration(_ cell: MenuCollectionViewCell) {
        cell.activityIndicator.hidesWhenStopped = true
        cell.activityIndicator.startAnimating()
        
        cell.itemPhoto.image = nil //clear images
        
        cell.frameImageView.layer.cornerRadius = 10
        cell.frameImageView.layer.borderWidth = 4
        cell.frameImageView.layer.borderColor = CGColor(red: 147/255, green: 189/255, blue: 197/255, alpha: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MenuCollectionViewCell.self)", for: indexPath) as? MenuCollectionViewCell else {fatalError("dequeueReusableCell MenuCollectionViewCell failed")}
        
        configuration(cell)
        
        let presentItem = presentItems[indexPath.row]
        
        cell.itemName.text = presentItem.fields.name
        cell.itemPrice.text = "\(presentItem.fields.price)"
        
        if let imageURL = presentItem.fields.image.first?.url {
            
            MenuController.shared.fetchImage(url: imageURL) {[weak self] result in
                guard let self else {return}
                
                switch result {
                case .success(let photo):
                    DispatchQueue.main.async {
                        cell.itemPhoto.image = photo
                        cell.activityIndicator.stopAnimating()
                    }
                    
                case .failure(let failure):
                    print(failure)
                }
            }
        }
        return cell
    }
}

extension MenuViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presentItems = []
        collectionView.reloadData()
        
        if searchText.isEmpty == true {
            presentItems = records
            categoryButton.setTitle("All Products", for: .normal)
        } else {
            categoryButton.setTitle("Filtered", for: .normal)
            
            for record in records {
                if record.fields.name.lowercased().contains(searchText.lowercased()) {
                    presentItems.append(record)
                }
            }
        }
        collectionView.reloadData()
        
    }
    //tap return to dismiss keyboard
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    //tap view to dismiss keyboatrd
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


