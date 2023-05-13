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
    
    private enum AnnotationReuseId: String {
        case featureAnnotation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        // Register annotation view - Necessary if being used as a reusable annotation
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: AnnotationReuseId.featureAnnotation.rawValue)
        
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
    
    private func setupPOIAnnotation(_ annotation: MKMapFeatureAnnotation) -> MKAnnotationView? {
        let markerAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: AnnotationReuseId.featureAnnotation.rawValue, for: annotation)
        
        if let markerAnnotationView = markerAnnotationView as? MKMarkerAnnotationView {
            // Display callout
            markerAnnotationView.animatesWhenAdded = true
            markerAnnotationView.canShowCallout = true
            
            // Style and add button to callout
            let infoBtn = UIButton(type: .detailDisclosure)
            markerAnnotationView.rightCalloutAccessoryView = infoBtn
            
            // Style annotation
            if let tappedFeatureColor = annotation.iconStyle?.backgroundColor,
               let image = annotation.iconStyle?.image {
                
                markerAnnotationView.markerTintColor = tappedFeatureColor
                infoBtn.tintColor = tappedFeatureColor
                
                let imageView = UIImageView(image: image.withTintColor(tappedFeatureColor, renderingMode: .alwaysOriginal))
                imageView.bounds = CGRect(origin: .zero, size: CGSize(width: 50, height: 50))
                markerAnnotationView.leftCalloutAccessoryView = imageView
            }
        }
        
        return markerAnnotationView
    }
    
}

extension TappablePOIController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? MKMapFeatureAnnotation {
            // Provide custom annotation for tapped POI
            return setupPOIAnnotation(annotation)
        } else {
            return nil
        }
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
