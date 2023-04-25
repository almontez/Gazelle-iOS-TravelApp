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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
