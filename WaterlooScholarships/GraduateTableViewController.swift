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
    
    var scholarships: [Scholarship] = []
    var filteredScholarships: [Scholarship] = []
    var cellType = CellType.scholarshipCell
    let networkManager = NetworkManager()
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scholarshipNib = UINib(nibName: "ScholarshipTableViewCell", bundle: nil)
        let errorNib = UINib(nibName: "ErrorTableViewCell", bundle: nil)
        tableView.register(scholarshipNib, forCellReuseIdentifier: "ScholarshipTableViewCell")
        tableView.register(errorNib, forCellReuseIdentifier: "ErrorTableViewCell")
        networkManager.getGraduate(completion: { object in
            let grads = object["data"] as! [[String: AnyObject]]
            for grad in grads {
                self.scholarships.append(Scholarship(with: grad))
            }
            print(self.scholarships.count)
            self.tableView.reloadData()
        })
        searchBar.delegate = self
        searchBar.placeholder = "Search scholarships"
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
        guard scholarships.count != 0 else { return }
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
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let viewController = segue.destination as! DetailsViewController
        if isFiltering() {
            viewController.scholarship = filteredScholarships[indexPath.row]
        }   else {
            viewController.scholarship = scholarships[indexPath.row]
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            if filteredScholarships.count == 0 {
                cellType = .errorCell
                return 1
            }   else {
                cellType = .scholarshipCell
                return filteredScholarships.count
            }
        }
        cellType = .scholarshipCell
        return scholarships.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cellType {
        case .errorCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ErrorTableViewCell", for: indexPath) as! ErrorTableViewCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScholarshipTableViewCell", for: indexPath) as! ScholarshipTableViewCell
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gradSegue", sender: indexPath)
    }
}
