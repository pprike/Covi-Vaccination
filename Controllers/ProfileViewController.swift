//
//  ProfileViewController.swift
//  Covi-Vaccination
//
//  Created by Karan Chopra on 08/08/21.
//
// This class is used to show the details of the logged in user and logout from the application.

import UIKit

class ProfileViewController: UIViewController {
    
    //Outlets from storyboard to update values.
    @IBOutlet weak var txtFirstName: UITextField!
    
    @IBOutlet weak var txtLastName: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPhone: UITextField!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Fetching data from global variables created using login.
        txtFirstName.text = userFname
        txtLastName.text = userLname
        txtEmail.text = userEmail
        txtPhone.text = userPhone
    }

    // Logout will pop to root view controller, and take the user to login screen.
    @IBAction func btnLogout(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true);
    }
}
