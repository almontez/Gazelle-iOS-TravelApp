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
    @IBOutlet weak var tripDates: UILabel!
    @IBOutlet weak var tripLocation: UILabel!
    @IBOutlet weak var deleteTripBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 3.0
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    // Configure cell's UI for Trips objects
    func configure(with trip: Trip) {
        tripTitle.text = trip.title
        tripDescription.text = trip.description
        tripDates.text = formatDates(from: trip.startDate!, to: trip.endDate!)
        tripLocation.text = trip.location
    }
    
    func formatDates(from startDate: String, to endDate: String) -> String {
        return "\(startDate) - \(endDate)"
    }

}
