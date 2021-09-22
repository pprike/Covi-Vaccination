//
//  ViewController.swift
//  Covi-Vaccination
//
//  Created by Krishna Bulsara on 06/08/21.
//
// This class is used to handle the home view controller and manage data on the dashboard.

import UIKit

class HomeViewController: UIViewController {
    
    // Connected IBoutlets from storyboard.
    
    @IBOutlet weak var lblTotalVax: UILabel!
    
    @IBOutlet weak var lblDose1Vax: UILabel!
    
    @IBOutlet weak var lblDose2Vax: UILabel!
    
    @IBOutlet weak var lblTotalTodayVax: UILabel!
    
    @IBOutlet weak var lblTotalCenters: UILabel!
    
    @IBOutlet weak var lblGovtCenters: UILabel!
    
    @IBOutlet weak var lblPrivateCenters: UILabel!
    
    @IBOutlet weak var lblTotalRegs: UILabel!
    
    @IBOutlet weak var lbl18Regs: UILabel!
    
    @IBOutlet weak var lbl45Regs: UILabel!
    
    @IBOutlet weak var lblTodayRegs: UILabel!
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    
    // Creating a URL ssession required to make an API call.
    let urlSession = URLSession(configuration: .default);
    
    //Numberformatter used to format the recieved stats.
    let numberFormatter = NumberFormatter()
    
    //dateFormatter used to present and save the data in required format.
    let dateFormatter = DateFormatter();

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Updating logged in user name from global variable after login.
        welcomeLabel.text = "Welcome, \(userFname)";
        
        //number formater style in which data will be formatted.
        numberFormatter.numberStyle = .decimal
        
        //date format style in which date will be formatted.
        dateFormatter.dateFormat = "yy-MM-dd";
        
        //URL for the cowin api by appending today's date as per format.
        let url = "\(Constants.cowinUrl)\(dateFormatter.string(from: Date()))"
        
        //fetch data and populate dashboard.
        fetchCovidData("\(url)");
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Hiding the nav bar for asthetics.
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func fetchCovidData(_ url : String) {
        
        //Converting string to URL.
        let url = URL(string: url);
        
        // if url present, Do the following
        if let url = url {
            
            //creating a datatask with the given url
            let dataTask = urlSession.dataTask(with: url) { (data, response, err) in
                
                //Handle error and return if found
                if let err = err {
                    print("Error occured while fetching cowin data: \(err)");
                    return;
                }
                
                //Decoding response using json decoder.
                if let data = data {
                    //Creating JSON decoder to decode data.
                    let jsonDecoder = JSONDecoder();
                    
                    do {
                        //Trying to decode the data and get the Cowin struct.
                        let readableData = try jsonDecoder.decode(CowinData.self, from: data)
                        
                        //Updating the dashboards on the main thread using dispatcher. UI can only be updated on main thread.
                        DispatchQueue.main.async {
                            self.updateDashboard(data: readableData);
                        }
                    }
                    catch {
                        print("Exception while decoding JSON: \(error)")
                    }
                }
            }
            //To execure the data task we need to resume it.
            dataTask.resume();
        }
    }
    
    
    //This method will update the UI elements using the COwin data received from the URL after decoding.
    func updateDashboard(data : CowinData) {
        
        let vaxData = data.topBlock.vaccination
        let centerData = data.topBlock.sites
        let regData = data.topBlock.registration

        lblTotalVax.text =  numberFormatter.string(from: NSNumber(value:vaxData.total))
        lblTotalTodayVax.text = numberFormatter.string(from: NSNumber(value:vaxData.today));
        lblDose1Vax.text =  numberFormatter.string(from: NSNumber(value:vaxData.tot_dose_1));
        lblDose2Vax.text = numberFormatter.string(from: NSNumber(value:vaxData.tot_dose_2));
        
        lblTotalCenters.text = numberFormatter.string(from: NSNumber(value:centerData.total));
        lblGovtCenters.text = numberFormatter.string(from: NSNumber(value:centerData.govt));
        lblPrivateCenters.text = numberFormatter.string(from: NSNumber(value:centerData.pvt));
        
        lblTotalRegs.text = numberFormatter.string(from: NSNumber(value:regData.total));
        lblTodayRegs.text = numberFormatter.string(from: NSNumber(value:regData.today));
        lbl18Regs.text = numberFormatter.string(from: NSNumber(value:regData.cit_18_45));
        lbl45Regs.text = numberFormatter.string(from: NSNumber(value:regData.cit_45_above));
    }
    
    //Button action, It will take the user to next Tab.
    @IBAction func btnGetVaxClicked(_ sender: Any) {
        //setting Tab item index.
        self.tabBarController?.selectedIndex = 1;
    }
}
