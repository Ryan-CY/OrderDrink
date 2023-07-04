//
//  OrderViewController+Extension.swift
//  LiHoTea
//
//  Created by Ryan Lin on 2023/6/5.
//

import Foundation
import UIKit

extension OrderViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        sugarLevels.count
    }
}

extension OrderViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        sugarLevels[row].rawValue
    }
}
