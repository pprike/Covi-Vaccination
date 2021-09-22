//
//  RegisterViewController.swift
//  Covi-Vaccination
//
//  Created by Annie Kaur on 09/08/21.
//
//  This controller is used to register user in to the system. User will be save in the core data.

import UIKit

class RegisterViewController: UIViewController {
    
    //Managed object context to save user.
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    
    @IBOutlet weak var fname: UITextField!
    @IBOutlet weak var lname: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    //User entity from core data.
    var users = [User]();

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //sign up button clicked.
    @IBAction func signUpClicked(_ sender: Any) {
        
        // Check data before submission
        if (validateFormData()) {
            
            //creating object of user entity to be save in core data.
            let user = User(context: self.context);
            user.firstName = fname.text!;
            user.lastName = lname.text!;
            user.email = txtEmail.text!;
            user.phone = txtPhone.text!
            user.password = txtPassword.text!
            
            //save data in core data for persistance.
            saveData();
            return;
        }
        showAlert(message: "Please Complete the missing Information!");
    }
    
    //save data to db.
    func saveData() {
        do {
            if (context.hasChanges) {
                //save the data in core data as user entity.
                try context.save();
                showAlert(message: "User Registered Successfully");
                clearData();
                return
            }
        } catch {
            print("Unable to save changes", error);
        }
    }
    
    
    // Validate data - if age is not between the given range it will show error
    func validateFormData() -> Bool {
        
        let isValidFname = isValid(textF: fname);
        let isValidLname = isValid(textF: lname);
        let isValidEmail = isValid(textF: txtEmail);
        let isValidPhone = isValid(textF: txtPhone);
        let isValidPass = isValid(textF: txtPassword);
        
        if (isValidFname && isValidLname && isValidEmail && isValidPhone && isValidPass) {
            return true;
        }
    
        return false;
    }
    // changing border color, if the textfield had invalid data.
    func isValid(textF : UITextField) -> Bool {
        if (!textF.hasText) {
            textF.layer.borderColor = UIColor.red.cgColor;
            textF.layer.borderWidth = 1.0;
            return false;
        }
        
        return true;
    }
    
    //Show alert if error.
    func showAlert(message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .default) { (action)-> Void in }
        alert.addAction(okBtn);
        present(alert, animated: true, completion: nil);
    }
    
    //clear data after registration.
    func clearData() {
        fname.text! = "";
        lname.text! = "";
        txtPhone.text! = "";
        txtEmail.text! = "";
        txtPassword.text! = "";
    }
    
    //to reset the error textfield style to normal
    @IBAction func txtEditingChanged(_ sender: Any) {
        let txf = sender as! UITextField;
        txf.layer.borderColor = .none;
        txf.layer.borderWidth = 0.0;
    }
}
