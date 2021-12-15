//
//  EditVC.swift
//  Trip Tracker
//
//  Created by Fiona Au on 10/29/21.
//

import UIKit
import CoreData

class EditVC: UIViewController {
    
    // strings to be localized
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var purposeLabel: UILabel!
    @IBOutlet weak var mainCompanionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var hoursSpentLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var purposePicker: UIPickerView!
    @IBOutlet weak var mainCompanionField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var durationStepper: UIStepper!
    
    let purposeModel = PurposeType()
    var purposeChoice = 10
    
    var date = Date()
    var hours = 0.0 {
        willSet {
            durationLabel.textColor = datePicker.tintColor
            durationLabel?.text = newValue.description
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationField.textColor = datePicker.tintColor
        mainCompanionField.textColor = datePicker.tintColor
        
        // strings being localized
        locationLabel.text = NSLocalizedString("str_locationLabel", comment: "")
        purposeLabel.text = NSLocalizedString("str_purposeLabel", comment: "")
        mainCompanionLabel.text = NSLocalizedString("str_mainCompanionLabel", comment: "")
        dateLabel.text = NSLocalizedString("str_dateLabel", comment: "")
        hoursSpentLabel.text = NSLocalizedString("str_hoursSpentLabel", comment: "")
        cancelButton.setTitle(NSLocalizedString("str_cancelButton", comment: ""), for: .normal)
        saveButton.setTitle(NSLocalizedString("str_saveButton", comment: ""), for: .normal)

        durationStepper.value = 0
        durationStepper.stepValue = 0.5
        durationStepper.maximumValue = 10.0
        durationStepper.minimumValue = 0.0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { // every view has a touchesBegan, touchesEnd
        view.endEditing(true) // detects that view has received a tap -> then no more editing
    }
    
    func saveItem(location: String, mainCompanion: String) {
        let context = AppDelegate.cdContext
        if let entity = NSEntityDescription.entity(forEntityName: "Trip", in: context) {
            let item = NSManagedObject(entity: entity, insertInto: context)
            item.setValue(location, forKeyPath: "location")
            item.setValue(mainCompanion, forKeyPath: "mainCompanion")
            purposeChoice = purposePicker.selectedRow(inComponent: 0)
            item.setValue(purposeModel.purpose(choice: purposeChoice), forKeyPath: "purpose")
            item.setValue(date, forKeyPath: "date")
            item.setValue(durationStepper.value, forKeyPath: "duration")
            
            do {
                try context.save()
            } catch let error as NSError {
                print("Could not save the item. \(error), \(error.userInfo)")
            }
        }
    }
    
    @IBAction func onDateChange(_ sender: UIDatePicker) {
//        datePicker.subviews[0].subviews[0].subviews[2].backgroundColor = datePicker.tintColor;
        datePicker.subviews[0].subviews[0].backgroundColor = datePicker.tintColor;
        date = sender.date
    }
    
    @IBAction func onDurationChanged(_ sender: UIStepper) {
//        durationStepper.
        hours = durationStepper.value
    }
    
    @IBAction func onCancel(_ sender: Any) {
        presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func onSave(_ sender: Any) {
        if let location = locationField?.text, let mainCompanion = mainCompanionField?.text {
            saveItem(location: location, mainCompanion: mainCompanion)
        }
        presentingViewController?.dismiss(animated: true)
    }
    
}

// extending EditVC

extension EditVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return purposeModel.choices.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return purposeModel.choices[row]
    }
    
//    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//            var color: UIColor!
//            if pickerView.selectedRowInComponent(component) == row {
//                color = UIColor.redColor()
//            } else {
//                color = UIColor.blackColor()
//            }
//
//            let attributes: [String: AnyObject] = [
//                NSForegroundColorAttributeName: color,
//                NSFontAttributeName: UIFont.systemFontOfSize(15)
//            ]
//
//            return NSAttributedString(string: rows[row], attributes: attributes)
//        }

        func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            //this will trigger attributedTitleForRow-method to be called
//            pickerView.
            pickerView.reloadAllComponents()
        }
    
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           pickerView.subviews[0].subviews[0].backgroundColor = pickerView.tintColor;
        }
}
