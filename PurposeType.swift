//
//  PurposeType.swift
//  Trip Tracker
//
//  Created by Fiona Au on 10/29/21.
//

import Foundation
import UIKit

class PurposeType {

    var work = NSLocalizedString("str_work", comment: "")
    var school = NSLocalizedString("str_school", comment: "")
    var medical = NSLocalizedString("str_medical", comment: "")
    var errand = NSLocalizedString("str_errand", comment: "")
    var hangout = NSLocalizedString("str_hangout", comment: "")
    
    lazy var choices = [work, school, medical, errand, hangout]
    
    func purpose(choice: Int) -> String {
        switch choice {
        case 0:
            return "Work"
        case 1:
            return "School"
        case 2:
            return "Medical"
        case 3:
            return "Errand"
        case 4:
            return "Hangout"
        default:
            return "NA"
        }
    }
    
    func image(purpose: String) -> UIImage? {
        switch purpose {
            case "Work":
                return UIImage(systemName: "tray")
            case "School":
                return UIImage(systemName: "book")
            case "Medical":
                return UIImage(systemName: "cross.case")
            case "Errand":
                return UIImage(systemName: "checkmark.circle")
            case "Hangout":
                return UIImage(systemName: "person.3")
            default:
                return UIImage(systemName: "pencil")
        }
    }
}

