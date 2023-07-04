//
//  OrderViewController.swift
//  LiHoTea
//
//  Created by Ryan Lin on 2023/6/4.
//

import UIKit

class OrderViewController: UIViewController {
    
    var record: Record?
    
    var toppings : [Topping] = [
        Topping(toppingName: "Golden Pearl", toppingPrice: 0.7, check: false),
        Topping(toppingName: "Brown Sugar Pearl", toppingPrice: 0.7, check: false),
        Topping(toppingName: "White Pearl", toppingPrice: 0.7, check: false),
        Topping(toppingName: "Aloe Vera", toppingPrice: 0.6, check: false),
        Topping(toppingName: "Coconut Jelly", toppingPrice: 0.6, check: false),
        Topping(toppingName: "Coconut Noodles", toppingPrice: 0.9, check: false)
    ]
    
    let sugarLevels = SugerLevel.allCases
    let iceLevels = IceLevel.allCases
    let drinkSizes = DrinkSize.allCases
    
    var selectedToppings = [Topping]()
    var toppingPrice = 0
    var finalPrice: Double = 0
    var priceString = String()
    
    @IBOutlet weak var drinkName: UILabel!
    @IBOutlet weak var size: UISegmentedControl!
    @IBOutlet weak var iceLevel: UISegmentedControl!
    @IBOutlet weak var sugarLevel: UITextField!
    @IBOutlet weak var toppingButton: UIButton!
    @IBOutlet var toppingTextFields: [UITextField]!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet weak var addOrderButton: UIButton!
    @IBOutlet weak var quantityStepper: UIStepper!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var noteLabel: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    func updatedUI() {
        
        size.setTitle(drinkSizes[0].rawValue, forSegmentAt: 0)
        size.setTitle(drinkSizes[1].rawValue, forSegmentAt: 1)
        
        iceLevel.setTitle(iceLevels[0].rawValue, forSegmentAt: 0)
        iceLevel.setTitle(iceLevels[1].rawValue, forSegmentAt: 1)
        
        sugarLevel.inputView = pickerView
        sugarLevel.inputAccessoryView = toolBar
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        sugarLevel.text = "Sugar Level"
        
        toppingButton.setTitle("Toppings", for: .normal)
        toppingButton.layer.cornerRadius = 5
        
        drinkName.text = record?.fields.name
        
        finalPrice = (record?.fields.price)!
        
        quantityStepper.value = 1
        quantityLabel.text = "Qty：\(quantityStepper.value.formatted(.number.precision(.fractionLength(0))))"
        
        addOrderButton.setTitle( "ADD ORDER   $\(finalPrice)", for: .normal)
        
        priceString = finalPrice.description
        
        noteLabel.placeholder = "Note: (optional)"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatedUI()
        registerForKeyboardNotifications()
        toppingChangedNotification()
    }
    
    func toppingChangedNotification() {
        let name = Notification.Name("topping changed")
        NotificationCenter.default.addObserver(self, selector: #selector(changeToppingInfo), name: name, object: nil)
    }
    
    @objc func changeToppingInfo(noti: Notification) {
        if let userInfo = noti.userInfo,
           let selectedToppings = userInfo["selectedToppings"] as? [Topping] {
            
            toppingButton.setTitle("chosen \(selectedToppings.count)", for: .normal)
            self.selectedToppings = selectedToppings
            priceChangingFactor()
            
            for toppingTextField in toppingTextFields {
                toppingTextField.text = ""
            }
            
            if selectedToppings.count != 0 {
                for i in 0...selectedToppings.count-1 {
                    toppingTextFields[i].text = selectedToppings[i].toppingName
                }
            }
        }
        if let userInfo = noti.userInfo,
           let changedTopping = userInfo["toppings"] as? [Topping] {
            toppings = changedTopping
        }
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWasShown(_:)),name: UIResponder.keyboardDidShowNotification,object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillBeHidden(_:)),name: UIResponder.keyboardWillHideNotification,object: nil)
    }
    
    @objc func keyboardWasShown(_ notificiation: NSNotification) {
        guard let info = notificiation.userInfo,
              let keyboardFrameValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size
        
        let movingDistance = keyboardSize.height-(view.frame.size.height-scrollView.frame.maxY)
        
        scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: movingDistance, right: 0.0)
    }
    
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets.zero
    }
    
    //tap view to dismiss keyboatrd
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    //tap return to dismiss keyboatrd
    @IBAction func pressReturnToDissmissKeyboard(_ sender: Any) {
    }
    
    @IBAction func changeSize(_ sender: UISegmentedControl) {
        priceChangingFactor()
    }
    //tap sugarTextField to present picker view
    @IBAction func sugarTextField(_ sender: Any) {
        view.becomeFirstResponder()
    }
    //tap Cancel button to dismiss picker view
    @IBAction func pressCancel(_ sender: Any) {
        view.endEditing(true)
    }
    //tap Done button to show the selection on sugarLevel Text Field and dismiss picker view
    @IBAction func pressDone(_ sender: Any) {
        let row = pickerView.selectedRow(inComponent: 0)
        sugarLevel.text = sugarLevels[row].rawValue
        view.endEditing(true)
    }
    
    @IBSegueAction func showTopping(_ coder: NSCoder) -> ToppingTableViewController? {
        let controller = ToppingTableViewController(coder: coder)
        if let sheetPresentationController = controller?.sheetPresentationController {
            sheetPresentationController.detents = [.custom(resolver: { _ in
                300
            })]
        }
        return controller
    }
    
    @IBAction func changeQuantity(_ sender: Any) {
        
        let stepper = sender as! UIStepper
        stepper.minimumValue = 1
        quantityLabel.text = "Qty："+stepper.value.formatted(.number.precision(.fractionLength(0)))
        priceChangingFactor()
        
    }
    
    func priceChangingFactor() {
        toppingPrice = 0
        finalPrice = (record?.fields.price)!
        
        if size.selectedSegmentIndex == 0 {
            finalPrice = (record?.fields.price)!
        } else if size.selectedSegmentIndex == 1 {
            finalPrice = finalPrice + 1
        }
        
        for selectedTopping in selectedToppings {
            toppingPrice += Int(selectedTopping.toppingPrice! * 10)
        }
        
        finalPrice = finalPrice + (Double(toppingPrice) / 10)
        let quantity = quantityStepper.value
        finalPrice = finalPrice * quantity
        priceString = finalPrice.formatted(.number.precision(.fractionLength(1)))
        addOrderButton.setTitle( "ADD ORDER   $\(priceString)", for: .normal)
    }
    
    @IBAction func pressAddOrderButton(_ sender: Any) {
        
        guard sugarLevel.text?.isEmpty == false, sugarLevel.text != "Sugar Level" else {
            let controller = UIAlertController(title: "Please choose Sugar Level", message: nil, preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK", style: .default))
            present(controller, animated: true)
            return
        }
        //ice level string
        var showIceLevel = String()
        switch iceLevel.selectedSegmentIndex {
        case 0:
            showIceLevel = iceLevels[0].rawValue
        case 1:
            showIceLevel = iceLevels[1].rawValue
        default:
            return
        }
        //toppings string
        var selectedTopping = String()
        if selectedToppings.isEmpty == false {
            selectedToppings.forEach {
                selectedTopping = selectedTopping + $0.toppingName + ", "
            }
        } else {
            selectedTopping = "no topping"
        }
        //size string
        var showSize = String()
        switch size.selectedSegmentIndex {
        case 0:
            showSize = drinkSizes[0].rawValue
        case 1:
            showSize = drinkSizes[1].rawValue
        default:
            return
        }
        
        var alertMessage = String()

        if noteLabel.text?.isEmpty == true {
            alertMessage = "\(selectedTopping)\n\(sugarLevel.text!)\n\(showIceLevel)\n\(showSize) x \(quantityStepper.value.formatted(.number.precision(.fractionLength(0))))\n$ \(priceString)"
        } else {
            alertMessage = "\(selectedTopping)\n\(sugarLevel.text!)\n\(showIceLevel)\n\(showSize) x \(quantityStepper.value.formatted(.number.precision(.fractionLength(0))))\n$ \(priceString)\nNote: \(noteLabel.text!)"
        }
        
        let checkOrdertAlertController = UIAlertController(title: "\(drinkName.text!)", message: alertMessage, preferredStyle: .alert)
        
        checkOrdertAlertController.addAction(UIAlertAction(title: "Back", style: .destructive))
        
        checkOrdertAlertController.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
            
            let dataFormatter = DateFormatter()
            dataFormatter.dateFormat = "yyyy-MMM-dd HH:mm:ss"
            dataFormatter.timeZone = TimeZone.current
            let time = dataFormatter.string(from: .now)
            
            let createOderContent = CreateOrder.Record(id: nil, fields: CreateOrder.Record.OrderDetail(name: self.drinkName.text!, size: showSize, sugarLevel: self.sugarLevel.text!, iceLevel: showIceLevel, toppings: selectedTopping, quantity: Int(self.quantityStepper.value), note: self.noteLabel.text ?? "", time: time))
                
            OrderController.shared.postOrder(createOrder: createOderContent) { result in
                
                switch result {
                case .success(let response):
                    print(response)
                case .failure(let error):
                    print(error)
                }
            }
            self.navigationController?.popToRootViewController(animated: true)
        }))
        present(checkOrdertAlertController, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ToppingTableViewController {
            destination.toppings = toppings
            destination.selectedToppings = selectedToppings
        }
    }
    
}
