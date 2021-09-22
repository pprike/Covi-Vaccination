//
//  HospitalListViewController.swift
//  Covi-Vaccination
//
//  Created by Parikshit Murria on 07/08/21.
//
// This view controller is used to show hospitals on the map near your location and list them on a table view.
// The user can select the hospital and move to the booking view.

//Using map kit for maps.
import UIKit
import MapKit
import CoreLocation

//using CLlocation manager, table view delegate and datasource to be listen to events and populate data.
class HospitalListViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    //Map viw
    @IBOutlet weak var mapView: MKMapView!
    
    //Table view
    @IBOutlet weak var hospitalListTableView: UITableView!
    
    //Location manage to get the locations.
    let locationManager = CLLocationManager();
    
    //Hospital list.
    var hospitals = [HospitalDetails]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting up location manager.
        locationManager.delegate = self;
        locationManager.requestWhenInUseAuthorization();
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true;
        mapView.isZoomEnabled = true
        
        //Assigning delegates to self, so that the events are recieved.
        hospitalListTableView.delegate = self;
        hospitalListTableView.dataSource = self;
        
        //Initializing default location when app opens.
        let defaultLocation : [CLLocation] = [CLLocation(latitude: 43.466667, longitude: -80.516670)];
        locationManager(locationManager, didUpdateLocations: defaultLocation);
    }
    
    // This delegate is used to update the hospital list when location is updated.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //  get first location and pass it futher.
        if let location = locations.first {
            zoom(location)
            updateHospitalList(location)
        }
    }
    
    // zoom and set the region on map.
    func zoom(_ location: CLLocation) {
        
        // Fetching coordinates of the location
        let coodinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        // Defines the span required by the map region.
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        
        //setting region to be shown on Map.
        let region = MKCoordinateRegion(center: coodinate, span: span);
        mapView.setRegion(region, animated: true)
    }
    
    func  addToHospitalList(_ name: String, _ address: String, _ location: CLLocation) {
        //Creating new hospital details object to save in the list
        let hospital = HospitalDetails(name: name, address: address, location: location);
        hospitals.append(hospital);
    }

    func updateHospitalList(_ location: CLLocation) {
        
        //Using the MKLocal search to search hospitals nearby on the mop.
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = "Hospital"
        
        //array for annotations
        var allAnnotations = [MKAnnotation]();

        // Set the region to an associated map view's region.
        searchRequest.region = mapView.region

        //Initialise search with search request.
        let search = MKLocalSearch(request: searchRequest)
        
        //Start searching.
        search.start { (response, error) in
            //preventing error using guard for null response.
            guard let response = response else {
                print(error!);
                return;
            }
            
            //Clear previous result.
            self.hospitals.removeAll();
                        
            for item in response.mapItems {
                //check if item has a name and location
                if let name = item.name,
                    let location = item.placemark.location {
                    //Nil-collascing operator to prevent null pointers.
                    let address = item.placemark.thoroughfare ?? ""
                    
                    //Creating annnotation with hospital coordinates.
                    let pin = MKPointAnnotation();
                    pin.coordinate = location.coordinate;
                    pin.title = name;
                    pin.subtitle = address;
                    allAnnotations.append(pin)
                    
                    //adding to hospitals to be used for table
                    self.addToHospitalList(name, address, location);
                }
                
                //add all the annotations in the list to show on map.
                self.mapView.showAnnotations(allAnnotations, animated: true);
                
                //Update table.
                self.hospitalListTableView.reloadData();
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //row count of table.
        return hospitals.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //This helps in reusing the created cells.
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath);
        
        //setting labels on cell.
        cell.textLabel?.text = self.hospitals[indexPath.row].name;
        cell.detailTextLabel?.text = self.hospitals[indexPath.row].address;
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        return cell;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //header section text
        return "Available Hospitals"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //navigate to book slot.
        performSegue(withIdentifier: "bookslot", sender: indexPath.row);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //passing selected hospital next view controller.
        let bookSlotViewController = segue.destination as! BookSlotViewController
        bookSlotViewController.hospital = hospitals[sender as! Int];
    }
}
