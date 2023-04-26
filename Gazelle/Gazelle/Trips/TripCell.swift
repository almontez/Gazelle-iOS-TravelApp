//
//  TripsCell.swift
//  Gazelle
//
//  Created by Angela Li Montez on 4/25/23.
//

import UIKit

class TripCell: UITableViewCell {

    @IBOutlet weak var tripTitle: UILabel!
    @IBOutlet weak var tripDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Configure cell's UI for Trips objects
    func configure(with trip: Trips) {
        tripTitle.text = trip.title
        tripDescription.text = trip.description
    }

}
