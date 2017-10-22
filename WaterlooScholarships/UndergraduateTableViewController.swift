//
//  UndergraduateTableViewController.swift
//  WaterlooScholarships
//
//  Created by Aqeel Kamadia on 2017-10-12.
//  Copyright © 2017 Aqeel Kamadia. All rights reserved.
//

import Foundation
import UIKit

class UndergraduateTableViewController: UITableViewController, UISearchBarDelegate {
    
    let networkManager = NetworkManager()
    var scholarships: [Scholarship] = []
    var filteredScholarships: [Scholarship] = []
    let defaults = UserDefaults.standard
    @IBOutlet weak var searchBar: UISearchBar!
    let searchController = UISearchController(searchResultsController: nil)
//    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.getUndergraduate(completion: { object in
            let undergrads = object["data"] as! [[String: AnyObject]]
            for undergrad in undergrads {
                self.scholarships.append(Scholarship(with: undergrad))
            }
            print(self.scholarships.count)
            // Can't save [Scholarship] to UserDefaults
            let defaults = UserDefaults.standard
            let item = [self.scholarships[0]] as [Scholarship]
            defaults.set(NSKeyedArchiver.archivedData(withRootObject: item), forKey: "Favourites")
            for i in 1..<10 {
                var array = NSKeyedUnarchiver.unarchiveObject(with: defaults.object(forKey: "Favourites") as! Data) as! [Scholarship]
                array.append(self.scholarships[i])
                defaults.set(NSKeyedArchiver.archivedData(withRootObject: array), forKey: "Favourites")
                defaults.synchronize()
            }
            self.tableView.reloadData()
        })
        searchBar.delegate = self
        searchBar.placeholder = "Filter scholarships"
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText: searchText)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "UndergraduateTableViewCell", for: indexPath) as! UndergraduateTableViewCell
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

