//
//  LocationDetailsController.swift
//  Gazelle
//
//  Created by Angela Li Montez on 5/15/23.
//

import UIKit
import MapKit

class LocationDetailsController: UITableViewController {

    @IBOutlet weak var detailsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func display(_ mapItem: MKMapItem!, in region: MKCoordinateRegion) {
        navigationItem.title = mapItem.name
    }

}
