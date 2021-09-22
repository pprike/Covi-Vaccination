//
//  MyAppointmentsViewController.swift
//  Covi-Vaccination
//
//  Created by Anu Bala
//

import UIKit
import CoreData

class MyAppointmentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    //Managed object context to fetch and save appointments.
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;

    @IBOutlet weak var tbAppointments: UITableView!
    
    //dataformatter instance created to format dates.
    let dateFormatter = DateFormatter();

    // Appointment entity from core data.
    var appointments = [Appointment]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableview deleagates assigned to self to handle events.
        tbAppointments.delegate = self;
        tbAppointments.dataSource = self;
        
        //date format set for conversion
        dateFormatter.dateFormat = "dd/MM/yy, hh:mm a";
    }
    
    //Whenever view appears after changing the tab data is reloaded from core data.
    // also badge is removed, if any.
    override func viewWillAppear(_ animated: Bool) {
        loadAllAppointments();
        tabBarItem.badgeValue = nil;
    }
    
    func loadAllAppointments() {
        do {
            //Creating NSFetchrequest for appointment entity.
            let appointmentFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Appointment");
            //using predicate to search for all appointments belonging to the user using email.
            appointmentFetchRequest.predicate = NSPredicate(format: "user == %@", userEmail);
            
            //fetching appointments.
            self.appointments = try (context.fetch(appointmentFetchRequest) as? [Appointment] ?? []);
            
            //Reload table on main thread asynchronously.
            DispatchQueue.main.async {
                self.tbAppointments.reloadData()
            }
            
        } catch {
            print("Unable to fetch data from db.", error);
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        appointments.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //This helps in reusing the created cells.
        let cell = tableView.dequeueReusableCell(withIdentifier: "appointmentCell", for: indexPath) as! AppointmentCell;
        
        //setting text label on cell.
        cell.lblName.text = "\(self.appointments[indexPath.row].lastName!), \(self.appointments[indexPath.row].firstName!)";
        cell.lblHospital.text = self.appointments[indexPath.row].hospital!;

        // Convert Date to String
        cell.lblAppointment.text = "\( dateFormatter.string(from: self.appointments[indexPath.row].slot!))";
        cell.lblVaccine.text = self.appointments[indexPath.row].vaccine!;

        return cell;
    }
    
    //Using swipe actions to enable delete on the appointments.
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style:.destructive, title: "Delete") { (action, view, handler) in
            //deleting appointment from core data/.
            self.context.delete(self.appointments[indexPath.row]);
            //saving the context after appointment is deleted.
            self.saveData();
            //reload all appointments.
            self.loadAllAppointments();
        }
        
        return UISwipeActionsConfiguration(actions: [action]);
    }
    
    // on row click edit the appointment.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appointment = self.appointments[indexPath.row];
        updateAppointment(appointment: appointment);
    }
    
    
    func updateAppointment(appointment : Appointment) {
        
        //Creating update alert
        let alert = UIAlertController(title: "My Appointment", message: "Update Details", preferredStyle: .alert)
        
        //Alert Ok btn
        let okBtn = UIAlertAction(title: "OK", style: .default) { (action)-> Void in
            
            //Getting values from textfields embedded in alert.
            let textfieldFname = alert.textFields![0]
            let textfieldLname = alert.textFields![1]
            
            // if any of the field is empty. DOn't update.
            if ((textfieldFname.text!.isEmpty) || (textfieldLname.text!.isEmpty)) {
                print("Not adding blank to the list");
                return;
            }
        
            // update appointment details from text field.
            appointment.firstName = textfieldFname.text!
            appointment.lastName = textfieldLname.text!

            //calls context to save appointment.
            self.saveData();
            
            //reload appointments.
            self.loadAllAppointments();
        }
        
        //Alert Cancel btn
        let cancel = UIAlertAction(title: "Cancel", style: .destructive) { (action) -> Void in
        }
                
        //Adding two textfields to alert.
        
        //Adding textfield to alert.
        alert.addTextField{ (textfield: UITextField) in
            textfield.keyboardType = .default;
            textfield.keyboardAppearance = .default;
            textfield.autocorrectionType = .default;
            textfield.placeholder = "First Name";
            textfield.clearButtonMode = .whileEditing;
    
            textfield.text = appointment.firstName;
        }
        
        //Adding textfield to alert.
        alert.addTextField{ (textfield: UITextField) in
            textfield.keyboardType = .default;
            textfield.keyboardAppearance = .default;
            textfield.autocorrectionType = .default;
            textfield.placeholder = "Last Name";
            textfield.clearButtonMode = .whileEditing;
    
            textfield.text = appointment.lastName;
        }
        
        //Adding action to alert in order specific manner.
        alert.addAction(cancel);
        alert.addAction(okBtn);
        
        //show alert.
        present(alert, animated: true, completion: nil)
    }
    
    //save data to db.
    func saveData() {
        do {
            if (context.hasChanges) {
                return try context.save();
            }
        } catch {
            print("Unable to save changes", error);
        }
    }
}
