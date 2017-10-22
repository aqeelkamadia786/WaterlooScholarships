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
    
    var scholarships: [Scholarship] = []
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scholarships = NSKeyedUnarchiver.unarchiveObject(with: defaults.object(forKey: "Favourites") as! Data) as! [Scholarship]
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Get scholarships from UserDefaults
        scholarships = NSKeyedUnarchiver.unarchiveObject(with: defaults.object(forKey: "Favourites") as! Data) as! [Scholarship]
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let viewController = segue.destination as! DetailsViewController
            viewController.scholarship = scholarships[indexPath.row]
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scholarships.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouritesTableViewCell", for: indexPath) as! FavouritesTableViewCell
        cell.title.text = scholarships[indexPath.row].title
        return cell
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
