//
//  LoginViewController.swift
//  Covi-Vaccination
//
//  Created by Karan Chopra on 09/08/21.
//
//This file is used to control the login flow of the application. It uses core data to verify the user credentials and wuthenticate into the application.
//

//Importing core data module.
import UIKit
import CoreData

//Global variables declared to be used across application. Logged-in User details
var userEmail = "";
var userFname = "";
var userLname = "";
var userPhone = "";

class LoginViewController: UIViewController {
    
    //Managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    
    //List of Users, User is an entity defined in core data.
    var users : [User]?;

    // Connected IBoutlets from storyboard.
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Sign in button clicked.
    @IBAction func signInClicked(_ sender: Any) {
        
        //Get the login data from textfields
        let email = txtEmail.text;
        let password = txtPassword.text;
        
        // if data present, try to get the user from core data using email.
        if let email = email, let _ = password {
            getUser(email: email)
            return;
        }
        
        //Show error if data is not entered by user.
        showAlert(message: "Please enter login details");
    }
    
    //Method to get user from core data using the email.
    func getUser(email : String) {
        do {
            //Creating a NSFetchRequest for core data entity user.
            let userFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User");
            
            //Using predicate to search with email in core data.
            userFetchRequest.predicate = NSPredicate(format: "email == %@", email);

            //fetch user list matching the emial criteria.
            self.users = try context.fetch(userFetchRequest) as? [User];
            
            //check if password matches with the user and login
            if ((!users!.isEmpty) && (users?[0].password == txtPassword.text)) {
                userFname = users?[0].firstName ?? ""
                userLname = users?[0].lastName! ?? ""
                userEmail = users?[0].email! ?? ""
                userPhone = users?[0].phone! ?? ""
                
                //Navigate to home view after successfully login.
                self.performSegue(withIdentifier: "HomeViewSegue", sender: self);
                return;
            }
            
            //show error.
            showAlert(message: "Invalid Username/Password");
            
        } catch {
            print("Unable to fetch data from db.", error);
        }
    }
    
    //Show alert
    func showAlert(message : String) {
        let alert = UIAlertController(title: "Login", message: message, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .default) { (action)-> Void in }
        alert.addAction(okBtn);
        present(alert, animated: true, completion: nil);
    }
}
