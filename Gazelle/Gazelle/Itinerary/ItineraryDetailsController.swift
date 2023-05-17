//
//  ItineraryDetailsController.swift
//  Gazelle
//
//  Created by Angela Li Montez on 5/16/23.
//

import UIKit
import MapKit

class ItineraryDetailsController: UITableViewController {

    @IBOutlet weak var eventTV: UITextView!
    @IBOutlet weak var descriptionTV: UITextView!
    @IBOutlet weak var datesTV: UITextView!
    @IBOutlet weak var timesTV: UITextView!
    @IBOutlet weak var addressTV: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    
    var itineraryEvent: ItineraryItem?
    private var mapItem: MKMapItem?
    private var boundingRegion: MKCoordinateRegion?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsSelection = false
        updateDisplayedData()
    }
    
    @IBAction func openItemInMaps(_ sender: UIButton) {
        mapItem?.openInMaps(launchOptions: nil)
    }
}

// MARK: - UI Related Operations
extension ItineraryDetailsController {
    private func updateDisplayedData() {
        navigationItem.title = itineraryEvent?.title
        eventTV.text = itineraryEvent?.title
        datesTV.text = formatDates(from: (itineraryEvent?.startDate)!, to: (itineraryEvent?.endDate)!)
        timesTV.text = formatTimes(from: (itineraryEvent?.startTime)!, to: (itineraryEvent?.endTime)!)
        addressTV.text = itineraryEvent?.location
        descriptionTV.text = setDescriptionTV(description: (itineraryEvent?.description)!)
        
        // Citation: https://stackoverflow.com/questions/43918842/open-map-in-a-given-address-using-mapkit-and-swift
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString((itineraryEvent?.location)!) { (placemarks, error) in
          if error != nil {
              print("❌ Unable to retrieve coordinates related to event address")
          } else if let placemarks = placemarks {
            if let coordinate = placemarks.first?.location?.coordinate {
                let placemark = MKPlacemark(coordinate: coordinate)
                self.mapItem = MKMapItem(placemark: placemark)
                self.mapItem?.name = self.itineraryEvent?.title
                self.dropPinZoomIn(location: self.mapItem!)
            }
          }
        }
    }
    
    func formatDates(from startDate: String, to endDate: String) -> String {
        return "\(startDate) - \(endDate)"
    }
    
    func formatTimes(from startTime: String, to endTime: String) -> String {
        return "\(startTime) - \(endTime)"
    }
    
    func setDescriptionTV(description: String) -> String {
        if description == "" {
            return "Description Not Available"
        }
        
        if let eventURL = URL(string: description) {
            return eventURL.absoluteString
        }
        
        return description
    }
    
    // Citation: https://stackoverflow.com/questions/25829173/change-font-of-mapkit-annotation-callout-title-and-subtitle
    func dropPinZoomIn(location: MKMapItem){
        // New annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.placemark.coordinate
        annotation.title = location.placemark.name
        mapView.addAnnotation(annotation)
        
        // Zoom level
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: location.placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}
