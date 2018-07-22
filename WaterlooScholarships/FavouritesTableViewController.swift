//
//  FavouritesTableViewController.swift
//  WaterlooScholarships
//
//  Created by Aqeel Kamadia on 2017-10-15.
//  Copyright © 2017 Aqeel Kamadia. All rights reserved.
//

import Foundation
import UIKit

class FavouritesTableViewController: UITableViewController, NSKeyedUnarchiverDelegate {

    // MARK: - Properties
    
    var scholarships: [Scholarship] = []

    let defaults = UserDefaults.standard

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scholarshipNib = UINib(nibName: "ScholarshipTableViewCell", bundle: nil)
        tableView.register(scholarshipNib, forCellReuseIdentifier: "ScholarshipTableViewCell")
        if let favouritesData = defaults.object(forKey: "Favourites") as? Data {
            scholarships = NSKeyedUnarchiver.unarchiveObject(with: favouritesData) as! [Scholarship]
            tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Get scholarships from UserDefaults
        if let favouritesData = defaults.object(forKey: "Favourites") as? Data {
            scholarships = NSKeyedUnarchiver.unarchiveObject(with: favouritesData) as! [Scholarship]
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let viewController = segue.destination as! DetailsViewController
        viewController.scholarship = scholarships[indexPath.row]
    }

    // MARK: - UITableViewDataSource Conformance
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scholarships.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScholarshipTableViewCell", for: indexPath) as! ScholarshipTableViewCell
        cell.title.text = scholarships[indexPath.row].title
        cell.value.text = scholarships[indexPath.row].value
        return cell
    }

    // MARK: - UITableViewDelegate Conformance
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "favouriteSegue", sender: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            scholarships.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            defaults.set(NSKeyedArchiver.archivedData(withRootObject: scholarships), forKey: "Favourites")
            defaults.synchronize()
        }
    }

}
