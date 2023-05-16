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
    @IBOutlet weak var placeCategoriesLabel: UILabel!
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
        placeCategoriesLabel.text = formatCategories(retrieveCategory(mapItem))
        
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToItineraryFromMap" {
            if let AddItineraryItemFromMap = segue.destination as? AddItineraryFromMap {
                AddItineraryItemFromMap.mapItem = mapItem
            }
        }
    }

}

extension LocationDetailsController {
    // Citation: https://stackoverflow.com/questions/27478034/how-to-access-the-category-or-type-of-an-mkmapitem
    func retrieveCategory(_ item: MKMapItem) -> Set<String> {
        let geo_place = item.value(forKey: "place") as! NSObject
        // print(geo_place)
        let geo_business = geo_place.value(forKey: "business") as! NSObject
        let categories = geo_business.value(forKey: "localizedCategories") as! [AnyObject]
        
        var categoriesSet = Set<String>()
        
        if let categoriesResult = (categories.first as? [AnyObject]) {
            for geo_cat in categoriesResult {
                let geo_loc_name = geo_cat.value(forKeyPath: "localizedNames") as! NSObject
                let category = (geo_loc_name.value(forKeyPath: "name") as! [String]).first!
                
                categoriesSet.insert(category)
            }
        }
        return categoriesSet
    }
    
    func formatCategories(_ categorySet: Set<String>) -> String {
        var cat_str = ""
        for item in categorySet {
            cat_str += "\(item), "
        }
        let formatted_str = cat_str.dropLast(2)
        return String(formatted_str)
    }
}

extension MKPlacemark {
    var formattedAddress: String? {
        guard let postalAddress = postalAddress else { return nil }
        return CNPostalAddressFormatter.string(from: postalAddress, style: .mailingAddress).replacingOccurrences(of: "\n", with: " ")
    }
}
