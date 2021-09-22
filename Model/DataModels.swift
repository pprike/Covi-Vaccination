//
//  DataModels.swift
//  Covi-Vaccination
//
//  Created by Parikshit Murria on 08/08/21.
//

// This class is used to maintain the struct which are used across the application.
// This helps in segregation of models.
//


//Importing map kit for CLLocation
import Foundation
import MapKit

// To prepare the result list after MKLocalsearch and pass the data across
struct HospitalDetails {
    var name : String;
    var address : String;
    var location : CLLocation;
}

// Below Codable are used for de-serialization of JSON data that we get from Cowin API.
struct CowinData : Codable {
    var topBlock : TopBlock
}

struct TopBlock : Codable {
    var vaccination : Vaccination
    var registration : Registration
    var sites : Sites
}

struct Vaccination : Codable {
    var total : UInt64
    var today : UInt64
    var covishield : UInt64
    var covaxin : UInt64
    var sputnik : UInt64
    var tot_dose_1: UInt64
    var tot_dose_2: UInt64
}

struct Registration : Codable {
    var total : UInt64
    var today : UInt64
    var cit_18_45 : UInt64
    var cit_45_above : UInt64
}

struct Sites : Codable {
    var total : UInt64
    var govt : UInt64
    var pvt : UInt64
}
