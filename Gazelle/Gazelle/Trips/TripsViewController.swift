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
    
    private var trips = [Trip]() {
        didSet {
            tripsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tripsTableView.backgroundView = UIImageView(image: UIImage(named: "bg_image"))
        tripsTableView.delegate = self
        tripsTableView.dataSource = self
        tripsTableView.allowsSelection = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        queryTrips()
    }
    
    private func queryTrips() {
        // Create query to fetch Trips for User
        let userId = User.current?.objectId
        let query = Trip.query("userId" == "\(userId!)")
    
        // Fetch Trip objects from DB
        query.find { [weak self] result in
            switch result {
            case .success(let trips):
                self?.trips = trips
            case .failure(let error):
                self?.showQueryAlert(description: error.localizedDescription)
            }
        }
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        deleteTrip(trip: trips[sender.tag])
    }
    
    private func deleteTrip(trip: Trip) {
        trip.delete { [weak self] result in
            switch result {
            case .success(_):
                print("❎ Trip Deleted!")
            case .failure(let error):
                self?.showDeleteAlert(description: error.localizedDescription)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell,
           let indexPath = tripsTableView.indexPath(for: cell),
           let ItineraryViewController = segue.destination as? ItineraryViewController {
            let trip = trips[indexPath.section]
            ItineraryViewController.tripId = trip.objectId as String?
        }
    }
    
    @IBAction func unwindToTrips(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        queryTrips()
    }
    
    private func showQueryAlert(description: String?) {
        let alertController = UIAlertController(title: "Oops...", message: "\(description ?? "Please try again...")", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    private func showDeleteAlert(description: String?) {
        let alertController = UIAlertController(title: "Unable to Delete Trip", message: description ?? "Unknown error", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}

extension TripsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TripCell", for: indexPath) as?
                TripCell else {
                return UITableViewCell()
        }
        
        cell.deleteTripBtn.tag = indexPath.section
        cell.configure(with: trips[indexPath.section])
        return cell
    }
}

