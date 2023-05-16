//
//  TripFormController.swift
//  Gazelle
//
//  Created by Angela Li Montez on 4/25/23.
//

import UIKit
import ParseSwift

class TripFormController: UIViewController {

    @IBOutlet weak var tripName: UITextField!
    @IBOutlet weak var tripDescription: UITextField!
    @IBOutlet weak var tripLocation: UITextField!
    @IBOutlet weak var tripStartDate: UIDatePicker!
    @IBOutlet weak var tripEndDate: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeHideKeyboard()
    }
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        if (tripName.text == "" || tripLocation.text == "") {
            print("Empty")
            tripFieldRequredAlert()
        } else {
            performSegue(withIdentifier: "unwindToTrips", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let TripsViewController = segue.destination as? TripsViewController {
            // Create new Trip object
            var newTrip = Trip()
            
            // Set Properties
            newTrip.title = tripName.text
            newTrip.description = tripDescription.text
            newTrip.userId = User.current?.objectId as String?
            newTrip.location = tripLocation.text
            newTrip.startDate = formatDate(tripStartDate)
            newTrip.endDate = formatDate(tripEndDate)
            
            TripsViewController.newTrip = newTrip
        }
    }
}
