//
//  MapViewController.swift
//  Gazelle
//
//  Created by Angela Li Montez on 4/17/23.
//
//  Citation: https://medium.com/@pravinbendre772/search-for-places-and-display-results-using-mapkit-a987bd6504df
//  Citation: https://thorntech.com/how-to-search-for-location-using-apples-mapkit/

import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark, _ categoryList: Set<String>)
}

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    // User location identification variable
    let locationManager = CLLocationManager()
    
    // Search bar variables
    var resultSearchController: UISearchController? = nil
    var selectedPin: MKPlacemark? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        
        // Ask for user permissions
        locationManager.requestWhenInUseAuthorization()
        
        // Identify user location
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()

        // Use for search bar
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        // Programmatically insert search bar into MapViewController
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.searchController = resultSearchController
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
    }

}

// Location manager delegate: Process authorization and location requests 
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("Not Determined")
        case .restricted, .denied:
            print("Restricted or Denied")
        case .authorizedAlways, .authorizedWhenInUse:
            print("Authorized")
        default:
            print("Status Unknown")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Location:: \(location)")
            let zoom = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: location.coordinate, span: zoom)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error:: \(error)")
    }
}

// https://stackoverflow.com/questions/25829173/change-font-of-mapkit-annotation-callout-title-and-subtitle
extension MapViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark, _ categoryList: Set<String>){
        // Cache the pin
        selectedPin = placemark
        
        // Clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        
        // New annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        let cat_str = formatCategories(categoryList)
        annotation.subtitle = cat_str
        mapView.addAnnotation(annotation)
        
        // Zoom level
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}

func formatCategories(_ categorySet: Set<String>) -> String {
    var cat_str = "Categories:"
    for item in categorySet {
        cat_str += " \(item),"
    }
    cat_str.removeLast()
    return cat_str
}
