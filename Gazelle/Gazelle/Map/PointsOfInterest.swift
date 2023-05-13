//
//  PointsOfInterest.swift
//  Gazelle
//
//  Created by Angela Li Montez on 5/13/23.
//
//  Citation: https://www.kodeco.com/7738344-mapkit-tutorial-getting-started#toc-anchor-006

import Foundation
import MapKit

class PointOfInterest: NSObject, MKAnnotation {
    let title: String?
    let discipline: String?
    let coordinate: CLLocationCoordinate2D
    
    init(
        title: String?,
        discipline: String?,
        coordinate: CLLocationCoordinate2D
    ) {
        self.title = title
        self.discipline = discipline
        self.coordinate = coordinate
        super.init()
    }
}
