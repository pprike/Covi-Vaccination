//
//  SearchViewController.swift
//  Covi-Vaccination
//
//  Created by Parikshit Murria on 07/08/21.
//
// This view controoler is used to book an appointment for the user after hospital selection.
// The appointment data is saved in the core data.
//

import UIKit
import CoreData

class BookSlotViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //Managed object context to be used to save the appointment.
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    

    //Hospital struct
    var hospital : HospitalDetails!;

    //Appointment Entity- This will be used to save the data.
    var appointment : [Appointment]?;
    
    //Outlets from storyboard to read/write values.
    @IBOutlet weak var txtHospital: UITextField!
        
    @IBOutlet weak var pickerVaccine: UIPickerView!
    
    @IBOutlet weak var txtFirstName: UITextField!
    
    @IBOutlet weak var txtLastName: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtAge: UITextField!
    
    @IBOutlet weak var slotPicker: UIDatePicker!
            

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Assigning picker delegates to read value on selection
        self.pickerVaccine.delegate = self
        self.pickerVaccine.dataSource = self
        
        //displaying the passed data from previous view.
        txtHospital.text = hospital.name;
        //Set the min date to now to prevent past appointment scheduling.
        slotPicker.minimumDate = Date();
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //components in picker.
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //the number of values in picker
        return Constants.vaccines.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //Display the title of the row visible to the user.
        return Constants.vaccines[row];
    }
    
    //to reset the error textfield style to normal
    @IBAction func txtEditingChanged(_ sender: Any) {
        let txf = sender as! UITextField;
        txf.layer.borderColor = .none;
        txf.layer.borderWidth = 0.0;
    }
    
    //Book button clicked
    @IBAction func btnBookClicked(_ sender: Any) {
        
        //Creating the new appointment entity to be saved in core data with the filled details.
        let newAppointment = Appointment(context: self.context);
        newAppointment.firstName = txtFirstName.text!;
        newAppointment.lastName = txtLastName.text!;
        newAppointment.email = txtEmail.text!;
        newAppointment.age =  Int64(txtAge.text!) ?? 0;
        newAppointment.vaccine = Constants.vaccines[pickerVaccine.selectedRow(inComponent: 0)];
        newAppointment.slot = slotPicker.date;
        newAppointment.hospital = hospital.name;
        newAppointment.user = userEmail;
        
        //Data is validated befire saving in to core data.
        if (validateFormData()) {
            saveData();
            clearData();
            
            //set a badge on the tab bar item My appointments to represent new addition.
            tabBarController?.tabBar.items?[2].badgeValue = "New";

            //success alert
            showAlert(message: "Booked Successfully. \n Please reach 15 minutes before scheduled time");
        }
    }
    
    //save data to db.
    func saveData() {
        do {
            // if changes made to the appointment then save.
            if (context.hasChanges) {
                return try context.save();
            }
        } catch {
            print("Unable to save changes", error);
        }
    }
    
    //clear all the fields after new entry has been added.
    func clearData() {
        txtFirstName.text! = "";
        txtLastName.text! = "";
        txtEmail.text! = "";
        txtAge.text! = "";
        // select row index to 0;
        pickerVaccine.selectRow(0, inComponent: 0, animated: true);
        slotPicker.date = Date();
    }
    
    //show alert to inform user.
    func showAlert(message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .default) { (action)-> Void in }
        alert.addAction(okBtn);
        present(alert, animated: true, completion: nil);
    }
    
    // Validate data - if age is not between the given range it will show error
    func validateFormData() -> Bool {
        
        let isValidFname = isValid(textF: txtFirstName);
        let isValidLname = isValid(textF: txtLastName);
        let isValidEmail = isValid(textF: txtEmail);
        let isValidAge = isValid(textF: txtAge);
        
        if (isValidFname && isValidLname && isValidEmail && isValidAge) {
            let age = Int(txtAge.text!)
            
            if ((age != nil) && (age! > 0 && age! <= 100)) {
                return true;
            }
            
            //update border color if error.
            txtAge.layer.borderColor = UIColor.red.cgColor;
            txtAge.layer.borderWidth = 1.0;
            showAlert(message: "Please enter valid age")
            return false;
        }
        
        showAlert(message: "Please Complete the missing Information!");
        return false;
    }
    
    //update border color if error.
    func isValid(textF : UITextField) -> Bool {
        if (!textF.hasText) {
            textF.layer.borderColor = UIColor.red.cgColor;
            textF.layer.borderWidth = 1.0;
            return false;
        }
        
        return true;
    }
}
