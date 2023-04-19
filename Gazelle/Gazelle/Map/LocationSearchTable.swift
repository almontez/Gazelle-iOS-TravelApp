//
//  LocationSearchTableViewController.swift
//  Gazelle
//
//  Created by Angela Li Montez on 4/18/23.
//
//  Citation: https://medium.com/@pravinbendre772/search-for-places-and-display-results-using-mapkit-a987bd6504df


import UIKit
import MapKit

class LocationSearchTable: UITableViewController {

    var matchingItems: [MKMapItem] = []
    var mapView: MKMapView? = nil
    var handleMapSearchDelegate: HandleMapSearch? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResult")!
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        let address = formatAddress(of: selectedItem)
        cell.detailTextLabel?.text = address
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        dismiss(animated: true, completion: nil)
    }

}

extension LocationSearchTable : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView,
              let searchBarText = searchController.searchBar.text else { return }
        
        let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = searchBarText
            request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else { return }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
}

func formatAddress(of selectedItem: MKPlacemark) -> String {
    var address = ""
    if selectedItem.subThoroughfare != nil {
        address += selectedItem.subThoroughfare! + " "
    }
    if selectedItem.thoroughfare != nil {
        address += selectedItem.thoroughfare! + ", "
    }
    if selectedItem.locality != nil {
        address += selectedItem.locality! + ", "
    }
    if selectedItem.administrativeArea != nil {
        address += selectedItem.administrativeArea! + " "
    }
    if selectedItem.postalCode != nil {
        address += selectedItem.postalCode! + ", "
    }
    if selectedItem.country != nil {
        address += selectedItem.country!
    }
    return address
}
