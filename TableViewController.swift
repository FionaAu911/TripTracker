//
//  TableViewController.swift
//  Trip Tracker
//
//  Created by Fiona Au on 10/28/21.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var trips: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("str_appName", comment: "")

        readData()
    }
    
//    @IBAction func didTapMyLocalizedBarButtonItem(_ sender: Any) {
//        print("Custom bar button item tapped.")
//    }
    
    func deletionAlert(location: String, completion: @escaping (UIAlertAction) -> Void) {
        let alertMsg = NSLocalizedString("str_Hey!", comment: "") + " " + location + "?"
        let alert = UIAlertController(title: NSLocalizedString("str_Warning", comment: ""), message: alertMsg, preferredStyle: .actionSheet)

        let deleteAction = UIAlertAction(title: NSLocalizedString("str_Delete", comment: ""), style: .destructive, handler: completion)
        let cancelAction = UIAlertAction(title: NSLocalizedString("str_Cancel!", comment: ""), style: .cancel)

        alert.addAction(deleteAction)
        alert.addAction(cancelAction)

        alert.popoverPresentationController?.permittedArrowDirections = []
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.frame.midX, y: self.view.frame.midY, width: 0, height: 0)

        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TripCell") as? TripCell else {
            fatalError("Expected TripCell")
        }

        if let item = trips[indexPath.row] as? Trip {
            cell.update(with: item)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let trip = trips[indexPath.row] as? Trip, let location = trip.location {
                deletionAlert(location: location, completion: { _ in
                    self.deleteItem(trip: trip)
                })
            }
        }
    }
    
    // MARK: - CoreData
    
    func readData() {
        let context = AppDelegate.cdContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Trip")
        do {
            trips = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch requested item. \(error), \(error.userInfo)")
        }
        tableView.reloadData()
    }
    
    func deleteItem(trip: Trip) {
        let context = AppDelegate.cdContext
        if let _ = trips.firstIndex(of: trip)  {
            context.delete(trip)
            do {
                try context.save()
            } catch let error as NSError {
                print("Could not delete the item. \(error), \(error.userInfo)")
            }
        }
        readData()
    }
    
    // MARK: - Actions
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {
        readData()
        tableView.reloadData()
    }
    
}
