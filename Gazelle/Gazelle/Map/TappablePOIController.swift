//
//  TappablePOIController.swift
//  Gazelle
//
//  Created by Angela Li Montez on 5/13/23.
//
//  Citation: https://www.kodeco.com/7738344-mapkit-tutorial-getting-started#toc-anchor-006
//  Citation: https://developer.apple.com/documentation/mapkit/interacting_with_nearby_points_of_interest

import UIKit
import MapKit

class TappablePOIController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        // Configure map to allow for interaction with all points of interest
        mapView.selectableMapFeatures = [.pointsOfInterest]
        let mapConfiguration = MKStandardMapConfiguration()
        mapConfiguration.pointOfInterestFilter = MKPointOfInterestFilter.includingAll
        mapView.preferredConfiguration = mapConfiguration
        
        // TODO: DELETE LATER - Narrowing Area To Help Development
        // Set initial location in Honolulu
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        mapView.centerToLocation(initialLocation)
    }

}

extension TappablePOIController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print("I AM BEING CALLED")
        return nil
    }
    
}

// TODO: MAY DELETE LATER BUT COULD USE TO CENTER ON THE USERS LOCATION
private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
