//
//  TripCell.swift
//  Trip Tracker
//
//  Created by Fiona Au on 10/29/21.
//

import UIKit
import CoreData

class TripCell: UITableViewCell {

    @IBOutlet weak var purposeImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mainCompanionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!

    let purposeModel = PurposeType()
    let dateFormatter = DateFormatter()
    
    // hrs to be localized
    var hrs = NSLocalizedString("hrs", comment: "")
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        //hrs = NSLocalizedString("hrs", comment: "")

        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func update(with item: Trip) {
        
        if let location = item.value(forKey: "location") as? String,
           let mainCompanion = item.value(forKey: "mainCompanion") as? String,
           let purpose = item.value(forKey: "purpose") as? String,
           let date = item.value(forKey: "date") as? Date,
           let duration = item.value(forKey: "duration") as? Double {
                
            locationLabel?.text = location
            
            if !(mainCompanion.elementsEqual("")) {
                mainCompanionLabel?.text = mainCompanion
            } else {
                mainCompanionLabel?.text = NSLocalizedString("str_self", comment: "")

            }
            purposeImageView.image = purposeModel.image(purpose: purpose)

            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            
            dateLabel?.text = dateFormatter.string(from: date) // Jan 2, 2001
            let durationAsString = String(duration)
            durationLabel?.text = (durationAsString + " " + hrs)

            
        }
    }

}
