//
//  FavouritesTableViewController.swift
//  WaterlooScholarships
//
//  Created by Aqeel Kamadia on 2017-10-15.
//  Copyright © 2017 Aqeel Kamadia. All rights reserved.
//

import Foundation
import UIKit

class FavouritesTableViewController: UITableViewController, NSKeyedUnarchiverDelegate, UISearchBarDelegate {
    
    var scholarships: [Scholarship] = []
    var filteredScholarships: [Scholarship] = []
    let defaults = UserDefaults.standard
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get scholarships from UserDefaults
        scholarships = NSKeyedUnarchiver.unarchiveObject(with: defaults.object(forKey: "Favourites") as! Data) as! [Scholarship]
        tableView.reloadData()
        searchBar.delegate = self
        searchBar.placeholder = "Filter scholarships"
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText: searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        tableView.reloadData()
    }
    
    func filterContentForSearchText(searchText: String) {
        if scholarships.count == 0 {
            return
        }
        filteredScholarships = scholarships.filter({(scholarship: Scholarship) -> Bool in
            return scholarship.title.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return !searchBarIsEmpty()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let viewController = segue.destination as! DetailsViewController
            if isFiltering() {
                viewController.scholarship = filteredScholarships[indexPath.row]
            }   else {
                viewController.scholarship = scholarships[indexPath.row]
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredScholarships.count
        }
        return scholarships.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouritesTableViewCell", for: indexPath) as! FavouritesTableViewCell
        let scholarship: Scholarship
        if isFiltering() {
            scholarship = filteredScholarships[indexPath.row]
        }   else {
            scholarship = scholarships[indexPath.row]
        }
        cell.title.text = scholarship.title
        return cell
    }
    
}
