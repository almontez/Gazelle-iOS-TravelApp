//
//  ItineraryItemCell.swift
//  Gazelle
//
//  Created by Angela Li Montez on 4/25/23.
//

import UIKit

class ItineraryItemCell: UITableViewCell {

    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemDates: UILabel!
    @IBOutlet weak var itemTimes: UILabel!
    @IBOutlet weak var itemLocation: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var eventDeleteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 3.0
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    func configure(with item: ItineraryItem) {
        itemTitle.text = item.title
        itemDates.text = formatDates(from: item.startDate!, to: item.endDate!)
        itemTimes.text = formatTimes(from: item.startTime!, to: item.endTime!)
        itemLocation.text = item.location
        itemDescription.text = item.description
    }
    
    func formatDates(from startDate: String, to endDate: String) -> String {
        return "\(startDate) - \(endDate)"
    }
    
    func formatTimes(from startTime: String, to endTime: String) -> String {
        return "\(startTime) - \(endTime)"
    }

}
