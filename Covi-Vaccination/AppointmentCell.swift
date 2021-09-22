//
//  AppointmentCell.swift
//  Covi-Vaccination
//
//  Created by Anu Bala on 09/08/21.
//
// This class used to define a custom cell for My Appointments view to display custom stuff.
//

import UIKit

class AppointmentCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblHospital: UILabel!
    
    @IBOutlet weak var lblAppointment: UILabel!
    
    @IBOutlet weak var lblVaccine: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
