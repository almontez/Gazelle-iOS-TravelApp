//
//  ItineraryViewController.swift
//  Gazelle
//
//  Created by Angela Li Montez on 4/24/23.
//

import UIKit
import ParseSwift

class ItineraryViewController: UIViewController, UITableViewDelegate {
    
    var tripId: String?
    
    @IBOutlet weak var itineraryTableView: UITableView!
    
    private var itineraryItems = [ItineraryItem]() {
        didSet {
            itineraryTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itineraryTableView.backgroundView = UIImageView(image: UIImage(named: "bg_image"))
        itineraryTableView.delegate = self
        itineraryTableView.dataSource = self
        itineraryTableView.allowsSelection = false
        queryItineraryItems()
    }
    
    private func queryItineraryItems() {
        // Create query to fetch Itinerary Items for Trip
        let query = ItineraryItem.query("tripId" == "\(tripId!)")
        
        // Fetch Itinerary Item Objects from DB
        query.find { [weak self] result in
            switch result {
            case .success(let itineraryItems):
                self?.itineraryItems = itineraryItems
            case .failure(let error):
                self?.showAlert(description: error.localizedDescription)
            }
            
        }
    }
    
    private func showAlert(description: String?) {
        let alertController = UIAlertController(title: "Oops...", message: "\(description ?? "Please try again...")", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let ItineraryFormController = segue.destination as? ItineraryFormController
        ItineraryFormController?.tripId = tripId
    }
}


extension ItineraryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return itineraryItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItineraryItemCell", for: indexPath) as?
                ItineraryItemCell else {
                return UITableViewCell()
        }
        cell.configure(with: itineraryItems[indexPath.section])
        return cell
    }
}
