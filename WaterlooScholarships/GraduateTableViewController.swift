//
//  GraduateTableViewController.swift
//  WaterlooScholarships
//
//  Created by Aqeel Kamadia on 2017-10-15.
//  Copyright © 2017 Aqeel Kamadia. All rights reserved.
//

import Foundation
import UIKit

class GraduateTableViewController: UITableViewController, UISearchBarDelegate {
    
    let networkManager = NetworkManager()
    var scholarships: [Scholarship] = []
    var filteredScholarships: [Scholarship] = []
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.getGraduate(completion: { object in
            let grads = object["data"] as! [[String: AnyObject]]
            for grad in grads {
                self.scholarships.append(Scholarship(with: grad))
            }
            print(self.scholarships.count)
            self.tableView.reloadData()
        })
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
            let programs = scholarship.programs.filter({(program: String) -> Bool in
                return program.lowercased().contains(searchText.lowercased())
            })
            return scholarship.title.lowercased().contains(searchText.lowercased()) || programs.count > 0
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GraduateTableViewCell", for: indexPath) as! GraduateTableViewCell
        let scholarship: Scholarship
        if isFiltering() {
            scholarship = filteredScholarships[indexPath.row]
        }   else {
            scholarship = scholarships[indexPath.row]
        }
        cell.title.text = scholarship.title
        cell.value.text = scholarship.value
        return cell
    }
}
