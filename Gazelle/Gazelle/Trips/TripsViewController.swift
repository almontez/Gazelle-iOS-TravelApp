//
//  TripsViewController.swift
//  Gazelle
//
//  Created by Angela Li Montez on 4/25/23.
//

import UIKit
import ParseSwift

// MARK: - View Life Cycle
class TripsViewController: UIViewController, UITableViewDelegate {
    
    var newTrip = Trip()
    var updatedTrip = Trip()
    var updatedTripId: String?
    private var trips = [Trip]()
    
    @IBOutlet weak var tripsTableView: UITableView!
    
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
}


// MARK: - Segue Code
extension TripsViewController {
    // Prepare data for segue from Trips View Controller to Itinerary View Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "segueToEditTrip":
            if let btn = sender as? UIButton,
               let TripEditController = segue.destination as? TripEditController {
                let trip = trips[btn.tag]
                TripEditController.tripId = trip.objectId as String?
            }
        case "segueToItinerary":
            if let cell = sender as? UITableViewCell,
               let indexPath = tripsTableView.indexPath(for: cell),
               let ItineraryViewController = segue.destination as? ItineraryViewController {
                let trip = trips[indexPath.section]
                ItineraryViewController.tripId = trip.objectId as String?
                ItineraryViewController.navigationItem.title = trip.title as String?
            }
        default:
            print("Default Option: \(segue.identifier!)")
        }
    }
    
    // Unwind segue from Trip Form to Trips View Controller
    @IBAction func unwindToTrips(_ unwindSegue: UIStoryboardSegue) {
        createTrip(newTrip: newTrip)
    }
    
    @IBAction func unwindToUpdatedTrips(_ unwindSegue: UIStoryboardSegue) {
        updateTrip(tripId: updatedTripId!, updatedTrip: updatedTrip)
    }
}


// MARK: - TableView Operations
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
        cell.editTripBtn.tag = indexPath.section
        cell.configure(with: trips[indexPath.section])
        return cell
    }
}


// MARK: - CRUD Operations
extension TripsViewController {
    private func createTrip(newTrip: Trip) {
        newTrip.save { [weak self] result in
            switch result {
            case .success(let savedTrip):
                print("✅ New Trip Saved")
                self?.trips.append(savedTrip)
                DispatchQueue.main.async {
                    self?.tripsTableView.reloadData()
                }
            case .failure(let error):
                self?.showCreationFailureAlert(description: error.localizedDescription)
            }
        }
    }
    
    private func queryTrips() {
        // Create query to fetch Trips for User
        let userId = User.current?.objectId
        let query = Trip.query("userId" == "\(userId!)").order([.descending("startDate")])
    
        // Fetch Trip objects from DB
        query.find { [weak self] result in
            switch result {
            case .success(let trips):
                print("✅ Trip Query Completed")
                self?.trips = trips
                DispatchQueue.main.async {
                    self?.tripsTableView.reloadData()
                }
            case .failure(let error):
                self?.showQueryAlert(description: error.localizedDescription)
            }
        }
    }
    
    private func updateTrip(tripId: String, updatedTrip: Trip) {
        var trip = Trip(objectId: tripId)
     
        trip.title = updatedTrip.title
        trip.description = updatedTrip.description
        trip.userId = updatedTrip.userId
        trip.location = updatedTrip.location
        trip.startDate = updatedTrip.startDate
        trip.endDate = updatedTrip.endDate
        
        trip.save { [weak self] result in
            switch result {
            case .success:
                print("✅ Trip Updated")
                if let row = self?.trips.firstIndex(where: { $0.objectId == trip.objectId }) {
                    self?.trips[row] = trip
                    DispatchQueue.main.async {
                        self?.tripsTableView.reloadData()
                    }
                }
            case .failure(let error):
                self?.showUpdateFailureAlert(description: error.localizedDescription)
            }
        }
    }
    
    private func deleteTrip(trip: Trip) {
        trip.delete { [weak self] result in
            switch result {
            case .success(_):
                print("❎ Trip Deleted!")
                if let row = self?.trips.firstIndex(where: {$0.objectId == trip.objectId}) {
                    self?.trips.remove(at: row)
                    DispatchQueue.main.async {
                        self?.tripsTableView.reloadData()
                    }
                }
            case .failure(let error):
                self?.showDeleteAlert(description: error.localizedDescription)
            }
        }
    }
    
}


// MARK: - Button Actions
extension TripsViewController {
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        deleteTrip(trip: trips[sender.tag])
    }
    
    @IBAction func onLogOutTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Log out of your account?", message: nil, preferredStyle: .alert)
        let logOutAction = UIAlertAction(title: "Log out", style: .destructive) { _ in
            NotificationCenter.default.post(name: Notification.Name("logout"), object: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(logOutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}


// MARK: - Alerts
extension TripsViewController {
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
    
    private func showCreationFailureAlert(description: String?) {
        let alertController = UIAlertController(title: "Unable to Create Trip", message: description ?? "Unknown error", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    private func showUpdateFailureAlert(description: String?) {
        let alertController = UIAlertController(title: "Unable to Update Trip", message: description ?? "Unknown error", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}
