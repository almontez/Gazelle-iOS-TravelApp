//
//  MapViewController.swift
//  Gazelle
//
//  Created by Angela Li Montez on 4/17/23.
//
//  Citations:
//  https://iosapptemplates.com/blog/swift-programming/mapkit-tutorial
//  https://medium.com/swlh/how-to-work-with-mapkit-5c96c45f32f0
//  https://medium.com/@kiransjadhav111/corelocation-map-kit-get-the-users-current-location-set-a-pin-in-swift-edb12f9166b2
//  https://www.johncodeos.com/how-to-display-location-and-routes-with-corelocation-mapkit-using-swift/
//  https://medium.com/@pravinbendre772/search-for-places-and-display-results-using-mapkit-a987bd6504df

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("Not Determined")
        case .restricted, .denied:
            print("Restricted or Denied")
        case .authorizedAlways, .authorizedWhenInUse:
            print("Authorized")
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestLocation()
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
