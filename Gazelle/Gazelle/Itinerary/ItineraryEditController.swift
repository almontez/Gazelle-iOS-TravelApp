//
//  ItineraryEditController.swift
//  Gazelle
//
//  Created by Angela Li Montez on 5/11/23.
//

import UIKit
import ParseSwift

class ItineraryEditController: UIViewController {
    
    var tripId: String?
    var itineraryItemId: String?
    private var foundItem = ItineraryItem()
    
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
        findSpecificEvent(id: itineraryItemId!)
    }
    
    @IBAction func updateBtnTapped(_ sender: UIButton) {
        if (eventTextField.text == "" || locationTextField.text == "") {
            itineraryItemFieldRequredAlert()
        } else {
            performSegue(withIdentifier: "unwindToUpdatedItinerary", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ItineraryViewController = segue.destination as? ItineraryViewController {
            // Create Itinerary Item
            var updatedItem = ItineraryItem()
            
            // Set Properties
            updatedItem.title = eventTextField.text
            updatedItem.location = locationTextField.text
            updatedItem.startDate = formatDate(startDatePicker)
            updatedItem.startTime = formatTime(startTimePicker)
            updatedItem.endDate = formatDate(endDatePicker)
            updatedItem.endTime = formatTime(endTimePicker)
            updatedItem.description = descriptionTextField.text
            updatedItem.tripId = tripId!
            
            ItineraryViewController.updatedEvent = updatedItem
            ItineraryViewController.updatedEventId = itineraryItemId
        }
    }
}


// MARK: - UI Related Functions
extension ItineraryEditController {
    private func fillInputFields() {
        eventTextField.text = foundItem.title
        locationTextField.text = foundItem.location
        descriptionTextField.text = foundItem.description
        startDatePicker.date = formatOldDate(foundItem.startDate)
        formatOldTime(time: foundItem.startTime!, picker: startTimePicker)
        endDatePicker.date = formatOldDate(foundItem.endDate)
        formatOldTime(time: foundItem.endTime!, picker: endTimePicker)
    }
}

// MARK: - CRUD Related Operations
extension ItineraryEditController {
    private func findSpecificEvent(id eventId: String) {
        let query = ItineraryItem.query("objectId" == "\(eventId)")
        
        query.find { [weak self] result in
            switch result {
            case .success(let foundEvent):
                print("✅ Specific Event Found")
                self?.foundItem = foundEvent[0]
                self?.fillInputFields()
            case .failure(let error):
                self?.showQueryAlert(description: error.localizedDescription)
            }
        }
    }
}
