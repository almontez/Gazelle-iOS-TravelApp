//
//  ItineraryFormController.swift
//  Gazelle
//
//  Created by Angela Li Montez on 4/24/23.
//

import UIKit
import ParseSwift

class ItineraryFormController: UIViewController {
    
    var tripId: String?

    @IBOutlet weak var eventTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeHideKeyboard()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if (eventTextField.text == "" || locationTextField.text == "") {
            itineraryItemFieldRequredAlert()
        } else {
            performSegue(withIdentifier: "unwindToItinerary", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ItineraryViewController = segue.destination as? ItineraryViewController {
            // Create Itinerary Item
            var newItem = ItineraryItem()
            
            // Set Properties
            newItem.title = eventTextField.text
            newItem.location = locationTextField.text
            newItem.startDate = formatDate(startDatePicker)
            newItem.startTime = formatTime(startTimePicker)
            newItem.endDate = formatDate(endDatePicker)
            newItem.endTime = formatTime(endTimePicker)
            newItem.description = descriptionTextField.text
            newItem.tripId = tripId!
            
            ItineraryViewController.newEvent = newItem
        }
    }
}
