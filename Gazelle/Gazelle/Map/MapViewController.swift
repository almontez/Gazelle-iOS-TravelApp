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

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
    }

}
