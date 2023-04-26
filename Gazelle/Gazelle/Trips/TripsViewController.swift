//
//  TripsViewController.swift
//  Gazelle
//
//  Created by Angela Li Montez on 4/25/23.
//

import UIKit
import ParseSwift

class TripsViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tripsTableView: UITableView!
    
    private var trips = [Trips]() {
        didSet {
            tripsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tripsTableView.delegate = self
        tripsTableView.dataSource = self
        // tripsTableView.allowsSelection = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        queryTrips()
    }
    
    private func queryTrips() {
        // Create query to fetch Trips
        let query = Trips.query()
            .include("users")
            // TODO: Order based on date. May need to add dates to trip instead of destinations...figure it out
        
        // Fetch Trip objects from DB
        query.find { [weak self] result in
            switch result {
            case .success(let trips):
                print(trips)
                self?.trips = trips
                
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
}

extension TripsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TripCell", for: indexPath) as?
                TripCell else {
                return UITableViewCell()
        }
        cell.configure(with: trips[indexPath.row])
        return cell
    }
}
