//
//  LocationDetailsController.swift
//  Gazelle
//
//  Created by Angela Li Montez on 5/15/23.
//

import UIKit
import MapKit
import Contacts

class LocationDetailsController: UITableViewController {
    
    @IBOutlet weak var placePhoneLabel: UILabel!
    @IBOutlet weak var placeWebsiteLabel: UILabel!
    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    private var mapItem: MKMapItem?
    private var boundingRegion: MKCoordinateRegion?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDisplayedData()
    }
    
    private func updateDisplayedData() {
        guard isViewLoaded, let mapItem = self.mapItem, let region = boundingRegion
            else { return }
        
        navigationItem.title = mapItem.name
        
        placeAddressLabel.text = mapItem.placemark.formattedAddress
        placePhoneLabel.text = mapItem.phoneNumber
        placeWebsiteLabel.text = mapItem.url?.absoluteString
        
        mapView.showAnnotations([mapItem.placemark], animated: false)
        mapView.region = region
    }
    
    @IBAction func openItemInMaps(_ sender: UIButton) {
        mapItem?.openInMaps(launchOptions: nil)
    }

    func display(_ mapItem: MKMapItem!, in region: MKCoordinateRegion) {
        self.mapItem = mapItem
        self.boundingRegion = region
        updateDisplayedData()
    }

}

extension MKPlacemark {
    var formattedAddress: String? {
        guard let postalAddress = postalAddress else { return nil }
        return CNPostalAddressFormatter.string(from: postalAddress, style: .mailingAddress).replacingOccurrences(of: "\n", with: " ")
    }
}
