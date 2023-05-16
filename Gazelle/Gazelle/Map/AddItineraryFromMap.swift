//
//  AddItineraryFromMap.swift
//  Gazelle
//
//  Created by Angela Li Montez on 5/15/23.
//

import UIKit
import MapKit
import ParseSwift

class AddItineraryFromMap: UIViewController {
    
    var trips = [Trip]()
    var tripDict = [String: String]()
    var tripId: String?
    var mapItem: MKMapItem?
    
    @IBOutlet weak var eventTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var tripNamePicker: UIButton!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeHideKeyboard()
        queryTrips()
    }
    
    private func fillInputFields() {
        eventTextField.text = mapItem!.name
        locationTextField.text = mapItem!.placemark.formattedAddress
        descriptionTextField.text = mapItem!.url?.absoluteString
        setPopupOptions()
    }
    
    private func setPopupOptions() {
        let optionClosure = { (action: UIAction) in
            self.tripId = self.tripDict[action.title]
        }
        
        var optionsArray = [UIAction]()
        
        for trip in trips {
            let title = trip.title!
            let action = UIAction(title: title, state: .off, handler: optionClosure)
            optionsArray.append(action)
        }
        
        optionsArray[0].state = .on
        let optionsMenu = UIMenu(title: "", options: .displayInline, children: optionsArray)
        
        tripNamePicker.menu = optionsMenu
        tripNamePicker.changesSelectionAsPrimaryAction = true
        tripNamePicker.showsMenuAsPrimaryAction = true
    }
    
    private func queryTrips() {
        // Create query to fetch Trips for User
        let userId = User.current?.objectId
        let query = Trip.query("userId" == "\(userId!)")
        
        // Fetch Trip objects from D
        query.find { [weak self] result in
            switch result {
            case .success(let trips):
                print("✅ Trip Query Completed")
                self?.trips = trips
                self?.createTripDictionary()
                self?.fillInputFields()
            case .failure(_):
                print("❌ Unable to query trips from Add Itinerary Item from Map")
            }
        }
        
    }
    
    private func createTripDictionary() {
        for trip in trips {
            tripDict[trip.title!] = trip.objectId!
            
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        print("Save button tapped")
        if (eventTextField.text == "" || locationTextField.text == "") {
            itineraryItemFieldRequredAlert()
        } else {
            print("In else Branch")
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Itinerary") as! ItineraryViewController
            nextViewController.tripId = tripId
            self.present(nextViewController, animated:true, completion:nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("I am being called")
    }
}
