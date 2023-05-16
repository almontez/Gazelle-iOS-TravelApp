//
//  TappablePOIController.swift
//  Gazelle
//
//  Created by Angela Li Montez on 5/13/23.
//
//  Citation: https://developer.apple.com/documentation/mapkit/interacting_with_nearby_points_of_interest
//  Citation: https://medium.com/@pravinbendre772/search-for-places-and-display-results-using-mapkit-a987bd6504df
//  Citation: https://thorntech.com/how-to-search-for-location-using-apples-mapkit/

import UIKit
import MapKit

class TappablePOIController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    // Used for saving itinerary items from map
    // Related to AddItineraryFromMap controller
    var newEvent = ItineraryItem()
    
    // Used for identifing and registering map annotations
    private enum AnnotationReuseId: String {
        case featureAnnotation
    }
    
    // Used for location related operations
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // START: Use for map annotations
        mapView.delegate = self
        
        // Register annotation view - Necessary if being used as a reusable annotation
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: AnnotationReuseId.featureAnnotation.rawValue)
        
        // Configure map to allow for interaction with all points of interest
        mapView.selectableMapFeatures = [.pointsOfInterest]
        let mapConfiguration = MKStandardMapConfiguration()
        mapConfiguration.pointOfInterestFilter = MKPointOfInterestFilter.includingAll
        mapView.preferredConfiguration = mapConfiguration
        // END
        
        // START: Use for identifying user location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
        // END
    }
}

// MARK: - Segue Code
extension TappablePOIController {
    // Move from Explore to Location Details
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let LocationDetailController = segue.destination as? LocationDetailsController else { return }
        
        if segue.identifier == "segueToLocationDetails" {
            guard let selectedAnnotation = mapView.selectedAnnotations.first,
                  let featureAnnotation = selectedAnnotation as? MKMapFeatureAnnotation
            else { return }
            
            // MKMapFeatureAnnotation` only has limited information about the point of interest.
            // To get additional information, use `MKMapItemRequest` to get an `MKMapItem`.
            let request = MKMapItemRequest(mapFeatureAnnotation: featureAnnotation)
            request.getMapItem { mapItem, error in
                guard error == nil
                else {
                    self.displayError(error)
                    return
                }
                
                if let mapItem {
                    var region = self.mapView.region
                    region.center = mapItem.placemark.coordinate
                    LocationDetailController.display(mapItem, in: region)
                }
            }
        }
    }
    
    // Unwind from Map Item Form to Explore
    @IBAction func unwindToExploreFromMapForm(_ unwindSegue: UIStoryboardSegue) {
        createItineraryItem(newEvent: newEvent)
    }
}

// MARK: - MapView operations
extension TappablePOIController: MKMapViewDelegate {
    // Called when POI is tapped
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? MKMapFeatureAnnotation {
            // Provide custom annotation for tapped POI
            return setupPOIAnnotation(annotation)
        } else {
            return nil
        }
    }
    
    // Called when detail callout is tapped
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation, annotation.isKind(of: MKMapFeatureAnnotation.self) {
            performSegue(withIdentifier: "segueToLocationDetails", sender: self)
        }
    }
    
    // Styles POI Annotation
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

// MARK: - Location Related Operations
extension TappablePOIController: CLLocationManagerDelegate {
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

// MARK: - CRUD Operations
extension TappablePOIController {
    private func createItineraryItem(newEvent: ItineraryItem) {
        newEvent.save { [weak self] result in
            switch result {
            case .success(let savedEvent):
                print("✅ New Event Saved")
                DispatchQueue.main.async {
                    let ItineraryViewController = self?.storyboard?.instantiateViewController(withIdentifier: "Itinerary") as? ItineraryViewController
                    ItineraryViewController?.itineraryItems.append(savedEvent)
                    self?.showSucessAlert()
                }
            case .failure(let error):
                self?.showFailureAlert(description: error.localizedDescription)
            }
        }
    }
}
