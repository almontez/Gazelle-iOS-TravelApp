//
//  ItineraryViewController.swift
//  Gazelle
//
//  Created by Angela Li Montez on 4/24/23.
//

import UIKit
import ParseSwift


// MARK: - View Life Cycle
class ItineraryViewController: UIViewController, UITableViewDelegate {
    
    var tripId: String?
    var newEvent = ItineraryItem()
    private var itineraryItems = [ItineraryItem]()
    
    @IBOutlet weak var itineraryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itineraryTableView.backgroundView = UIImageView(image: UIImage(named: "bg_image"))
        itineraryTableView.delegate = self
        itineraryTableView.dataSource = self
        itineraryTableView.allowsSelection = false
        itineraryTableView.rowHeight = 250
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        queryItineraryItems()
    }
}


// MARK: - Segue Code
extension ItineraryViewController {
    // Send tripId to Itinerary Form Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "segueToEditEvent":
            if let btn = sender as? UIButton,
               let ItineraryEditController = segue.destination as? ItineraryEditController {
                let event = itineraryItems[btn.tag]
                ItineraryEditController.itineraryItemId = event.objectId as String?
            }
        case "segueToItineraryForm":
            let ItineraryFormController = segue.destination as? ItineraryFormController
            ItineraryFormController?.tripId = tripId
        default:
            print("❌ Segue from Itinerary View Controller Unknown")
        }
    }
    
    // Unwind segue from Itinerary Event Form to Itinerary View Controller
    @IBAction func unwindToItinerary(_ unwindSegue: UIStoryboardSegue) {
        createItineraryItem(newEvent: newEvent)
    }
    
}


// MARK: - TableView Operations
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
        
        cell.eventDeleteBtn.tag = indexPath.section
        cell.eventUpdateBtn.tag = indexPath.section
        cell.configure(with: itineraryItems[indexPath.section])
        return cell
    }
}


// MARK: - CRUD Operations
extension ItineraryViewController {
    private func createItineraryItem(newEvent: ItineraryItem) {
        newEvent.save { [weak self] result in
            switch result {
            case .success(let savedEvent):
                print("✅ New Event Saved")
                self?.itineraryItems.append(savedEvent)
                DispatchQueue.main.async {
                    self?.itineraryTableView.reloadData()
                }
            case .failure(let error):
                self?.showCreationFailureAlert(description: error.localizedDescription)
            }
        }
    }
    
    private func queryItineraryItems() {
        // Create query to fetch Itinerary Items for Trip
        let query = ItineraryItem.query("tripId" == "\(tripId!)")
        
        // Fetch Itinerary Item Objects from DB
        query.find { [weak self] result in
            switch result {
            case .success(let itineraryItems):
                print("✅ Itinerary Query Completed")
                self?.itineraryItems = itineraryItems
                DispatchQueue.main.async {
                    self?.itineraryTableView.reloadData()
                }
            case .failure(let error):
                self?.showQueryAlert(description: error.localizedDescription)
            }
            
        }
    }
    
    private func updateItineraryItem() {}
    
    private func deleteItinteraryItem(event: ItineraryItem) {
        event.delete { [weak self] result in
            switch result {
            case .success(_):
                print("❎ Event Deleted!")
                if let row = self?.itineraryItems.firstIndex(where: {$0.objectId == event.objectId}) {
                    self?.itineraryItems.remove(at: row)
                    DispatchQueue.main.async {
                        self?.itineraryTableView.reloadData()
                    }
                }
            case .failure(let error):
                self?.showDeleteAlert(description: error.localizedDescription)
            }
        }
    }
    
}


// MARK: - Button Actions
extension ItineraryViewController {
    @IBAction func deleteBtnTapped(_ sender: UIButton) {
        deleteItinteraryItem(event: itineraryItems[sender.tag])
    }
}


// MARK: - Alerts
extension ItineraryViewController {
    private func showQueryAlert(description: String?) {
        let alertController = UIAlertController(title: "Oops...", message: "\(description ?? "Please try again...")", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    private func showDeleteAlert(description: String?) {
        let alertController = UIAlertController(title: "Unable to Delete Itinerary Event", message: description ?? "Unknown error", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    private func showCreationFailureAlert(description: String?) {
        let alertController = UIAlertController(title: "Unable to Create Itinerary Event", message: description ?? "Unknown error", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}
