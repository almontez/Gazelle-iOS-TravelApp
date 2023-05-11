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
    @IBAction func updateBtnTapped(_ sender: UIButton) {
        if (eventTextField.text == "" || locationTextField.text == "") {
            itineraryFieldRequredAlert()
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
            updatedItem.startDate = formatNewDate(startDatePicker)
            updatedItem.startTime = formatNewTime(startTimePicker)
            updatedItem.endDate = formatNewDate(endDatePicker)
            updatedItem.endTime = formatNewTime(endTimePicker)
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
    
    private func formatOldDate(_ date: String?) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let formattedDate = dateFormatter.date(from: date!)
        return formattedDate!
    }
    
    private func formatNewDate(_ date: UIDatePicker) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let dateString = dateFormatter.string(from: date.date)
        return dateString
    }
    
    // Citation: https://stackoverflow.com/questions/28985483/how-to-change-uidatepicker-to-a-specific-time-in-code
    private func formatOldTime(time: String, picker: UIDatePicker) {
        // Time Separators
        let separatorIdx = time.firstIndex(of: ":")!
        let meridiemSeparator = time.firstIndex(of: " ")!
        // Get hr from string
        let hrIdx = time.index(before: separatorIdx)
        var hr = Int(time[...hrIdx])
        // Get mins from string
        let minStart = time.index(after: separatorIdx)
        let minEnd = time.index(before: meridiemSeparator)
        let min = Int(time[minStart...minEnd])
        // Get AM/PM from string
        let meridiemStart = time.index(after: meridiemSeparator)
        let meridiem = time[meridiemStart...]
        
        // Convert hr to 24 hr format
        if meridiem == "PM" && hr! != 12 {
            hr! += 12
        } else if meridiem == "AM" && hr! == 12 {
            hr! -= 12
        }
        
        // Update time on UIDatePicker
        let calendar = Calendar.current
        var components = DateComponents()
        components.hour = hr!
        components.minute = min!
        
        if picker.tag == 0 {
            startTimePicker.setDate(calendar.date(from: components)!, animated: false)
        } else {
            endTimePicker.setDate(calendar.date(from: components)!, animated: false)
        }
    }
    
    private func formatNewTime(_ time: UIDatePicker) -> String {
        var meridiemFlag = "AM"
        var stringMins = ""
        var stringHrs = ""
        let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: time.date)
        var hour = timeComponents.hour!
        let minutes = timeComponents.minute!
        
        if (hour > 11) {
            meridiemFlag = "PM"
            if (hour != 12) {
                hour -= 12
            }
            stringHrs = String(hour)
        } else {
            stringHrs = String(hour)
        }
        
        if (hour == 0 && meridiemFlag == "AM") {
            hour += 12
            stringHrs = String(hour)
        }
        
        if (minutes < 10) {
            stringMins = "0" + String(minutes)
        } else {
            stringMins = String(minutes)
        }
        
        return "\(stringHrs):\(stringMins) \(meridiemFlag)"
    }
}


// MARK: - Alerts
extension ItineraryEditController {
    private func showQueryAlert(description: String?) {
        let alertController = UIAlertController(title: "Oops...", message: "\(description ?? "Please try again...")", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    private func itineraryFieldRequredAlert() {
        let alertController = UIAlertController(title: "Required", message: "The the name, location, and dates of your itinerary event are required.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}

// citation: https://www.cometchat.com/tutorials/how-to-dismiss-ios-keyboard-swift
extension ItineraryEditController {
    func initializeHideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
}
