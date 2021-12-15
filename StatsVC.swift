//
//  StatsVC.swift
//  Trip Tracker
//
//  Created by Fiona Au on 10/31/21.
//

import UIKit
import CoreData

class StatsVC: UIViewController {

    var trips: [NSManagedObject] = []

    var totalTrips = 0
    var totalDuration = 0.0
    var totalWorkDuration = 0.0
    var totalSchoolDuration = 0.0
    var totalMedicalDuration = 0.0
    var totalErrandDuration = 0.0
    var totalHangoutDuration = 0.0
    var companions = [String]()
    var locations = [String]()
    var mostFrequentLocation = ("", 0)
    var mostFrequentCompanion = ("", 0)
    var mostVisited = ""
    var bestCompanion = ""
    var mostTimeOnPurpose = ""
    var sortTheseLocations = [String]()
    var sortTheseCompanions = [String]()
    
    // "Label" #1
    @IBOutlet weak var totalTripsLabel: UILabel!
    @IBOutlet weak var totalCompanions: UILabel!
    @IBOutlet weak var totalDurationLabel: UILabel!
    
    // "Label" #2
    @IBOutlet weak var mostVisitedLocationLabel: UILabel!
    @IBOutlet weak var bestCompanionLabel: UILabel!
    @IBOutlet weak var mostTimeSpentOnLabel: UILabel!
    
    // "Total Number of Trips"
    @IBOutlet weak var totalNumberofTripsLabel: UILabel!
    @IBOutlet weak var totalNumberofCompanionsLabel: UILabel!
    @IBOutlet weak var totalTimeSpentOnTripsLabel: UILabel!

    // "Most Visited"
    @IBOutlet weak var mostVisitedLabel: UILabel!
    @IBOutlet weak var theBestCompanionLabel: UILabel!
    @IBOutlet weak var mostTimeSpentOnPurposeLabel: UILabel!

    // "Show"
    @IBOutlet weak var onShowMostVisitedButton: UIButton!
    @IBOutlet weak var onShowBestCompanionButton: UIButton!
    @IBOutlet weak var onMostTimeSpentOnPurposeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // "Total Number of Trips"
        totalNumberofTripsLabel.text = NSLocalizedString("str_totalNumberOfTripsLabel", comment: "")
        totalNumberofCompanionsLabel.text = NSLocalizedString("str_totalNumberofCompanionsLabel", comment: "")
        totalTimeSpentOnTripsLabel.text = NSLocalizedString("str_totalTimeSpentOnTripsLabel", comment: "")

        // "Most Visited"
        mostVisitedLabel.text = NSLocalizedString("str_mostVisitedLabel", comment: "")
        theBestCompanionLabel.text = NSLocalizedString("str_theBestCompanionLabel", comment: "")
        mostTimeSpentOnPurposeLabel.text = NSLocalizedString("str_mostTimeSpentOnPurposeLabel", comment: "")

        // "Show"
        onShowMostVisitedButton.setTitle(NSLocalizedString("str_onShowMostVisitedButton", comment: ""), for: .normal)
        onShowBestCompanionButton.setTitle(NSLocalizedString("str_onShowBestCompanionButton", comment: ""), for: .normal)
        onMostTimeSpentOnPurposeButton.setTitle(NSLocalizedString("str_onMostTimeSpentOnPurposeButton", comment: ""), for: .normal)
        
        prepareScreen()
        updateScreen()
    }
    
    func prepareScreen() {
        let context = AppDelegate.cdContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Trip")
        do {
            trips = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch requested item. \(error), \(error.userInfo)")
        }
        
        for item in trips {
            
            if let location = item.value(forKey: "location") as? String,
               let mainCompanion = item.value(forKey: "mainCompanion") as? String,
               let purpose = item.value(forKey: "purpose") as? String,
               let duration = item.value(forKey: "duration") as? Double {
                
                if !locations.contains(location) {
                    locations.append(location)
                }
                sortTheseLocations.append(location)
                                
                totalDuration = totalDuration + duration
                switch purpose {
                    case "Work":
                        totalWorkDuration = totalWorkDuration + duration
                    case "School":
                        totalSchoolDuration = totalSchoolDuration + duration
                    case "Medical":
                        totalMedicalDuration = totalMedicalDuration + duration
                    case "Errand":
                        totalErrandDuration = totalErrandDuration + duration
                    case "Hangout":
                        totalHangoutDuration = totalHangoutDuration + duration
                    default:
                        print("something's wrong")
                }
                                
                if !companions.contains(mainCompanion) {
                    companions.append(mainCompanion)
                }
                sortTheseCompanions.append(mainCompanion)
            }
        }
        if let mostFrequentLocation = mostFrequent(array: sortTheseLocations) {
            mostVisited = mostFrequentLocation.value
            print("\(mostFrequentLocation.value) occurs \(mostFrequentLocation.count) times")
        }
        if let mostFrequentCompanion = mostFrequent(array: sortTheseCompanions) {
            bestCompanion = mostFrequentCompanion.value
            print("\(mostFrequentCompanion.value) occurs \(mostFrequentCompanion.count) times")
        }
        
        mostVisitedLocationLabel.alpha = 0.0
        bestCompanionLabel.alpha = 0.0
        mostTimeSpentOnLabel.alpha = 0.0
    }
    
    func updateScreen() {
        totalTripsLabel?.text = String(trips.count)
        totalCompanions?.text = String(companions.count)
        totalDurationLabel?.text = String(totalDuration)
        
        mostVisitedLocationLabel.text = mostVisited
        if !(bestCompanion.elementsEqual("")) {
            bestCompanionLabel.text = bestCompanion
        } else {
            bestCompanionLabel.text = NSLocalizedString("str_self", comment: "")
        }
        mostTimeOnPurpose = mostTimeOn()
        mostTimeSpentOnLabel.text = mostTimeOnPurpose
    }
    
    func mostFrequent<String: Hashable>(array: [String]) -> (value: String, count: Int)? {
        let counts = array.reduce(into: [:]) { $0[$1, default: 0] += 1 }

        if let (value, count) = counts.max(by: { $0.1 < $1.1 }) {
            return (value, count)
        }

        return nil
    }
    
    func mostTimeOn() -> String {
        let arrayOfDurations = [totalWorkDuration, totalSchoolDuration, totalMedicalDuration, totalErrandDuration, totalHangoutDuration]
        let maxValue = max(array: arrayOfDurations)
        if totalWorkDuration == maxValue {
            return "Work"
        } else if totalSchoolDuration == maxValue {
            return "School"
        } else if totalMedicalDuration == maxValue {
            return "Medical"
        } else if totalErrandDuration == maxValue {
            return "Errand"
        } else {
            return "Hangout"
        }
    }
    
    func max(array: [Double]) -> Double {
        let largest = array.max()
        return largest!
    }
    
    @IBAction func onShowMostVisited(_ sender: Any) {
        mostVisitedLocationLabel.alpha = 1.0
    }
    
    @IBAction func onShowBestCompanion(_ sender: Any) {
        bestCompanionLabel.alpha = 1.0
    }
    
    @IBAction func onShowMostTimeSpentOn(_ sender: Any) {
        mostTimeSpentOnLabel.alpha = 1.0
        alertingAlert()
    }
    
    
    func alertingAlert() -> Void {
        var alertMsg = ""
        switch mostTimeOnPurpose {
            case "Work":
                alertMsg = NSLocalizedString("str_workAlert", comment: "")
            case "School":
                alertMsg = NSLocalizedString("str_schoolAlert", comment: "")
            case "Medical":
                alertMsg = NSLocalizedString("str_medicalAlert", comment: "")
            case "Errand":
                alertMsg = NSLocalizedString("str_errandAlert", comment: "")
            case "Hangout":
                alertMsg = NSLocalizedString("str_hangoutAlert", comment: "")
            default:
                print("something's wrong")
        }
        let alert = UIAlertController(title: NSLocalizedString("str_Hey!", comment: ""), message: alertMsg, preferredStyle: .actionSheet)
        let gotIt = UIAlertAction(title:NSLocalizedString("str_GotIt", comment: ""), style: .cancel)

        alert.addAction(gotIt)

        alert.popoverPresentationController?.permittedArrowDirections = []
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.frame.midX, y: self.view.frame.midY, width: 0, height: 0)

        present(alert, animated: true, completion: nil)
    }
       
    
}
