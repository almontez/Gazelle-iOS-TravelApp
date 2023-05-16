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
    var updatedEvent = ItineraryItem()
    var updatedEventId: String?
    var itineraryItems = [ItineraryItem]()
    
    @IBOutlet weak var itineraryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itineraryTableView.backgroundView = UIImageView(image: UIImage(named: "bg_image"))
        itineraryTableView.delegate = self
        itineraryTableView.dataSource = self
        itineraryTableView.allowsSelection = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        queryItineraryItems()
    }
    
    @IBAction func deleteBtnTapped(_ sender: UIButton) {
        deleteItinteraryItem(event: itineraryItems[sender.tag])
    }
}


// MARK: - Segue Code
extension ItineraryViewController {
    // Send tripId to Itinerary Form Controller or Edit Trip Form
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "segueToEditEvent":
            if let btn = sender as? UIButton,
               let ItineraryEditController = segue.destination as? ItineraryEditController {
                let event = itineraryItems[btn.tag]
                ItineraryEditController.itineraryItemId = event.objectId as String?
                ItineraryEditController.tripId = tripId
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
    
    @IBAction func unwindToUpdatedItinerary(_ unwindSegue: UIStoryboardSegue) {
        updateItineraryItem(itemId: updatedEventId!, updatedItem: updatedEvent)
    }
    
    @IBAction func unwindToCancelItemForm(_ unwindSegue: UIStoryboardSegue) {
        _ = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
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
                    self?.showSucessAlert()
                }
            case .failure(let error):
                self?.showFailureAlert(description: error.localizedDescription)
            }
        }
    }
    
    private func queryItineraryItems() {
        // Create query to fetch Itinerary Items for Trip
        let query = ItineraryItem.query("tripId" == "\(tripId!)").order([.ascending("startDate"), .descending("startTime")])
        
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
                self?.showFailureAlert(description: error.localizedDescription)
            }
            
        }
    }
    
    private func updateItineraryItem(itemId: String, updatedItem: ItineraryItem) {
        var item = ItineraryItem(objectId: itemId)
        
        item.title = updatedItem.title
        item.location = updatedItem.location
        item.startDate = updatedItem.startDate
        item.startTime = updatedItem.startTime
        item.endDate = updatedItem.endDate
        item.endTime = updatedItem.endTime
        item.description = updatedItem.description
        item.tripId = updatedItem.tripId
        
        item.save { [weak self] result in
            switch result {
            case .success:
                print("✅ Itinerary Updated")
                if let row = self?.itineraryItems.firstIndex(where: { $0.objectId == item.objectId }) {
                    self?.itineraryItems[row] = item
                    DispatchQueue.main.async {
                        self?.itineraryTableView.reloadData()
                        self?.showSucessAlert()
                    }
                }
            case .failure(let error):
                self?.showFailureAlert(description: error.localizedDescription)
            }
        }
    }
    
    private func deleteItinteraryItem(event: ItineraryItem) {
        event.delete { [weak self] result in
            switch result {
            case .success(_):
                print("❎ Event Deleted!")
                if let row = self?.itineraryItems.firstIndex(where: {$0.objectId == event.objectId}) {
                    self?.itineraryItems.remove(at: row)
                    DispatchQueue.main.async {
                        self?.itineraryTableView.reloadData()
                        self?.showSucessAlert()
                    }
                }
            case .failure(let error):
                self?.showFailureAlert(description: error.localizedDescription)
            }
        }
    }
    
}

