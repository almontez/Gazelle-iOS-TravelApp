//
//  LocationDetailsController.swift
//  Gazelle
//
//  Created by Angela Li Montez on 5/15/23.
//

import UIKit
import MapKit

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
    
    @IBAction func openItemInMaps(_ sender: UIButton) {
        mapItem?.openInMaps(launchOptions: nil)
    }

    func display(_ mapItem: MKMapItem!, in region: MKCoordinateRegion) {
        self.mapItem = mapItem
        self.boundingRegion = region
        updateDisplayedData()
    }
}

// MARK: - Segue Code
extension LocationDetailsController {
    // Prepare data for Add Map Item Form
    // Pass mapItem to Map Item Form to prepopulate input fields
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToItineraryFromMap" {
            if let AddItineraryItemFromMap = segue.destination as? AddItineraryFromMap {
                AddItineraryItemFromMap.mapItem = mapItem
            }
        }
    }
    
    // Unwind from add Map Item Form to Location Details Controller
    @IBAction func unwindToCancelMapItemForm(_ unwindSegue: UIStoryboardSegue) {
        _ = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
}

// MARK: - UI Related Operations
extension LocationDetailsController {
    private func updateDisplayedData() {
        guard isViewLoaded, let mapItem = self.mapItem, let region = boundingRegion
            else { return }
        
        navigationItem.title = mapItem.name
        
        placeAddressLabel.text = mapItem.placemark.formattedAddress ?? "Address Not Available"
        placePhoneLabel.text = mapItem.phoneNumber ?? "Phone Number Not Available"
        placeWebsiteLabel.text = mapItem.url?.absoluteString ?? "Website Not Available"
        placeCategoriesLabel.text = formatCategories(retrieveCategory(mapItem)) 
        
        
        mapView.showAnnotations([mapItem.placemark], animated: false)
        mapView.region = region
    }
    
    // Get category data from a MKMapItem
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
}
