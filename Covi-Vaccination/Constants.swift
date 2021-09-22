//
//  Constants.swift
//  Covi-Vaccination
//
//  Created by Parikshit Murria on 07/08/21.
//
//This file is used to maintain the constants at single place and can be used across the application.

import UIKit

struct Constants {
        
    static let vaccines = ["Covishield", "Covaxin", "Pfizer", "Astrazenca", "Moderna"]
    
    //cowin base url
    static let cowinUrl : String = "https://api.cowin.gov.in/api/v1/reports/v2/getPublicReports?date=";

}
